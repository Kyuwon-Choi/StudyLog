from openai import OpenAI
from dotenv import load_dotenv
import os

load_dotenv()

def initialize_openai_client():
    return OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

client = initialize_openai_client()

def convert_text_to_blog_format(input_text):
    response = client.chat.completions.create(
        model="gpt-4",
        messages=[{"role": "user", "content": f"블로그 양식으로 다음 텍스트를 변환하세요:\n{input_text}"}],
        max_tokens=500
    )
    return response.choices[0].message.content.strip()
