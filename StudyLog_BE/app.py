from flask import Flask, request, jsonify
from HtmlConvertor import get_html_response

app = Flask(__name__)


@app.route('/')
def hello_world():
    return 'Hello World!'

@app.route('/upload', methods=['POST'])
def upload_text():
    data = request.json
    text = data.get("text")
    title = data.get("title", "OCR 결과 게시글")

    if not text:
        return jsonify({"error": "No text provided"}), 400

    # HTML 변환
    html_content = get_html_response(text, title)


    # 결과 반환
    return jsonify({
    })

if __name__ == '__main__':
    app.run()