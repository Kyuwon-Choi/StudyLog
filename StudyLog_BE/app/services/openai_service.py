import openai
import os
from dotenv import load_dotenv


load_dotenv()


def initialize_openai(api_key=None):
    openai.api_key = api_key or os.getenv("OPENAI_API_KEY")

def convert_text_to_blog_format(input_text):
    response = openai.Completion.create(
        model="gpt-4o-mini",
        prompt=f"블로그 양식으로 다음 텍스트를 변환하세요:\n{input_text}",
        max_tokens=500
    )
    return response.choices[0].text.strip()
