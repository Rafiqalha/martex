import os
from fastapi import FastAPI, Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from typing import List
from dotenv import load_dotenv

import models
import schemas
from database import engine, get_db
import routes

load_dotenv()

models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="TumbuhSehat API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ==========================================
# MENYAMBUNGKAN ROUTER MODULAR
# ==========================================
app.include_router(routes.router)

# ==========================================
# ENDPOINT LAINNYA (Misal: Sync Data Flutter)
# ==========================================
@app.post("/api/measurements/sync")
def sync_measurements(payload: schemas.SyncPayload, db: Session = Depends(get_db)):
    inserted_records = []
    for item in payload.data:
        db_item = models.Measurement(**item.model_dump())
        db.add(db_item)
        inserted_records.append(db_item)
    db.commit()
    return {"status": "success", "synced_count": len(inserted_records)}

@app.get("/api/measurements", response_model=List[schemas.MeasurementResponse])
def get_measurements(db: Session = Depends(get_db)):
    return db.query(models.Measurement).order_by(models.Measurement.created_at.desc()).all()