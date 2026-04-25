"""
Nutrition AI Service - Gemini integration for meal plan generation.
"""
import os
import json
import logging
from typing import Optional, List

import google.generativeai as genai
from sqlalchemy.orm import Session

from app.core.config import get_settings
from app.modules.nutrition.models import Recommendation
from app.modules.children.models import Child

logger = logging.getLogger(__name__)


class NutritionService:
    """Service layer untuk generasi rekomendasi nutrisi via Gemini AI."""

    _ai_model = None

    @classmethod
    def _get_ai_model(cls):
        """Lazy-init Gemini model (singleton)."""
        if cls._ai_model is None:
            settings = get_settings()
            genai.configure(api_key=settings.GEMINI_API_KEY)
            cls._ai_model = genai.GenerativeModel(
                settings.GEMINI_MODEL,
                generation_config={"response_mime_type": "application/json"},
            )
        return cls._ai_model

    @staticmethod
    def _get_nutrition_focus(status_gizi: str) -> str:
        """Mapping status gizi → fokus nutrisi."""
        mapping = {
            "stunting": "tinggi protein hewani, kalsium, dan zat besi untuk mengejar pertumbuhan",
            "underweight": "tinggi kalori dan protein untuk menaikkan berat badan",
            "stunting/underweight": "tinggi protein hewani, kalsium, dan zat besi untuk mengejar pertumbuhan",
            "gizi buruk": "tinggi kalori, protein, dan micronutrient untuk pemulihan",
            "overweight": "kontrol kalori, tinggi serat dan sayuran",
            "normal": "gizi seimbang untuk mempertahankan tumbuh kembang optimal",
        }
        return mapping.get(status_gizi.lower(), "gizi seimbang")

    @staticmethod
    def _get_budget_description(budget: str) -> str:
        """Mapping budget → deskripsi bahan makanan."""
        mapping = {
            "low": "ekonomis (tempe, tahu, telur, ikan lokal murah, sayuran pasar)",
            "medium": "menengah (ayam, telur, ikan segar, tahu-tempe, buah lokal)",
            "high": "variasi luas (daging sapi, ikan salmon/tenggiri, susu, buah import, keju)",
        }
        return mapping.get(budget.lower(), "ekonomis")

    @classmethod
    def _build_prompt(cls, age: int, status_gizi: str, budget: str) -> str:
        """Bangun prompt yang optimal untuk Gemini."""
        nutrition_focus = cls._get_nutrition_focus(status_gizi)
        budget_desc = cls._get_budget_description(budget)

        return f"""
Kamu adalah ahli gizi anak Indonesia yang berpengalaman.
Buatkan rekomendasi menu makanan balita untuk 7 hari (1 minggu penuh).

KRITERIA ANAK:
- Usia: {age} bulan
- Status Gizi: {status_gizi} (Fokus: {nutrition_focus})
- Kategori Budget: {budget} ({budget_desc})

ATURAN MENU:
- Gunakan bahan lokal Indonesia (tempe, tahu, ikan lokal, sayuran lokal)
- Tekstur harus sesuai usia: {"bubur halus/puree" if age <= 8 else "cincang halus" if age <= 12 else "cincang kasar/nasi lembek" if age <= 24 else "makanan keluarga bertekstur lembut"}
- TIDAK BOLEH pedas, tidak boleh mengandung madu (untuk < 12 bulan)
- Porsi sesuai usia balita, BUKAN porsi dewasa
- Setiap hari HARUS berbeda menu-nya (variasi tinggi)
- Deskripsikan menu secara singkat dan jelas (max 30 kata per waktu makan)

FORMAT OUTPUT WAJIB (JSON murni, tanpa markdown):
{{
    "recommendation": [
        {{
            "hari": 1,
            "menu": {{
                "pagi": "Bubur nasi + telur rebus cincang + bayam",
                "siang": "Nasi lembek + ayam suwir + tumis wortel",
                "malam": "Sup ikan + tahu kukus + labu kuning"
            }}
        }},
        {{
            "hari": 2,
            "menu": {{
                "pagi": "...",
                "siang": "...",
                "malam": "..."
            }}
        }}
    ]
}}

PENTING: Output HARUS berisi tepat 7 hari (hari 1 sampai 7).
"""

    @classmethod
    async def generate_recommendation(
        cls,
        db: Session,
        age: int,
        status_gizi: str,
        budget: str,
        child_id: Optional[int] = None,
    ) -> dict:
        """
        Generate rekomendasi nutrisi via Gemini AI.
        Returns dict yang siap dikirim ke Flutter.
        """
        prompt = cls._build_prompt(age, status_gizi, budget)
        model = cls._get_ai_model()

        try:
            response = model.generate_content(prompt)
            text = response.text.strip()

            # Safety: ekstraksi JSON jika dibungkus markdown
            if "```json" in text:
                text = text.split("```json")[1].split("```")[0].strip()
            elif "```" in text:
                text = text.split("```")[1].split("```")[0].strip()

            menu_data = json.loads(text)

            # Validasi structure
            recommendation = menu_data.get("recommendation", [])
            if not recommendation or not isinstance(recommendation, list):
                raise ValueError("Format AI response tidak valid - missing 'recommendation' array")

            # Validasi setiap hari memiliki struktur yang benar
            for day in recommendation:
                if "hari" not in day or "menu" not in day:
                    raise ValueError(f"Format hari tidak valid: {day}")
                menu = day["menu"]
                if not all(k in menu for k in ("pagi", "siang", "malam")):
                    raise ValueError(f"Format menu tidak lengkap: {menu}")

            # Simpan ke database untuk audit trail
            new_rec = Recommendation(
                child_id=child_id,
                daily_plan=recommendation,
                request_params={
                    "age": age,
                    "status_gizi": status_gizi,
                    "budget": budget,
                },
            )
            db.add(new_rec)
            db.commit()

            return {
                "status": "success",
                "recommendation": recommendation,
            }

        except json.JSONDecodeError as e:
            logger.error(f"JSON parse error dari Gemini: {e}")
            raise ValueError(f"AI response bukan JSON valid: {str(e)}")
        except Exception as e:
            logger.error(f"Gemini AI error: {e}")
            raise

    @staticmethod
    def get_history(db: Session, child_id: Optional[int] = None, limit: int = 10) -> List[Recommendation]:
        """Ambil riwayat rekomendasi."""
        query = db.query(Recommendation).order_by(Recommendation.created_at.desc())
        if child_id:
            query = query.filter(Recommendation.child_id == child_id)
        return query.limit(limit).all()

    @staticmethod
    def get_by_id(db: Session, rec_id: int) -> Optional[Recommendation]:
        """Ambil satu rekomendasi berdasarkan ID."""
        return db.query(Recommendation).filter(Recommendation.id == rec_id).first()
