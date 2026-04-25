"""
Measurement API routes.
Digunakan oleh Flutter untuk:
  - Sync data offline → POST /api/measurements/sync
  - Fetch semua data  → GET  /api/measurements
  - Fetch satu data   → GET  /api/measurements/{id}
  - Hapus data         → DELETE /api/measurements/{id}
  - Statistik          → GET  /api/measurements/stats
  - Data terbaru       → GET  /api/measurements/latest
"""
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from app.core.database import get_db
from app.modules.measurements.schemas import (
    MeasurementResponse,
    SyncPayload,
    SyncResponse,
    StatsResponse,
)
from app.modules.measurements.service import MeasurementService

router = APIRouter(
    prefix="/api/measurements",
    tags=["📏 Measurements"],
)


@router.post("/sync", response_model=SyncResponse)
def sync_measurements(payload: SyncPayload, db: Session = Depends(get_db)):
    """
    Bulk sync dari Flutter offline-first mode.
    Menerima array pengukuran dan menyimpan sekaligus.
    """
    count = MeasurementService.bulk_sync(db, payload.data)
    return {"status": "success", "synced_count": count}


@router.get("", response_model=List[MeasurementResponse])
def get_measurements(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
):
    """Ambil semua data pengukuran (terbaru dulu) dengan pagination."""
    return MeasurementService.get_all(db, skip=skip, limit=limit)


@router.get("/stats", response_model=StatsResponse)
def get_stats(db: Session = Depends(get_db)):
    """Statistik ringkasan data pertumbuhan."""
    return MeasurementService.get_stats(db)


@router.get("/latest", response_model=MeasurementResponse)
def get_latest(db: Session = Depends(get_db)):
    """Ambil pengukuran paling terbaru (dipakai HomeScreen Flutter)."""
    item = MeasurementService.get_latest(db)
    if not item:
        raise HTTPException(status_code=404, detail="Belum ada data pengukuran")
    return item


@router.get("/{measurement_id}", response_model=MeasurementResponse)
def get_measurement(measurement_id: int, db: Session = Depends(get_db)):
    """Ambil satu pengukuran berdasarkan ID."""
    item = MeasurementService.get_by_id(db, measurement_id)
    if not item:
        raise HTTPException(status_code=404, detail="Data tidak ditemukan")
    return item


@router.delete("/{measurement_id}")
def delete_measurement(measurement_id: int, db: Session = Depends(get_db)):
    """Hapus data pengukuran."""
    success = MeasurementService.delete(db, measurement_id)
    if not success:
        raise HTTPException(status_code=404, detail="Data tidak ditemukan")
    return {"status": "success", "message": "Data berhasil dihapus"}
