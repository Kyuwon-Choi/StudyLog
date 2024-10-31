from flask import Blueprint

# Blueprint 생성
main_blueprint = Blueprint('main', __name__)

# routes에서 main_namespace 가져오기
from .routes import main_namespace
