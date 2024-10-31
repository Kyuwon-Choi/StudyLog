from . import main
from ..services.openai_service import convert_text_to_blog_format
from flask_cors import CORS
from flask import Flask, request, jsonify

app = Flask(__name__)
CORS(app)

@main.route('/convert', methods=['POST'])
def convert_text():
    data = request.get_json()
    input_text = data.get("input_text", "")

    if not input_text:
        return jsonify({"error": "No input text provided"}), 400

    try:
        converted_text = convert_text_to_blog_format(input_text)
        return jsonify({"converted_text": converted_text})
    except Exception as e:
        return jsonify({"error": str(e)}), 500
