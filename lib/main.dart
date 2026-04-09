import 'package:flutter/material.dart';

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
      home: const BlankScreen(),
    );
  }
}

class BlankScreen extends StatelessWidget {
  const BlankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'Vibecoded Sourdough App',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
