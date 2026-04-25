"""
Child SQLAlchemy model.
"""
from sqlalchemy import Column, Integer, Float, String, DateTime
from sqlalchemy.orm import relationship
import datetime

from app.core.database import Base


class Child(Base):
    """Tabel profil anak terdaftar."""

    __tablename__ = "children"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(100), nullable=True, comment="Nama anak")
    age = Column(Integer, nullable=False, comment="Usia dalam bulan")
    weight = Column(Float, nullable=False, comment="Berat badan (kg)")
    height = Column(Float, nullable=False, comment="Tinggi badan (cm)")
    gender = Column(String(1), default="L", comment="L=Laki-laki, P=Perempuan")
    status_gizi = Column(String(50), nullable=False, comment="stunting/underweight/overweight/normal")
    budget = Column(String(20), nullable=False, comment="low/medium/high")
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
    updated_at = Column(DateTime, default=datetime.datetime.utcnow, onupdate=datetime.datetime.utcnow)

    # Relationship ke recommendations
    recommendations = relationship("Recommendation", back_populates="child", lazy="dynamic")
