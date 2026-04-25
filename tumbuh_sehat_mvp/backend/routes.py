import os
import json
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
import google.generativeai as genai

import models
import schemas
from database import get_db

# 1. Inisialisasi Router (Pengganti 'app')
router = APIRouter(
    prefix="/api/nutrition",
    tags=["Nutrition AI"]
)

# 2. Konfigurasi Model Gemini
genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
ai_model = genai.GenerativeModel(
    'gemini-3-flash-preview',
    generation_config={"response_mime_type": "application/json"}
)

# 3. Endpoint Rekomendasi (Gunakan @router, BUKAN @app)
@router.post("/recommendation", response_model=schemas.NutritionRecommendationResponse)
async def get_nutrition_recommendation(req: schemas.NutritionRequest, db: Session = Depends(get_db)):
    # Validasi Input & Ambil Data
    age = req.age
    status_gizi = req.status_gizi
    budget = req.budget

    if req.child_id:
        child = db.query(models.Child).filter(models.Child.id == req.child_id).first()
        if child:
            age = child.age
            status_gizi = child.status_gizi
            budget = child.budget
    
    if not age or not status_gizi or not budget:
        raise HTTPException(status_code=400, detail=f"Data tidak lengkap (age: {age}, status_gizi: {status_gizi}, budget: {budget})")

    # Pemetaan Logika Nutrisi
    nutrition_focus = {
        "stunting": "tinggi protein hewani dan zat besi",
        "underweight": "tinggi kalori dan protein",
        "overweight": "kontrol kalori, tinggi serat dan sayuran",
        "normal": "gizi seimbang"
    }.get(status_gizi.lower(), "gizi seimbang")

    budget_desc = {
        "low": "ekonomis (tempe, tahu, telur, ikan lokal murah)",
        "medium": "kombinasi (ayam, telur, ikan, daging sesekali)",
        "high": "variasi luas (daging sapi, ikan salmon/tenggiri, susu, buah import)"
    }.get(budget.lower(), "ekonomis")

    # Prompt Gemini
    prompt = f"""
    Berikan rekomendasi menu makanan balita untuk 7 hari (mingguan) dengan kriteria:
    - Usia: {age} bulan
    - Status Gizi: {status_gizi} (Fokus: {nutrition_focus})
    - Kategori Budget: {budget} ({budget_desc})
    - Menggunakan bahan lokal Indonesia (seperti tempe, tahu, ikan lokal, sayuran lokal)
    - Tekstur: Lembut, mudah dikunyah, tidak pedas, ramah untuk balita
    
    Format output HARUS JSON murni:
    {{
        "recommendation": [
            {{
                "hari": 1,
                "menu": {{
                    "pagi": "...",
                    "siang": "...",
                    "malam": "..."
                }}
            }}
        ]
    }}
    """

    try:
        response = ai_model.generate_content(prompt)
        text = response.text.strip()
        
        # Ekstraksi JSON yang aman (jika model mengembalikan markdown)
        if "```json" in text:
            text = text.split("```json")[1].split("```")[0].strip()
        elif "```" in text:
            text = text.split("```")[1].split("```")[0].strip()
        
        menu_data = json.loads(text)
        
        # Simpan ke Database
        if req.child_id:
            new_rec = models.Recommendation(
                child_id=req.child_id,
                daily_plan=menu_data["recommendation"]
            )
            db.add(new_rec)
            db.commit()

        return {
            "status": "success",
            "recommendation": menu_data["recommendation"]
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"AI Error: {str(e)}")