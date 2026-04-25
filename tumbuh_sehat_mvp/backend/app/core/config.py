"""
Konfigurasi aplikasi - semua environment variable terpusat di sini.
"""
import os
from functools import lru_cache
from pydantic_settings import BaseSettings
from dotenv import load_dotenv

load_dotenv()


class Settings(BaseSettings):
    """Settings terpusat untuk seluruh aplikasi."""

    # ── App ──────────────────────────────────────────
    APP_NAME: str = "TumbuhSehat API"
    APP_VERSION: str = "2.0.0"
    DEBUG: bool = True

    # ── Database ─────────────────────────────────────
    DATABASE_URL: str = os.getenv(
        "DATABASE_URL",
        "sqlite:///./tumbuhsehat_dev.db",
    )

    # ── Gemini AI ────────────────────────────────────
    GEMINI_API_KEY: str = os.getenv("GEMINI_API_KEY", "")
    GEMINI_MODEL: str = "gemini-2.0-flash"

    # ── CORS ─────────────────────────────────────────
    CORS_ORIGINS: list[str] = ["*"]

    class Config:
        env_file = ".env"
        extra = "ignore"


@lru_cache()
def get_settings() -> Settings:
    """Cached singleton untuk Settings."""
    return Settings()
