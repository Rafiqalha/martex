"""
Nutrition Pydantic schemas.
Matches Flutter's NutritionRecommendationScreen expectations exactly.
"""
from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime


# ── Request ──────────────────────────────────────────
class NutritionRequest(BaseModel):
    """
    Request dari Flutter NutritionRecommendationScreen.
    Bisa kirim child_id (lookup dari DB) atau langsung age/status/budget.
    """
    child_id: Optional[int] = None
    age: Optional[int] = Field(None, ge=0, le=60, description="Usia dalam bulan")
    status_gizi: Optional[str] = Field(None, description="Stunting/Underweight, Normal, Overweight")
    budget: Optional[str] = Field(None, description="low, medium, high")


# ── Response Sub-models ──────────────────────────────
class MealItem(BaseModel):
    """Menu per waktu makan."""
    pagi: str
    siang: str
    malam: str


class DayMenu(BaseModel):
    """Menu satu hari."""
    hari: int
    menu: MealItem


class NutritionRecommendationResponse(BaseModel):
    """
    Response yang dikirim ke Flutter.
    Flutter expects: { "status": "success", "recommendation": [...] }
    """
    status: str
    recommendation: List[DayMenu]


# ── History Response ─────────────────────────────────
class RecommendationHistoryResponse(BaseModel):
    """Response riwayat rekomendasi."""
    id: int
    child_id: Optional[int] = None
    daily_plan: list
    request_params: Optional[dict] = None
    created_at: datetime

    class Config:
        from_attributes = True
