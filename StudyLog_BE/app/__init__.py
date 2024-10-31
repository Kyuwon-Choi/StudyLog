from flask import Flask
from flask_restx import Api
from flask_cors import CORS
from .main import main_blueprint, main_namespace

def create_app():
    app = Flask(__name__)
    CORS(app)

    # Swagger API 초기화
    api = Api(app, version='1.0', title='API 문서', description='Swagger 문서', doc="/api-docs")

    # Namespace를 API에 추가
    api.add_namespace(main_namespace, path='/convert')

    # Blueprint 등록
    app.register_blueprint(main_blueprint)

    return app
