"""
Measurement business logic / service layer.
"""
from sqlalchemy.orm import Session
from sqlalchemy import func
from typing import List, Optional

from app.modules.measurements.models import Measurement
from app.modules.measurements.schemas import MeasurementCreate
from app.core.security import determine_status_gizi


class MeasurementService:
    """Service layer untuk semua operasi measurement."""

    @staticmethod
    def create(db: Session, data: MeasurementCreate) -> Measurement:
        """Simpan satu pengukuran baru."""
        status = determine_status_gizi(data.z_score)
        db_item = Measurement(
            age=data.age,
            weight=data.weight,
            height=data.height,
            gender=data.gender,
            lat=data.lat,
            lng=data.lng,
            z_score=data.z_score,
            status_gizi=status,
        )
        db.add(db_item)
        db.commit()
        db.refresh(db_item)
        return db_item

    @staticmethod
    def bulk_sync(db: Session, items: List[MeasurementCreate]) -> int:
        """Sync batch data dari Flutter offline mode."""
        count = 0
        for item in items:
            status = determine_status_gizi(item.z_score)
            db_item = Measurement(
                age=item.age,
                weight=item.weight,
                height=item.height,
                gender=item.gender,
                lat=item.lat,
                lng=item.lng,
                z_score=item.z_score,
                status_gizi=status,
            )
            db.add(db_item)
            count += 1
        db.commit()
        return count

    @staticmethod
    def get_all(db: Session, skip: int = 0, limit: int = 100) -> List[Measurement]:
        """Ambil semua pengukuran (terbaru dulu)."""
        return (
            db.query(Measurement)
            .order_by(Measurement.created_at.desc())
            .offset(skip)
            .limit(limit)
            .all()
        )

    @staticmethod
    def get_by_id(db: Session, measurement_id: int) -> Optional[Measurement]:
        """Ambil satu pengukuran berdasarkan ID."""
        return db.query(Measurement).filter(Measurement.id == measurement_id).first()

    @staticmethod
    def get_latest(db: Session) -> Optional[Measurement]:
        """Ambil pengukuran terbaru."""
        return db.query(Measurement).order_by(Measurement.created_at.desc()).first()

    @staticmethod
    def get_stats(db: Session) -> dict:
        """Hitung statistik ringkasan."""
        total = db.query(func.count(Measurement.id)).scalar() or 0
        avg_z = db.query(func.avg(Measurement.z_score)).scalar()

        stunting = (
            db.query(func.count(Measurement.id))
            .filter(Measurement.z_score < -2.0)
            .scalar() or 0
        )
        overweight = (
            db.query(func.count(Measurement.id))
            .filter(Measurement.z_score > 2.0)
            .scalar() or 0
        )
        normal = total - stunting - overweight

        # Unique "children" approximation by distinct (age, gender)
        children = (
            db.query(func.count(func.distinct(
                func.concat(Measurement.age, Measurement.gender)
            )))
            .scalar() or 0
        )

        return {
            "total_measurements": total,
            "total_children": children,
            "avg_z_score": round(avg_z, 2) if avg_z else None,
            "stunting_count": stunting,
            "normal_count": normal,
            "overweight_count": overweight,
        }

    @staticmethod
    def delete(db: Session, measurement_id: int) -> bool:
        """Hapus pengukuran berdasarkan ID."""
        item = db.query(Measurement).filter(Measurement.id == measurement_id).first()
        if item:
            db.delete(item)
            db.commit()
            return True
        return False
