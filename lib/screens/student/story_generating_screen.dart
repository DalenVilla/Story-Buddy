import 'package:flutter/material.dart';

class StoryGeneratingScreen extends StatefulWidget {
  final Map<int, String> choices;
  const StoryGeneratingScreen({super.key, required this.choices});

  @override
  State<StoryGeneratingScreen> createState() => _StoryGeneratingScreenState();
}

class _StoryGeneratingScreenState extends State<StoryGeneratingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated book
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 6.283,
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.15),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Text(
                  '📖',
                  style: TextStyle(fontSize: 64),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Generating your story...',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B73FF),
              ),
              textAlign: TextAlign.center,
            ),
const SizedBox(height: 24),

// Debug: Show choices map DELETE THIS LATER
Container(
  width: 320,
  padding: const EdgeInsets.all(12),
  margin: const EdgeInsets.only(top: 12),
  decoration: BoxDecoration(
    color: Colors.black.withOpacity(0.05),
    borderRadius: BorderRadius.circular(12),
  ),
  child: Text(
    'DEBUG: ${widget.choices}',
    style: const TextStyle(
      fontSize: 14,
      color: Colors.black87,
      fontFamily: 'monospace',
    ),
  ),
),


         ],
        ),
      ),
    );
  }
} 