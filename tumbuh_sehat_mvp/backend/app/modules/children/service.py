"""
Child business logic / service layer.
"""
from sqlalchemy.orm import Session
from typing import List, Optional

from app.modules.children.models import Child
from app.modules.children.schemas import ChildCreate, ChildUpdate


class ChildService:
    """Service layer untuk operasi anak."""

    @staticmethod
    def create(db: Session, data: ChildCreate) -> Child:
        """Daftarkan anak baru."""
        child = Child(**data.model_dump())
        db.add(child)
        db.commit()
        db.refresh(child)
        return child

    @staticmethod
    def get_all(db: Session) -> List[Child]:
        """Ambil semua anak terdaftar."""
        return db.query(Child).order_by(Child.created_at.desc()).all()

    @staticmethod
    def get_by_id(db: Session, child_id: int) -> Optional[Child]:
        """Ambil profil anak berdasarkan ID."""
        return db.query(Child).filter(Child.id == child_id).first()

    @staticmethod
    def update(db: Session, child_id: int, data: ChildUpdate) -> Optional[Child]:
        """Update data anak."""
        child = db.query(Child).filter(Child.id == child_id).first()
        if not child:
            return None
        update_data = data.model_dump(exclude_unset=True)
        for key, value in update_data.items():
            setattr(child, key, value)
        db.commit()
        db.refresh(child)
        return child

    @staticmethod
    def delete(db: Session, child_id: int) -> bool:
        """Hapus profil anak."""
        child = db.query(Child).filter(Child.id == child_id).first()
        if child:
            db.delete(child)
            db.commit()
            return True
        return False
