# main/routes.py
from flask import request, Blueprint
from flask_restx import Namespace, Resource, fields
from ..services.openai_service import convert_text_to_blog_format
from ..services.github_post_service import create_github_post
from ..services.notion_post_service import append_to_notion_page

# Blueprint와 Namespace 생성
main_blueprint = Blueprint('main', __name__)
main_namespace = Namespace('convert', description='텍스트 변환 작업')

# 모델 정의
convert_model = main_namespace.model('ConvertRequest', {
    'input_text': fields.String(required=True, description="블로그 양식으로 변환할 텍스트")
})
github_model = main_namespace.model('GitHubRequest', {
    'title': fields.String(required=True, description="블로그 포스트 제목"),
    'content': fields.String(required=True, description="블로그 포스트 내용"),
    'github_token': fields.String(required=True, description="GitHub API 토큰"),
    'repo_owner': fields.String(required=True, description="저장소 소유자"),
    'repo_name': fields.String(required=True, description="저장소 이름")
})

notion_model = main_namespace.model('NotionRequest', {
    'content': fields.String(required=True, description="Notion 페이지에 추가할 내용"),
    'notion_api_key': fields.String(required=True, description="Notion API 키"),
    'notion_page_id': fields.String(required=True, description="Notion 페이지 ID")
})

# 엔드포인트 정의
@main_namespace.route('/convert')
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
        

@main_namespace.route('/github')
class GitHubPost(Resource):
    @main_namespace.expect(github_model)
    def post(self):
        data = request.get_json()
        title = data.get("title")
        content = data.get("content")
        github_token = data.get("github_token")
        repo_owner = data.get("repo_owner")
        repo_name = data.get("repo_name")

        if not all([title, content, github_token, repo_owner, repo_name]):
            return {"error": "필수 정보가 제공되지 않았습니다."}, 400

        try:
            result = create_github_post(title, content, github_token, repo_owner, repo_name)
            return result
        except Exception as e:
            return {"error": str(e)}, 500

@main_namespace.route('/notion')
class NotionPost(Resource):
    @main_namespace.expect(notion_model)
    def post(self):
        data = request.get_json()
        content = data.get("content")
        notion_api_key = data.get("notion_api_key")
        notion_page_id = data.get("notion_page_id")

        if not all([content, notion_api_key, notion_page_id]):
            return {"error": "필수 정보가 제공되지 않았습니다."}, 400

        try:
            result = append_to_notion_page(content, notion_api_key, notion_page_id)
            return result
        except Exception as e:
            return {"error": str(e)}, 500
