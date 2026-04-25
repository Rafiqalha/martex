from sqlalchemy import Column, Integer, Float, String, DateTime
from sqlalchemy.sql import func
from database import Base

class Measurement(Base):
    __tablename__ = "measurements"

    id = Column(Integer, primary_key=True, index=True)
    age = Column(Integer, nullable=False)
    weight = Column(Float, nullable=False)
    height = Column(Float, nullable=False)
    gender = Column(String(1), nullable=False)
    lat = Column(Float, nullable=False)
    lng = Column(Float, nullable=False)
    z_score = Column(Float, nullable=False)
    created_at = Column(DateTime(timezone=True), server_default=func.now())