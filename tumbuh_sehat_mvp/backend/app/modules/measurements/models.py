"""
Measurement SQLAlchemy models.
"""
from sqlalchemy import Column, Integer, Float, String, DateTime
import datetime

from app.core.database import Base


class Measurement(Base):
    """Tabel pengukuran pertumbuhan anak (dari Flutter mobile app)."""

    __tablename__ = "measurements"

    id = Column(Integer, primary_key=True, index=True)
    age = Column(Integer, nullable=False, comment="Usia dalam bulan")
    weight = Column(Float, nullable=False, comment="Berat badan (kg)")
    height = Column(Float, nullable=False, comment="Tinggi badan (cm)")
    gender = Column(String(1), nullable=False, comment="L=Laki-laki, P=Perempuan")
    lat = Column(Float, nullable=False, comment="Latitude lokasi")
    lng = Column(Float, nullable=False, comment="Longitude lokasi")
    z_score = Column(Float, nullable=False, comment="WHO Z-Score")
    status_gizi = Column(String(50), default="Normal", comment="Status gizi berdasarkan Z-Score")
    created_at = Column(DateTime, default=datetime.datetime.utcnow)
