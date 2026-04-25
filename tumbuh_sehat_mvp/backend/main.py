from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

measurements_db = [
    {"lat": -0.7893, "lng": 113.9213, "age": 24, "z_score": -2.5},
    {"lat": -2.5489, "lng": 118.0149, "age": 12, "z_score": 1.2}
]

class Measurement(BaseModel):
    age: int
    weight: float
    height: float
    lat: float
    lng: float
    z_score: float

@app.post("/api/measurements")
def create_measurement(data: Measurement):
    new_data = data.model_dump()
    measurements_db.append(new_data)
    return {"status": "success", "data": new_data}

@app.get("/api/measurements", response_model=List[dict])
def get_measurements():
    return measurements_db