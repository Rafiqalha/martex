"""
Measurement Pydantic schemas for request/response validation.
"""
from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import datetime


# ── Request Schemas ──────────────────────────────────
class MeasurementCreate(BaseModel):
    """Schema untuk membuat pengukuran baru (dari Flutter)."""
    age: int = Field(..., ge=0, le=60, description="Usia bayi dalam bulan")
    weight: float = Field(..., gt=0, description="Berat badan (kg)")
    height: float = Field(..., gt=0, description="Tinggi badan (cm)")
    gender: str = Field(..., min_length=1, max_length=1, description="L atau P")
    lat: float = Field(..., description="Latitude")
    lng: float = Field(..., description="Longitude")
    z_score: float = Field(..., description="Z-Score dari client")
    status_gizi: Optional[str] = Field(default="Normal", description="Status gizi")


class SyncPayload(BaseModel):
    """Schema untuk bulk sync dari Flutter offline-first mode."""
    data: List[MeasurementCreate]


# ── Response Schemas ─────────────────────────────────
class MeasurementResponse(BaseModel):
    """Schema response untuk data pengukuran."""
    id: int
    age: int
    weight: float
    height: float
    gender: str
    lat: float
    lng: float
    z_score: float
    status_gizi: Optional[str] = None
    created_at: datetime

    class Config:
        from_attributes = True


class SyncResponse(BaseModel):
    """Response setelah sync berhasil."""
    status: str
    synced_count: int


class StatsResponse(BaseModel):
    """Statistik ringkasan data pengukuran."""
    total_measurements: int
    total_children: int
    avg_z_score: Optional[float] = None
    stunting_count: int
    normal_count: int
    overweight_count: int
