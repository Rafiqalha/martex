from sqlalchemy import Column, Integer, String, JSON, ForeignKey, DateTime, Float
from sqlalchemy.orm import relationship
from database import Base
import datetime

class Child(Base):
    __tablename__ = "children"

    id = Column(Integer, primary_key=True, index=True)
    age = Column(Integer, nullable=False) # in months
    weight = Column(Float, nullable=False)   # weight in kg/gr
    height = Column(Float, nullable=False)   # height in cm
    status_gizi = Column(String, nullable=False) # stunting / underweight / overweight / normal
    budget = Column(String, nullable=False)      # low / medium / high

class Recommendation(Base):
    __tablename__ = "recommendations"

    id = Column(Integer, primary_key=True, index=True)
    child_id = Column(Integer, ForeignKey("children.id"))
    daily_plan = Column(JSON, nullable=False) # Stores the menu (daily)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)

class Measurement(Base):
    __tablename__ = "measurements"

    id = Column(Integer, primary_key=True, index=True)
    age = Column(Integer)
    weight = Column(Float)
    height = Column(Float)
    gender = Column(String)
    lat = Column(Float)
    lng = Column(Float)
    z_score = Column(Float)
    status_gizi = Column(String)
    created_at = Column(DateTime, default=datetime.datetime.utcnow)