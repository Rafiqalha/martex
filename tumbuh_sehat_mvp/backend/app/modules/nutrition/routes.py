"""
Nutrition AI API routes.
Endpoint utama:
  - POST /api/nutrition/recommendation → Generate menu mingguan via Gemini
  - GET  /api/nutrition/history        → Riwayat rekomendasi
  - GET  /api/nutrition/history/{id}   → Detail satu rekomendasi
"""
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from app.core.database import get_db
from app.modules.nutrition.schemas import (
    NutritionRequest,
    NutritionRecommendationResponse,
    RecommendationHistoryResponse,
)
from app.modules.nutrition.service import NutritionService
from app.modules.children.models import Child

router = APIRouter(
    prefix="/api/nutrition",
    tags=["🤖 Nutrition AI"],
)


@router.post("/recommendation", response_model=NutritionRecommendationResponse)
async def get_nutrition_recommendation(
    req: NutritionRequest,
    db: Session = Depends(get_db),
):
    """
    Generate rekomendasi menu mingguan via Gemini AI.

    Bisa menerima:
    - child_id → lookup data anak dari DB
    - ATAU langsung kirim age, status_gizi, budget
    """
    age = req.age
    status_gizi = req.status_gizi
    budget = req.budget
    child_id = req.child_id

    # Jika ada child_id, lookup dari database
    if child_id:
        child = db.query(Child).filter(Child.id == child_id).first()
        if child:
            age = age or child.age
            status_gizi = status_gizi or child.status_gizi
            budget = budget or child.budget

    # Validasi kelengkapan data
    if not age or not status_gizi or not budget:
        raise HTTPException(
            status_code=400,
            detail=f"Data tidak lengkap. Dibutuhkan: age={age}, status_gizi={status_gizi}, budget={budget}",
        )

    try:
        result = await NutritionService.generate_recommendation(
            db=db,
            age=age,
            status_gizi=status_gizi,
            budget=budget,
            child_id=child_id,
        )
        return result
    except ValueError as e:
        raise HTTPException(status_code=422, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"AI Error: {str(e)}")


@router.get("/history", response_model=List[RecommendationHistoryResponse])
def get_recommendation_history(
    child_id: int = None,
    limit: int = 10,
    db: Session = Depends(get_db),
):
    """Ambil riwayat rekomendasi nutrisi."""
    return NutritionService.get_history(db, child_id=child_id, limit=limit)


@router.get("/history/{rec_id}", response_model=RecommendationHistoryResponse)
def get_recommendation_detail(rec_id: int, db: Session = Depends(get_db)):
    """Ambil detail satu rekomendasi."""
    rec = NutritionService.get_by_id(db, rec_id)
    if not rec:
        raise HTTPException(status_code=404, detail="Rekomendasi tidak ditemukan")
    return rec
