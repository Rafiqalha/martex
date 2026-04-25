"""
Map / Stunting Geospatial API routes.
Menyediakan data prevalensi stunting per provinsi (SSGI 2024).
Digunakan oleh MapScreen Flutter.
"""
from fastapi import APIRouter
from typing import List
from pydantic import BaseModel


router = APIRouter(
    prefix="/api/map",
    tags=["🗺️ Map & Geospatial"],
)


# ── Data SSGI 2024 ───────────────────────────────────
SSGI_2024_DATA = {
    "ACEH": 28.6,
    "SUMATERA UTARA": 22.0,
    "SUMATERA BARAT": 24.9,
    "RIAU": 20.1,
    "JAMBI": 17.1,
    "SUMATERA SELATAN": 15.9,
    "BENGKULU": 18.8,
    "LAMPUNG": 15.9,
    "BANGKA BELITUNG": 20.1,
    "KEPULAUAN RIAU": 15.0,
    "DKI JAKARTA": 17.3,
    "JAWA BARAT": 15.9,
    "JAWA TENGAH": 17.1,
    "DI YOGYAKARTA": 17.4,
    "JAWA TIMUR": 14.7,
    "BANTEN": 21.1,
    "BALI": 8.7,
    "NUSA TENGGARA BARAT": 29.8,
    "NUSA TENGGARA TIMUR": 37.0,
    "KALIMANTAN BARAT": 26.8,
    "KALIMANTAN TENGAH": 22.1,
    "KALIMANTAN SELATAN": 22.9,
    "KALIMANTAN TIMUR": 22.2,
    "KALIMANTAN UTARA": 17.6,
    "SULAWESI UTARA": 21.3,
    "SULAWESI TENGAH": 27.2,
    "SULAWESI SELATAN": 27.4,
    "SULAWESI TENGGARA": 30.0,
    "GORONTALO": 26.9,
    "SULAWESI BARAT": 30.3,
    "MALUKU": 28.4,
    "MALUKU UTARA": 24.7,
    "PAPUA BARAT": 24.8,
    "PAPUA": 28.6,
}


class ProvinceStunting(BaseModel):
    """Data prevalensi stunting per provinsi."""
    province: str
    prevalence: float
    severity: str  # low, medium, high


class StuntingNationalSummary(BaseModel):
    """Ringkasan nasional."""
    total_provinces: int
    national_average: float
    high_risk_provinces: int
    medium_risk_provinces: int
    low_risk_provinces: int
    provinces: List[ProvinceStunting]


def _get_severity(prevalence: float) -> str:
    """Categorize severity berdasarkan prevalensi."""
    if prevalence >= 30.0:
        return "high"
    elif prevalence >= 20.0:
        return "medium"
    return "low"


@router.get("/stunting-prevalence", response_model=StuntingNationalSummary)
def get_stunting_prevalence():
    """
    Data prevalensi stunting per provinsi (SSGI 2024).
    Digunakan MapScreen Flutter untuk pewarnaan peta.
    """
    provinces = []
    for name, prev in SSGI_2024_DATA.items():
        provinces.append(ProvinceStunting(
            province=name,
            prevalence=prev,
            severity=_get_severity(prev),
        ))

    # Sort by prevalence descending
    provinces.sort(key=lambda x: x.prevalence, reverse=True)

    values = list(SSGI_2024_DATA.values())
    avg = sum(values) / len(values) if values else 0

    return StuntingNationalSummary(
        total_provinces=len(provinces),
        national_average=round(avg, 1),
        high_risk_provinces=sum(1 for p in provinces if p.severity == "high"),
        medium_risk_provinces=sum(1 for p in provinces if p.severity == "medium"),
        low_risk_provinces=sum(1 for p in provinces if p.severity == "low"),
        provinces=provinces,
    )


@router.get("/stunting-prevalence/{province_name}")
def get_province_stunting(province_name: str):
    """Data stunting untuk satu provinsi."""
    name_upper = province_name.upper()
    for key, value in SSGI_2024_DATA.items():
        if key == name_upper or name_upper in key or key in name_upper:
            return {
                "province": key,
                "prevalence": value,
                "severity": _get_severity(value),
            }
    return {"error": f"Provinsi '{province_name}' tidak ditemukan"}
