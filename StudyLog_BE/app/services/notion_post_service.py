import requests

def append_to_notion_page(content, notion_api_key, notion_page_id):
    """
    Notion 특정 페이지에 블록을 추가하는 함수입니다.
    """
    notion_url = f"https://api.notion.com/v1/blocks/{notion_page_id}/children"
    headers = {
        "Authorization": f"Bearer {notion_api_key}",
        "Content-Type": "application/json",
        "Notion-Version": "2022-06-28"
    }

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

    response = requests.patch(notion_url, headers=headers, json=data)
    if response.status_code == 200:
        return {"message": "Notion 페이지에 블록이 성공적으로 추가되었습니다."}
    else:
        return {"error": "Notion 페이지에 블록 추가에 실패했습니다.", "details": response.text}
