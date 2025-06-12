import 'package:flutter/material.dart';
import '../../services/gemini_service.dart';

/// Screen that presents a 6-slide choose-your-own-adventure story 📖✨
/// Each slide shows an illustration (generated via backend), a paragraph,
/// and up to 3 choices returned by Gemini. When a child picks a choice we
/// fetch the next slide while preserving the story context.
class AdventureStoryScreen extends StatefulWidget {
  final Map<int, String> choices; // onboarding answers – may be used later

  const AdventureStoryScreen({super.key, required this.choices});

  @override
  State<AdventureStoryScreen> createState() => _AdventureStoryScreenState();
}

class _AdventureStoryScreenState extends State<AdventureStoryScreen> {
  final GeminiService _geminiService = GeminiService();

  // Story data
  final List<String> _paragraphs = [];
  final List<List<String>> _choicesPerSlide = [];
  final List<String?> _imageUrls = [];

  bool _isLoading = true;
  String? _error;
  int _currentSlide = 0; // 0-based index

  @override
  void initState() {
    super.initState();
    _fetchNextPart(); // fetch first slide
  }

  Future<void> _fetchNextPart([String? lastChoice]) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // 1. Get next paragraph + options from Gemini
      final result = await _geminiService.generateAdventurePart(
        storySoFar: _paragraphs,
        lastChoice: lastChoice,
      );

      final paragraph = (result['paragraph'] as String).trim();
      final options = List<String>.from(result['options'] as List);

      // 2. Generate illustration for this paragraph
      String? imageUrl;
      try {
        imageUrl = await _geminiService.generateImageFromStory(story: paragraph);
      } catch (_) {
        imageUrl = null; // continue without image if it fails
      }

      // 3. Update local state
      setState(() {
        _paragraphs.add(paragraph);
        _choicesPerSlide.add(options);
        _imageUrls.add(imageUrl);
        _currentSlide = _paragraphs.length - 1;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6B73FF)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Your Adventure',
          style: TextStyle(
            color: Color(0xFF2D3436),
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xFF6B73FF)),
              ),
            )
          : _error != null
              ? _buildError()
              : _buildSlide(),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              _error ?? 'Something went wrong',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => _fetchNextPart(),
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlide() {
    final paragraph = _paragraphs[_currentSlide];
    final imageUrl = _imageUrls[_currentSlide];
    final options = _choicesPerSlide[_currentSlide];

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          // Dots progress (6 slides total)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(6, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: index <= _currentSlide
                      ? const Color(0xFF6B73FF)
                      : Colors.grey[300],
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
          const SizedBox(height: 20),

          // Illustration
          if (imageUrl != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            )
          else
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFF6B73FF).withOpacity(0.05),
              ),
              alignment: Alignment.center,
              child: const Text('✨', style: TextStyle(fontSize: 48)),
            ),

          const SizedBox(height: 24),

          // Paragraph text
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Text(
              paragraph,
              style: const TextStyle(fontSize: 18, height: 1.6),
            ),
          ),

          const SizedBox(height: 24),

          // Choices (only if we have not reached slide 6)
          if (_paragraphs.length < 6)
            Column(
              children: options.map((option) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: const Color(0xFF6B73FF),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: () => _fetchNextPart(option),
                    child: Text(option, textAlign: TextAlign.center),
                  ),
                );
              }).toList(),
            )
          else
            Column(
              children: [
                const Text(
                  '🎉 The End! 🎉',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6B73FF)),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Back Home'),
                )
              ],
            ),
        ],
      ),
    );
  }
} 