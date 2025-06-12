import 'package:flutter/material.dart';
import '../../services/gemini_service.dart';
import '../../services/user_service.dart';
import 'story_result_screen.dart';

class StoryGeneratingScreen extends StatefulWidget {
  final Map<int, String> choices;
  const StoryGeneratingScreen({super.key, required this.choices});

  @override
  State<StoryGeneratingScreen> createState() => _StoryGeneratingScreenState();
}

class _StoryGeneratingScreenState extends State<StoryGeneratingScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final GeminiService _geminiService = GeminiService();
  String _statusText = 'Generating your story...';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
    
    // Start generating the story
    _generateStory();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _generateStory() async {
    try {
      setState(() {
        _statusText = 'Connecting to AI...';
      });

      // You can customize these parameters based on your app's needs
      final story = await _geminiService.generateStory(
        choices: widget.choices,
        age: '6-10 years old', // You might want to get this from user input
        theme: 'Adventure', // You might want to get this from user input
      );

      // Navigate to the story result screen
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StoryResultScreen(
              story: story,
              choices: widget.choices,
            ),
          ),
        );
      }
    } catch (e) {
      // Handle errors
      if (mounted) {
        setState(() {
          _statusText = 'Oops! Something went wrong. Please try again.';
        });
        
        // Show error dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to generate story: ${e.toString()}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to previous screen
                },
                child: const Text('Try Again'),
              ),
            ],
          ),
        );
      }
    }
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
            Text(
              _statusText,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6B73FF),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            
            // Show a subtitle with helpful information
            Text(
              'Please wait while we create something magical for you!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
} 