import 'package:flutter/material.dart';
import 'package:sourdough/calculator/calculator_screen.dart';

void main() {
  runApp(const SourdoughApp());
}

class SourdoughApp extends StatelessWidget {
  const SourdoughApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sourdough',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const CalculatorScreen(),
    );
  }
}
