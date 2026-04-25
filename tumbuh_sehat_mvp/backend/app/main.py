"""
TumbuhSehat API - Modular FastAPI Application.

Struktur:
    app/
    ├── core/           → Config, Database, Security
    ├── modules/
    │   ├── measurements/  → Sync & tracking pertumbuhan anak
    │   ├── children/      → Profil anak terdaftar
    │   ├── nutrition/     → AI Gemini recommendation engine
    │   └── map/           → Geospatial stunting data
    └── main.py         → Entry point (file ini)
"""
import logging
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.core.config import get_settings
from app.core.database import engine, Base

# ── Import semua model agar SQLAlchemy aware ─────────
from app.modules.measurements.models import Measurement  # noqa: F401
from app.modules.children.models import Child  # noqa: F401
from app.modules.nutrition.models import Recommendation  # noqa: F401

# ── Import semua router ─────────────────────────────
from app.modules.measurements.routes import router as measurements_router
from app.modules.children.routes import router as children_router
from app.modules.nutrition.routes import router as nutrition_router
from app.modules.map.routes import router as map_router

# ── Logging ──────────────────────────────────────────
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)-7s | %(name)s | %(message)s",
)
logger = logging.getLogger("tumbuhsehat")

settings = get_settings()


# ── Lifespan (startup/shutdown) ──────────────────────
@asynccontextmanager
async def lifespan(app: FastAPI):
    """Startup: create tables. Shutdown: cleanup."""
    logger.info("🚀 Starting TumbuhSehat API v%s", settings.APP_VERSION)
    Base.metadata.create_all(bind=engine)
    logger.info("✅ Database tables created/verified")
    yield
    logger.info("👋 Shutting down TumbuhSehat API")


# ── App Factory ──────────────────────────────────────
app = FastAPI(
    title=settings.APP_NAME,
    version=settings.APP_VERSION,
    description=(
        "Backend modular untuk aplikasi TumbuhSehat - "
        "Sistem Cerdas Cegah Stunting Indonesia.\n\n"
        "**Modules:** Measurements · Children · Nutrition AI · Map"
    ),
    lifespan=lifespan,
)

# ── CORS Middleware ──────────────────────────────────
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ── Register Routers ────────────────────────────────
app.include_router(measurements_router)
app.include_router(children_router)
app.include_router(nutrition_router)
app.include_router(map_router)


# ── Health Check ─────────────────────────────────────
@app.get("/", tags=["🏥 Health"])
def health_check():
    """Health check endpoint."""
    return {
        "status": "healthy",
        "app": settings.APP_NAME,
        "version": settings.APP_VERSION,
    }


@app.get("/api/health", tags=["🏥 Health"])
def api_health():
    """API health check."""
    return {
        "status": "ok",
        "modules": [
            "measurements",
            "children",
            "nutrition",
            "map",
        ],
    }
