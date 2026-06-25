from pydantic_settings import BaseSettings, SettingsConfigDict


class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
    )

    APP_NAME: str = "expense-tracker-backend"
    ENVIRONMENT: str = "development"
    DEBUG: bool = False
    SECRET_KEY: str

    # Neon Postgres — postgresql+asyncpg://...?sslmode=require
    DATABASE_URL: str

    HOST: str = "0.0.0.0"
    PORT: int = 8000


settings = Settings()
