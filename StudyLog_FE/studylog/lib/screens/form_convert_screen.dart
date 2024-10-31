import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FormConvertScreen extends StatefulWidget {
  const FormConvertScreen({super.key});

  @override
  _FormConvertScreenState createState() => _FormConvertScreenState();
}

class _FormConvertScreenState extends State<FormConvertScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();

  void _convertText() {
    setState(() {
      _outputController.text = "변환된 텍스트: ${_inputController.text}";
    });
  }

  void _copyText() {
    Clipboard.setData(ClipboardData(text: _outputController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("텍스트가 복사되었습니다.")),
    );
  }

  void _publishText() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("블로그에 업로드되었습니다.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10), // 로고 위에 여백 추가
          child: Row(
            children: [
              // Logo on the left
              Image.asset(
                "images/logo.png",
                height: 150, // 로고 크기 조정
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "공부한 기록을 블로그 양식으로 변환",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "공부한 기록을 블로그에 기록할 양식으로 변환해줍니다.\nTistory, 네이버 블로그는 자동 업로드도 가능합니다.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // 입력 및 출력 필드
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                        "변환 전", "여기에 텍스트를 입력해주세요.", _inputController, false),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField("변환 후", "", _outputController, true),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 버튼 섹션
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton("convert", _convertText),
                _buildActionButton("copy", _copyText),
                _buildActionButton("publish", _publishText),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint,
      TextEditingController controller, bool readOnly) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey),
            ),
            child: TextField(
              controller: controller,
              maxLines: null,
              expands: true,
              readOnly: readOnly,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(String label, VoidCallback onPressed) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: Color(0xFF79747E)),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF79747E),
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
