from pydantic import BaseModel
from typing import List
from datetime import datetime

class MeasurementBase(BaseModel):
    age: int
    weight: float
    height: float
    gender: str
    lat: float
    lng: float
    z_score: float

class MeasurementCreate(MeasurementBase):
    pass

class MeasurementResponse(MeasurementBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True

class SyncPayload(BaseModel):
    data: List[MeasurementCreate]