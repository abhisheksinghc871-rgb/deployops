from fastapi import FastAPI

from app.config.settings import APP_ENV, LOG_LEVEL
from app.services.service_registry import get_services


app = FastAPI(
    title="DeployOps API",
    description="Production-style deployment and operations platform",
    version="0.1.0",
)


@app.get("/health")
def health_check():
    return {
        "status": "healthy",
        "service": "deployops-api",
        "environment": APP_ENV,
        "log_level": LOG_LEVEL,
    }

@app.get("/services")
def list_services():
    return {
        "services": get_services()
    }
