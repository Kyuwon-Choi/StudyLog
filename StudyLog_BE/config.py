import os

class Config:
    SECRET_KEY = os.environ.get("SECRET_KEY", "default_secret_key")
    OPENAI_API_KEY = os.environ.get("OPENAI_API_KEY", "default_openai_api_key")
