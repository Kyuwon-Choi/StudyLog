import requests
import uuid
import time
import base64
import json

# API 정보
api_url = 'domain'
secret_key = 'secret_key'

# 로컬 이미지 파일 경로
image_file = 'StudyLog_BE/app/services/ocr_test.png'

# 로컬 파일 읽기 및 Base64 인코딩
with open(image_file, 'rb') as f:
    file_data = base64.b64encode(f.read()).decode('utf-8')

# 요청 데이터 구성
request_json = {
    'images': [
        {
            'format': 'jpg',  # 이미지 형식
            'name': 'demo',   # 요청 이미지 이름
            'data': file_data # Base64 인코딩된 데이터
        }
    ],
    'requestId': str(uuid.uuid4()),  # 고유 요청 ID
    'version': 'V2',  # API 버전
    'timestamp': int(round(time.time() * 1000))  # 현재 시간 (밀리초)
}

# 헤더 설정
headers = {
    'X-OCR-SECRET': secret_key,
    'Content-Type': 'application/json'
}

# API 요청 보내기
response = requests.post(api_url, headers=headers, json=request_json)

# 결과 출력
if response.status_code == 200:
    print("OCR 결과:", response.json())  # 성공적으로 받은 응답
else:
    print(f"오류 발생! 상태 코드: {response.status_code}")
    print("응답 내용:", response.text)
