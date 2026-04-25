"""
Child Pydantic schemas.
"""
from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime


class ChildCreate(BaseModel):
    """Schema untuk mendaftarkan anak baru."""
    name: Optional[str] = Field(None, max_length=100, description="Nama anak")
    age: int = Field(..., ge=0, le=60, description="Usia dalam bulan")
    weight: float = Field(..., gt=0, description="Berat badan (kg)")
    height: float = Field(..., gt=0, description="Tinggi badan (cm)")
    gender: str = Field(default="L", description="L atau P")
    status_gizi: str = Field(..., description="stunting/underweight/overweight/normal")
    budget: str = Field(..., description="low/medium/high")


class ChildUpdate(BaseModel):
    """Schema untuk update data anak."""
    name: Optional[str] = None
    age: Optional[int] = None
    weight: Optional[float] = None
    height: Optional[float] = None
    gender: Optional[str] = None
    status_gizi: Optional[str] = None
    budget: Optional[str] = None


class ChildResponse(BaseModel):
    """Schema response profil anak."""
    id: int
    name: Optional[str] = None
    age: int
    weight: float
    height: float
    gender: str
    status_gizi: str
    budget: str
    created_at: datetime
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True
