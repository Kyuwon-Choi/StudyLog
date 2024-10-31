import 'package:flutter/material.dart';
import 'package:studylog/screens/form_convert_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 90,
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
        actions: [
          // Log In and Start Free Trial buttons on the right
          _buildTextButton("Log In", theme.textTheme.bodyLarge!.color!),
          const SizedBox(width: 16),
          _buildTextButton("Start Free Trial", Colors.white,
              backgroundColor: theme.cardColor),
          const SizedBox(width: 16),
        ],
      ),
      body: Column(
        children: [
          // Header Image
          Image.asset(
            "images/main.png",
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 60),

          // Title Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(
              "StudyLog와 함께 블로그 작성을 시작해보세요!",
              textAlign: TextAlign.center,
              style: theme.textTheme.displayLarge!.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 80),

          // Features Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeatureColumn(Icons.book, "OCR 기술을 통한 자동 텍스트화", theme),
                _buildFeatureColumn(
                    Icons.computer, "AI를 통해 자동 블로그 양식으로 변환", theme),
                _buildFeatureColumn(Icons.mic, "음성을 텍스트로 변환", theme),
                _buildFeatureColumn(Icons.quiz, "아카이브 & 퀴즈", theme),
              ],
            ),
          ),

          // Start Button
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.cardColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const FormConvertScreen()),
                );
              },
              child: const Text(
                "시작하기",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextButton(String text, Color textColor,
      {Color backgroundColor = Colors.transparent}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: textColor, width: 2),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildFeatureColumn(IconData icon, String text, ThemeData theme) {
    return Column(
      children: [
        Icon(icon, size: 48, color: theme.textTheme.bodyLarge!.color),
        const SizedBox(height: 8),
        Text(
          text,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge!.copyWith(fontSize: 18),
        ),
      ],
    );
  }
}
