"""
Security utilities - Z-Score calculation (WHO standard approximation).
"""
import math


def calculate_z_score(weight: float, height: float, age: int, gender: str) -> float:
    """
    Hitung Z-Score berdasarkan WHO Child Growth Standards.
    Ini adalah simplified approximation - idealnya menggunakan WHO LMS tables.

    Returns:
        Z-Score (float) di mana:
        - < -3 : Gizi buruk / Severely stunted
        - < -2 : Gizi kurang / Stunted/Underweight
        - -2 to 2 : Normal
        - > 2 : Overweight / Obesitas
    """
    # BMI-based Z-score approximation
    height_m = height / 100.0
    if height_m <= 0:
        return 0.0

    bmi = weight / (height_m * height_m)

    # Simplified median & SD berdasarkan usia (bulan) dan gender
    # Referensi: WHO Child Growth Standards (simplified)
    if gender.upper() in ("L", "M", "MALE"):
        if age <= 12:
            median_bmi = 16.5
            sd = 1.5
        elif age <= 24:
            median_bmi = 16.0
            sd = 1.4
        elif age <= 36:
            median_bmi = 15.8
            sd = 1.3
        elif age <= 48:
            median_bmi = 15.5
            sd = 1.2
        else:
            median_bmi = 15.3
            sd = 1.2
    else:  # Perempuan
        if age <= 12:
            median_bmi = 16.0
            sd = 1.4
        elif age <= 24:
            median_bmi = 15.7
            sd = 1.3
        elif age <= 36:
            median_bmi = 15.5
            sd = 1.3
        elif age <= 48:
            median_bmi = 15.2
            sd = 1.2
        else:
            median_bmi = 15.0
            sd = 1.2

    z = (bmi - median_bmi) / sd
    # Clamp ke range yang masuk akal
    return max(-5.0, min(5.0, round(z, 2)))


def determine_status_gizi(z_score: float) -> str:
    """Tentukan status gizi berdasarkan Z-Score."""
    if z_score < -3.0:
        return "Gizi Buruk"
    elif z_score < -2.0:
        return "Stunting/Underweight"
    elif z_score > 2.0:
        return "Overweight"
    else:
        return "Normal"
