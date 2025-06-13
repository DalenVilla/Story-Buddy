import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../services/gemini_service.dart';
import '../../services/user_service.dart';
import 'student_home_screen.dart';
import 'dart:math' as math;

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

class _AdventureStoryScreenState extends State<AdventureStoryScreen> with SingleTickerProviderStateMixin {
  final GeminiService _geminiService = GeminiService();
  final FlutterTts _flutterTts = FlutterTts();

  // Story data
  final List<String> _paragraphs = [];
  final List<List<String>> _choicesPerSlide = [];
  final List<String?> _imageUrls = [];

  bool _isLoading = true;
  String? _error;
  int _currentSlide = 0; // 0-based index
  bool _isSpeaking = false;

  late AnimationController _loadingController;
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    _loadingController.repeat(reverse: true);
    _initializeVideoPlayer();
    _initializeTts();
    _fetchNextPart(); // fetch first slide
  }

  void _initializeVideoPlayer() {
    _videoController = VideoPlayerController.asset('lib/assets/solar_loading_state.webm');
    _videoController!.initialize().then((_) {
      _videoController!.setLooping(true);
      if (_isLoading) {
        _videoController!.play();
      }
    });
  }

  Future<void> _initializeTts() async {
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.4); // Natural storytelling pace
      await _flutterTts.setVolume(0.9);
      await _flutterTts.setPitch(0.9); // Warm, natural pitch
      
      print("Adventure TTS initialized successfully");
    } catch (e) {
      print("Error initializing Adventure TTS: $e");
    }
    
    _flutterTts.setStartHandler(() {
      print("Adventure TTS started speaking");
      setState(() {
        _isSpeaking = true;
      });
    });

    _flutterTts.setCompletionHandler(() {
      print("Adventure TTS completed speaking");
      setState(() {
        _isSpeaking = false;
      });
    });

    _flutterTts.setErrorHandler((msg) {
      print("Adventure TTS error: $msg");
      setState(() {
        _isSpeaking = false;
      });
    });
  }

  Future<void> _speakCurrentSlide() async {
    if (_isSpeaking) {
      print("Stopping Adventure TTS");
      await _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
      });
    } else {
      if (_currentSlide < _paragraphs.length) {
        String textToSpeak = _prepareTextForSpeech(_paragraphs[_currentSlide]);
        
        print("Speaking adventure slide: ${textToSpeak.substring(0, textToSpeak.length > 50 ? 50 : textToSpeak.length)}...");
        
        setState(() {
          _isSpeaking = true;
        });
        
        try {
          await _flutterTts.speak(textToSpeak);
        } catch (e) {
          print("Error speaking adventure slide: $e");
          setState(() {
            _isSpeaking = false;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Audio not available: $e'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      }
    }
  }

  String _prepareTextForSpeech(String text) {
    // Clean and prepare text for natural speech
    String cleanedText = text
        .replaceAll('.', '... ')
        .replaceAll('!', '! ... ')
        .replaceAll('?', '? ... ')
        .replaceAll(',', ', ')
        .replaceAll("don't", "do not")
        .replaceAll("can't", "cannot")
        .replaceAll("won't", "will not")
        .replaceAll("I'm", "I am")
        .replaceAll("you're", "you are")
        .replaceAll("it's", "it is")
        .replaceAll("that's", "that is");
    
    return cleanedText.replaceAll(RegExp(r' +'), ' ').trim();
  }

  Future<void> _fetchNextPart([String? lastChoice]) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    _loadingController.repeat(reverse: true);
    if (_videoController != null && _videoController!.value.isInitialized) {
      _videoController!.play();
    }

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
      _loadingController.stop();
      if (_videoController != null && _videoController!.value.isInitialized) {
        _videoController!.pause();
      }
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
      _loadingController.stop();
      if (_videoController != null && _videoController!.value.isInitialized) {
        _videoController!.pause();
      }
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
        actions: [
          // Big orange audio button for adventure slides
          if (!_isLoading && _error == null && _paragraphs.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.shade400,
                    Colors.orange.shade600,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: _speakCurrentSlide,
                  child: Container(
                    width: 56,
                    height: 56,
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: _isSpeaking
                            ? const Icon(
                                Icons.stop_rounded,
                                color: Colors.white,
                                size: 28,
                                key: ValueKey('stop'),
                              )
                            : const Icon(
                                Icons.volume_up_rounded,
                                color: Colors.white,
                                size: 28,
                                key: ValueKey('play'),
                              ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? _buildLoading()
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

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Video loading animation
          if (_videoController != null && _videoController!.value.isInitialized)
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B73FF).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: AspectRatio(
                  aspectRatio: _videoController!.value.aspectRatio,
                  child: VideoPlayer(_videoController!),
                ),
              ),
            )
          else
            // Fallback to star animation while video loads
            AnimatedBuilder(
              animation: _loadingController,
              builder: (context, child) {
                final double offsetY = math.sin(_loadingController.value * 2 * math.pi) * 20;
                return Transform.translate(
                  offset: Offset(0, offsetY),
                  child: child,
                );
              },
              child: const Text('⭐', style: TextStyle(fontSize: 64)),
            ),
          const SizedBox(height: 24),
          const Text(
            'Making magic...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B73FF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide() {
    final paragraph = _paragraphs[_currentSlide];
    final imageUrl = _imageUrls[_currentSlide];
    final options = _choicesPerSlide[_currentSlide];

    return SingleChildScrollView(
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

          // Dynamic illustration with soft frame
          if (imageUrl != null)
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF6B73FF).withOpacity(0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: const Color(0xFF6B73FF).withOpacity(0.05),
                      ),
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        color: Color(0xFF6B73FF),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: const Color(0xFF6B73FF).withOpacity(0.05),
                      ),
                      alignment: Alignment.center,
                      child: const Text('✨', style: TextStyle(fontSize: 48)),
                    );
                  },
                ),
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
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6B73FF).withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      // Get current user info to navigate to proper home
                      final userName = await UserService.getCurrentUserName();
                      
                      // Navigate to student home screen and clear entire navigation stack
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => StorytimeHomeScreen(
                            studentName: userName ?? 'Student',
                          ),
                        ),
                        (Route<dynamic> route) => false, // Remove ALL previous routes
                      );
                    },
                    icon: const Icon(Icons.home_rounded, size: 22),
                    label: const Text(
                      'Back Home',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B73FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _loadingController.dispose();
    _videoController?.dispose();
    _flutterTts.stop();
    super.dispose();
  }
} 