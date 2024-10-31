import requests
from datetime import datetime
import base64

def create_github_post(title, content, github_token, repo_owner, repo_name):
    """
    GitHub Pages 블로그에 새 포스트를 추가하는 함수입니다.
    """
    date_str = datetime.now().strftime("%Y-%m-%d")
    file_path = f"_posts/{date_str}-{title.replace(' ', '-').lower()}.md"

    post_content = f"""---
title: "{title}"
date: {date_str}
---

{content}
"""
    encoded_content = base64.b64encode(post_content.encode("utf-8")).decode("utf-8")

    headers = {
        "Authorization": f"token {github_token}",
        "Accept": "application/vnd.github.v3+json"
    }

    data = {
        "message": f"Add new post: {title}",
        "content": encoded_content,
        "branch": "main"
    }

    response = requests.put(f"https://api.github.com/repos/{repo_owner}/{repo_name}/contents/{file_path}", headers=headers, json=data)

    if response.status_code == 201:
        return {"message": "블로그 포스트가 성공적으로 업로드되었습니다."}
    else:
        return {"error": "블로그 포스트 업로드에 실패했습니다.", "details": response.json()}
