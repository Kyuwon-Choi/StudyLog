import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class FormConvertScreen extends StatefulWidget {
  const FormConvertScreen({super.key});

  @override
  _FormConvertScreenState createState() => _FormConvertScreenState();
}

class _FormConvertScreenState extends State<FormConvertScreen> {
  final TextEditingController _inputController = TextEditingController();
  final TextEditingController _outputController = TextEditingController();
  bool _isLoading = false;

  Future<void> _convertText() async {
    final inputText = _inputController.text;
    if (inputText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("변환할 텍스트를 입력해주세요.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/convert'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"input_text": inputText}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _outputController.text = data['converted_text'];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("오류 발생: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("네트워크 오류 발생: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _copyText() {
    Clipboard.setData(ClipboardData(text: _outputController.text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("텍스트가 복사되었습니다.")),
    );
  }

  // 플랫폼 선택 다이얼로그 호출
  void _publishText() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("게시할 플랫폼 선택"),
          content: const Text("GitHub 또는 Notion 중 하나를 선택하세요."),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showPlatformDialog("GitHub");
              },
              child: const Text("GitHub"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _showPlatformDialog("Notion");
              },
              child: const Text("Notion"),
            ),
          ],
        );
      },
    );
  }

  // 정보 입력 다이얼로그
  void _showPlatformDialog(String platform) {
    final TextEditingController tokenController = TextEditingController();
    final TextEditingController idController = TextEditingController();
    final TextEditingController? titleController =
        platform == "GitHub" ? TextEditingController() : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("$platform 정보 입력"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: tokenController,
                decoration: const InputDecoration(
                  labelText: "API Token",
                ),
              ),
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: platform == "GitHub"
                      ? "Github Name/Repository Name"
                      : "Page ID",
                ),
              ),
              if (platform == "GitHub")
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: "포스트 제목",
                  ),
                ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _uploadContent(platform, tokenController.text,
                    idController.text, titleController?.text ?? "");
              },
              child: const Text("업로드"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadContent(
      String platform, String token, String id, String title) async {
    setState(() {
      _isLoading = true;
    });

    final endpoint = platform == "GitHub" ? "github" : "notion";
    final payload = platform == "GitHub"
        ? {
            "title": title,
            "content": _outputController.text,
            "github_token": token,
            "repo_owner": id.split("/")[0], // 소유자와 저장소 분리
            "repo_name": id.split("/")[1],
          }
        : {
            "content": _outputController.text,
            "notion_api_key": token,
            "notion_page_id": id,
          };

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/$endpoint'), // 서버 엔드포인트 URL
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("업로드가 성공적으로 완료되었습니다.")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("오류 발생: ${response.reasonPhrase}")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("네트워크 오류 발생: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
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
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Image.asset("images/logo.png", height: 150),
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
              "공부한 기록을 블로그에 기록할 양식으로 변환해줍니다.\n깃허브, 노션은 자동 업로드도 가능합니다.",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _isLoading
                    ? const CircularProgressIndicator()
                    : _buildActionButton("convert", _convertText),
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
