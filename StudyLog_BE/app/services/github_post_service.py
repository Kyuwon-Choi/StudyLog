import requests
from datetime import datetime
import base64

# GitHub API 인증 정보
GITHUB_TOKEN = ""
REPO_OWNER = "GoToBill"
REPO_NAME = "gotobill.github.io"  # GitHub Pages와 연결된 저장소 이름

# GitHub API URL
GITHUB_API_URL = f"https://api.github.com/repos/{REPO_OWNER}/{REPO_NAME}/contents"

def create_github_post(title, content):
    """
    GitHub Pages 블로그에 새 포스트를 추가하는 함수입니다.
    """
    # Markdown 파일로 저장할 파일명
    date_str = datetime.now().strftime("%Y-%m-%d")
    file_path = f"_posts/{date_str}-{title.replace(' ', '-').lower()}.md"
    
    # 파일 내용 작성
    post_content = f"""---
title: "{title}"
date: {date_str}
---

{content}
"""
    # 파일 내용 인코딩 (GitHub API는 Base64 인코딩된 내용을 요구합니다)
    encoded_content = base64.b64encode(post_content.encode("utf-8")).decode("utf-8")

    # API 요청 헤더
    headers = {
        "Authorization": f"token {GITHUB_TOKEN}",
        "Accept": "application/vnd.github.v3+json"
    }

    # 요청 데이터
    data = {
        "message": f"Add new post: {title}",
        "content": encoded_content,
        "branch": "main"  # 기본 브랜치(main 또는 master)로 설정
    }

    # GitHub API로 파일 생성 요청
    response = requests.put(f"{GITHUB_API_URL}/{file_path}", headers=headers, json=data)

    if response.status_code == 201:
        print("블로그 포스트가 성공적으로 업로드되었습니다.")
    else:
        print("블로그 포스트 업로드에 실패했습니다.")
        print(response.json())

# 사용 예제
if __name__ == "__main__":
    title = "GitHub API를 사용한 블로그 포스트_test"
    content = "이 글은 GitHub API를 사용해 자동으로 업로드된 블로그 포스트입니다."
    create_github_post(title, content)
