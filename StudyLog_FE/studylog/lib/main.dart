import 'package:flutter/material.dart';
import 'package:studylog/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          backgroundColor: const Color(0xFFF4F4F9),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            color: Color(0xFF21272A),
          ),
          bodyLarge: TextStyle(
            color: Color(0xFF21272A),
          ),
          bodyMedium: TextStyle(
            color: Color(0xFF21272A),
          ),
        ),
        cardColor: const Color(0xFF79747E),
        canvasColor: const Color(0xFFF3EDF7),
      ),
      home: const HomeScreen(),
    );
  }
}
