import os

from dotenv import load_dotenv


load_dotenv()


APP_ENV = os.getenv("APP_ENV", "development")
API_PORT = int(os.getenv("API_PORT", "8080"))
LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO")

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = int(os.getenv("DB_PORT", "5432"))
DB_NAME = os.getenv("DB_NAME", "deployops")
DB_USER = os.getenv("DB_USER", "")
DB_PASSWORD = os.getenv("DB_PASSWORD", "")

REDIS_URL = os.getenv(
    "REDIS_URL",
    "redis://localhost:6379",
)
