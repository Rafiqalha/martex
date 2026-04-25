from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class ChildBase(BaseModel):
    age: int
    weight: int
    height: int
    status_gizi: str
    budget: str

class ChildCreate(ChildBase):
    pass

class ChildResponse(ChildBase):
    id: int

    class Config:
        from_attributes = True

class MeasurementBase(BaseModel):
    age: int
    weight: float
    height: float
    gender: str
    lat: float
    lng: float
    z_score: float
    status_gizi: Optional[str] = "Normal"

class MeasurementCreate(MeasurementBase):
    pass

class MeasurementResponse(MeasurementBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True

class SyncPayload(BaseModel):
    data: List[MeasurementCreate]

class NutritionRequest(BaseModel):
    child_id: Optional[int] = None
    age: Optional[int] = None
    status_gizi: Optional[str] = None
    budget: Optional[str] = None

class MealItem(BaseModel):
    pagi: str
    siang: str
    malam: str

class DayMenu(BaseModel):
    hari: int
    menu: MealItem

class NutritionRecommendationResponse(BaseModel):
    status: str
    recommendation: List[DayMenu]