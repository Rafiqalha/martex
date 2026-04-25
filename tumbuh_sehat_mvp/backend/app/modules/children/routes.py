"""
Child API routes - CRUD profil anak.
"""
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from app.core.database import get_db
from app.modules.children.schemas import ChildCreate, ChildUpdate, ChildResponse
from app.modules.children.service import ChildService

router = APIRouter(
    prefix="/api/children",
    tags=["👶 Children"],
)


@router.post("", response_model=ChildResponse, status_code=201)
def create_child(data: ChildCreate, db: Session = Depends(get_db)):
    """Daftarkan profil anak baru."""
    return ChildService.create(db, data)


@router.get("", response_model=List[ChildResponse])
def get_children(db: Session = Depends(get_db)):
    """Ambil semua anak terdaftar."""
    return ChildService.get_all(db)


@router.get("/{child_id}", response_model=ChildResponse)
def get_child(child_id: int, db: Session = Depends(get_db)):
    """Ambil profil anak berdasarkan ID."""
    child = ChildService.get_by_id(db, child_id)
    if not child:
        raise HTTPException(status_code=404, detail="Anak tidak ditemukan")
    return child


@router.put("/{child_id}", response_model=ChildResponse)
def update_child(child_id: int, data: ChildUpdate, db: Session = Depends(get_db)):
    """Update data anak."""
    child = ChildService.update(db, child_id, data)
    if not child:
        raise HTTPException(status_code=404, detail="Anak tidak ditemukan")
    return child


@router.delete("/{child_id}")
def delete_child(child_id: int, db: Session = Depends(get_db)):
    """Hapus profil anak."""
    success = ChildService.delete(db, child_id)
    if not success:
        raise HTTPException(status_code=404, detail="Anak tidak ditemukan")
    return {"status": "success", "message": "Profil anak berhasil dihapus"}
