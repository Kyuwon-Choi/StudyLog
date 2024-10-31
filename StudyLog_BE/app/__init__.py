from flask import Flask
from .main import main as main_blueprint
from .services.openai_service import initialize_openai

def create_app():
    app = Flask(__name__)
    app.config.from_object("config.Config")

    # OpenAI 초기화
    initialize_openai(app.config["OPENAI_API_KEY"])

    # 블루프린트 등록
    app.register_blueprint(main_blueprint)

    return app
