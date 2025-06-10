import 'package:flutter/material.dart';
import 'package:story_buddy/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Story Buddy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B73FF)),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}
