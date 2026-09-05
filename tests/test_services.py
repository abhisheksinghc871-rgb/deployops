from fastapi.testclient import TestClient

from app.api.main import app


client = TestClient(app)


def test_services_list():
    response = client.get("/services")

    assert response.status_code == 200

    data = response.json()

    assert "services" in data
    assert len(data["services"]) == 2

    assert data["services"][0]["name"] == "deployops-api"
    assert data["services"][0]["type"] == "api"
    assert data["services"][0]["status"] == "healthy"

    assert data["services"][1]["name"] == "deployops-worker"
    assert data["services"][1]["type"] == "worker"
    assert data["services"][1]["status"] == "healthy"
