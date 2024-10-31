import requests

NOTION_API_KEY = ""
NOTION_PAGE_ID = ""  # 대상 페이지의 ID


# Notion API 엔드포인트와 헤더 설정
NOTION_URL = f"https://api.notion.com/v1/blocks/{NOTION_PAGE_ID}/children"
headers = {
    "Authorization": f"Bearer {NOTION_API_KEY}",
    "Content-Type": "application/json",
    "Notion-Version": "2022-06-28"
}

def append_to_notion_page(content):
    """
    Notion 특정 페이지에 블록을 추가
    """
    data = {
        "children": [
            {
                "object": "block",
                "type": "paragraph",
                "paragraph": {
                    "rich_text": [
                        {
                            "type": "text",
                            "text": {
                                "content": content
                            }
                        }
                    ]
                }
            }
        ]
    }

    # 요청 보내기
    response = requests.patch(NOTION_URL, headers=headers, json=data)
    if response.status_code == 200:
        print("Notion 페이지에 블록이 성공적으로 추가되었습니다.")
        return response.json()
    else:
        print("Notion 페이지에 블록 추가에 실패했습니다.")
        print(response.text)
        return None

# 사용 예제
if __name__ == "__main__":
    content = "테스트테스트"
    append_to_notion_page(content)