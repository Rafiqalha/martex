"""
Recommendation SQLAlchemy model.
"""
from sqlalchemy import Column, Integer, ForeignKey, JSON, DateTime
from sqlalchemy.orm import relationship
import datetime

from app.core.database import Base


class Recommendation(Base):
    """Tabel rekomendasi nutrisi yang di-generate oleh Gemini AI."""

    __tablename__ = "recommendations"

    id = Column(Integer, primary_key=True, index=True)
    child_id = Column(Integer, ForeignKey("children.id"), nullable=True)
    daily_plan = Column(JSON, nullable=False, comment="Menu harian/mingguan dari AI")
    request_params = Column(JSON, nullable=True, comment="Parameter request (age, status, budget)")
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

    # Relationship
    child = relationship("Child", back_populates="recommendations")
