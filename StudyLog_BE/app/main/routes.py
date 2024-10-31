# main/routes.py
from flask import request, Blueprint
from flask_restx import Namespace, Resource, fields
from ..services.openai_service import convert_text_to_blog_format

# Blueprint와 Namespace 생성
main_blueprint = Blueprint('main', __name__)
main_namespace = Namespace('convert', description='텍스트 변환 작업')

# 모델 정의
convert_model = main_namespace.model('ConvertRequest', {
    'input_text': fields.String(required=True, description="블로그 양식으로 변환할 텍스트")
})

# 엔드포인트 정의
@main_namespace.route('/')
class ConvertText(Resource):
    @main_namespace.expect(convert_model)
    def post(self):
        data = request.get_json()
        input_text = data.get("input_text", "")

        if not input_text:
            return {"error": "텍스트가 제공되지 않았습니다."}, 400

        try:
            converted_text = convert_text_to_blog_format(input_text)
            return {"converted_text": converted_text}
        except Exception as e:
            return {"error": str(e)}, 500
