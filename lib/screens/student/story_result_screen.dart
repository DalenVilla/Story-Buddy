import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../services/gemini_service.dart';
import '../../models/story.dart';
import '../../services/story_storage_service.dart';
import '../../services/user_service.dart';
import 'student_home_screen.dart';

class StoryResultScreen extends StatefulWidget {
  final String story;
  final Map<int, String> choices;
  final Story? existingStory; // If provided, this is viewing an existing story

  const StoryResultScreen({
    super.key,
    required this.story,
    required this.choices,
    this.existingStory, // Optional - for viewing existing stories
  });

  @override
  State<StoryResultScreen> createState() => _StoryResultScreenState();
}

class _StoryResultScreenState extends State<StoryResultScreen> {
  final GeminiService _geminiService = GeminiService();
  final FlutterTts _flutterTts = FlutterTts();
  
  String? _imageUrl;
  bool _isGeneratingImage = true;
  String? _imageError;
  bool _storySaved = false;
  bool _isGeneratingTitle = false;
  bool _isSpeaking = false;
  
  // For word highlighting during speech
  List<Map<String, dynamic>> _storySegments = [];
  int _currentWordIndex = -1;
  String _cleanedStoryForDisplay = "";
  DateTime _lastUpdateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _prepareStoryForHighlighting();
    
    // Only generate new image and save if this is a new story
    if (widget.existingStory == null) {
      _generateStoryImage();
    } else {
      // This is an existing story, use the stored image
      setState(() {
        _imageUrl = widget.existingStory!.imageUrl;
        _isGeneratingImage = false;
        _storySaved = true; // Already saved
      });
    }
  }

  void _prepareStoryForHighlighting() {
    _cleanedStoryForDisplay = _cleanStoryContent(widget.story);
    _storySegments = _parseStoryIntoSegments(_cleanedStoryForDisplay);
  }

  List<Map<String, dynamic>> _parseStoryIntoSegments(String story) {
    List<Map<String, dynamic>> segments = [];
    
    // Split by paragraphs first to preserve structure
    List<String> paragraphs = story.split('\n\n');
    int globalWordIndex = 0;
    
    for (int paragraphIndex = 0; paragraphIndex < paragraphs.length; paragraphIndex++) {
      String paragraph = paragraphs[paragraphIndex].trim();
      if (paragraph.isEmpty) continue;
      
      // Add paragraph break if not the first paragraph
      if (paragraphIndex > 0) {
        segments.add({
          'type': 'paragraph_break',
          'content': '\n\n',
          'wordIndex': -1,
        });
      }
      
      // Split paragraph into words
      List<String> words = paragraph.split(RegExp(r'\s+'));
      words.removeWhere((word) => word.trim().isEmpty);
      
      for (int wordIndex = 0; wordIndex < words.length; wordIndex++) {
        String word = words[wordIndex];
        
        segments.add({
          'type': 'word',
          'content': word,
          'wordIndex': globalWordIndex,
          'isLastInParagraph': wordIndex == words.length - 1,
        });
        
        // Add space after word (except last word in paragraph)
        if (wordIndex < words.length - 1) {
          segments.add({
            'type': 'space',
            'content': ' ',
            'wordIndex': -1,
          });
        }
        
        globalWordIndex++;
      }
    }
    
    return segments;
  }

  void _startWordHighlighting() {
    // Estimate timing for word highlighting (since TTS progress might not be available)
    int totalWords = _storySegments.where((seg) => seg['type'] == 'word').length;
    if (totalWords > 0) {
      _simulateWordProgress();
    }
  }

  void _simulateWordProgress() async {
    // Much slower and more stable timing
    double wordsPerSecond = 1.5; // Even slower for stability
    int totalWords = _storySegments.where((seg) => seg['type'] == 'word').length;
    double intervalMs = (1000 / wordsPerSecond);
    
    for (int i = 0; i < totalWords && _isSpeaking; i++) {
      await Future.delayed(Duration(milliseconds: intervalMs.round()));
      if (_isSpeaking && mounted) {
        // Only update if the word index actually changed and enough time has passed
        DateTime now = DateTime.now();
        if (_currentWordIndex != i && now.difference(_lastUpdateTime).inMilliseconds > 100) {
          _lastUpdateTime = now;
          setState(() {
            _currentWordIndex = i;
          });
          // Add a small delay after state update to prevent rapid changes
          await Future.delayed(const Duration(milliseconds: 100));
        }
      }
    }
  }

  void _highlightWordByOffset(int startOffset, int endOffset) {
    // This method handles TTS progress callbacks if available
    String spokenText = _cleanedStoryForDisplay.substring(0, endOffset);
    List<String> spokenWords = spokenText.split(RegExp(r'\s+'));
    
    if (mounted && spokenWords.isNotEmpty) {
      setState(() {
        _currentWordIndex = spokenWords.length - 1;
      });
    }
  }

  Widget _buildHighlightedStoryText() {
    if (_storySegments.isEmpty) {
      return Text(
        widget.story,
        style: const TextStyle(
          fontSize: 17,
          height: 1.7,
          color: Color(0xFF2D3436),
          fontWeight: FontWeight.w400,
          letterSpacing: 0.2,
        ),
      );
    }

    // Cache the text spans to avoid rebuilding on every frame
    List<TextSpan> textSpans = [];
    
    for (var segment in _storySegments) {
      if (segment['type'] == 'paragraph_break') {
        textSpans.add(const TextSpan(text: '\n\n'));
      } else if (segment['type'] == 'space') {
        textSpans.add(const TextSpan(text: ' '));
      } else if (segment['type'] == 'word') {
        bool isCurrentWord = segment['wordIndex'] == _currentWordIndex;
        
        textSpans.add(TextSpan(
          text: segment['content'],
          style: TextStyle(
            fontWeight: isCurrentWord ? FontWeight.w700 : FontWeight.w400,
            backgroundColor: isCurrentWord 
                ? Colors.orange.withOpacity(0.15) 
                : Colors.transparent,
            color: const Color(0xFF2D3436),
          ),
        ));
      }
    }

    return RepaintBoundary(
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 17,
            height: 1.7,
            color: Color(0xFF2D3436),
            fontWeight: FontWeight.w400,
            letterSpacing: 0.2,
          ),
          children: textSpans,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    super.dispose();
  }

  Future<void> _initializeTts() async {
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.4); // Natural storytelling pace
      await _flutterTts.setVolume(0.9);
      await _flutterTts.setPitch(0.9); // Warm, natural pitch
      
      print("TTS initialized successfully");
    } catch (e) {
      print("Error initializing TTS: $e");
    }
    
    _flutterTts.setStartHandler(() {
      print("TTS started speaking");
      setState(() {
        _isSpeaking = true;
        _currentWordIndex = 0;
      });
      _startWordHighlighting();
    });

    _flutterTts.setCompletionHandler(() {
      print("TTS completed speaking");
      setState(() {
        _isSpeaking = false;
        _currentWordIndex = -1;
      });
    });

    _flutterTts.setErrorHandler((msg) {
      print("TTS error: $msg");
      setState(() {
        _isSpeaking = false;
        _currentWordIndex = -1;
      });
    });

    // Try to set up progress handler for word-by-word highlighting
    _flutterTts.setProgressHandler((String text, int startOffset, int endOffset, String word) {
      print("TTS Progress: word='$word', start=$startOffset, end=$endOffset");
      _highlightWordByOffset(startOffset, endOffset);
    });
  }

  Future<void> _speakStory() async {
    if (_isSpeaking) {
      print("Stopping TTS");
      await _flutterTts.stop();
      setState(() {
        _isSpeaking = false;
        _currentWordIndex = -1;
      });
    } else {
      // Use simple, reliable approach first
      String storyToSpeak = _prepareSimpleStoryForSpeech(widget.story);
      
      // If story is empty or too short, use a test phrase
      if (storyToSpeak.trim().length < 10) {
        storyToSpeak = "Hello! This is a test of the story reading feature. Once upon a time, there was a magical story waiting to be told.";
        print("Using test phrase because story is too short");
      }
      
      print("Speaking story: ${storyToSpeak.substring(0, storyToSpeak.length > 50 ? 50 : storyToSpeak.length)}...");
      
      setState(() {
        _isSpeaking = true;
      });
      
      try {
        var result = await _flutterTts.speak(storyToSpeak);
        print("TTS speak result: $result");
      } catch (e) {
        print("Error speaking story: $e");
        setState(() {
          _isSpeaking = false;
        });
        
        // Show user feedback
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Audio not available: $e'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  String _prepareSimpleStoryForSpeech(String story) {
    // Simplified version for maximum compatibility
    String cleanedStory = _cleanStoryContent(story);
    
    print("Original story length: ${story.length}");
    print("Cleaned story length: ${cleanedStory.length}");
    
    if (cleanedStory.isEmpty) {
      cleanedStory = "Once upon a time, there was a magical story waiting to be told.";
    }
    
    cleanedStory = cleanedStory
        // Add natural pauses with simple ellipses
        .replaceAll('.', '... ')
        .replaceAll('!', '! ... ')
        .replaceAll('?', '? ... ')
        .replaceAll(',', ', ')
        
        // Expand contractions for clarity
        .replaceAll("don't", "do not")
        .replaceAll("can't", "cannot")
        .replaceAll("won't", "will not")
        .replaceAll("I'm", "I am")
        .replaceAll("you're", "you are")
        .replaceAll("it's", "it is")
        .replaceAll("that's", "that is")
        .replaceAll("what's", "what is")
        .replaceAll("here's", "here is")
        .replaceAll("there's", "there is");
    
    // Clean up extra spaces
    cleanedStory = cleanedStory.replaceAll(RegExp(r' +'), ' ').trim();
    
    print("Final story for TTS: ${cleanedStory.substring(0, cleanedStory.length > 100 ? 100 : cleanedStory.length)}...");
    
    return cleanedStory;
  }

  String _prepareStoryForSpeech(String story) {
    // Clean the story content first
    String cleanedStory = _cleanStoryContent(story);
    
    // Advanced natural speech processing for human-like delivery
    cleanedStory = cleanedStory
        // Story opening with gentle pause
        .replaceAll(RegExp(r'^(Once upon a time|Long ago|In a|There was|There once)', caseSensitive: false), 
                   r'\1, ')
        
        // Natural sentence endings with varied pauses
        .replaceAll('.', '. <break time="800ms"/> ')
        .replaceAll('!', '! <break time="1s"/> ')
        .replaceAll('?', '? <break time="900ms"/> ')
        
        // Breathing pauses for natural flow
        .replaceAll(',', ', <break time="300ms"/> ')
        .replaceAll(';', '; <break time="400ms"/> ')
        
        // Dramatic storytelling pauses
        .replaceAll(' and then ', ' <break time="500ms"/> and then <break time="300ms"/> ')
        .replaceAll(' suddenly ', ' <break time="600ms"/> suddenly <break time="400ms"/> ')
        .replaceAll(' but ', ' <break time="400ms"/> but ')
        .replaceAll(' however ', ' <break time="500ms"/> however ')
        .replaceAll(' meanwhile ', ' <break time="600ms"/> meanwhile <break time="400ms"/> ')
        
        // Dialogue with character pauses
        .replaceAll('"', ' <break time="400ms"/> " ')
        .replaceAll('" said', '" <break time="300ms"/> said')
        .replaceAll('" asked', '" <break time="300ms"/> asked')
        .replaceAll('" replied', '" <break time="300ms"/> replied')
        
        // Emotional emphasis
        .replaceAll(RegExp(r'\b(wow|amazing|wonderful|magical|beautiful)\b', caseSensitive: false), 
                   r'<emphasis level="moderate">\1</emphasis>')
        .replaceAll(RegExp(r'\b(scared|frightened|worried|nervous)\b', caseSensitive: false), 
                   r'<emphasis level="reduced">\1</emphasis>')
        
        // Natural pronunciation improvements
        .replaceAll("don't", "do not")
        .replaceAll("can't", "can not")
        .replaceAll("won't", "will not")
        .replaceAll("shouldn't", "should not")
        .replaceAll("couldn't", "could not")
        .replaceAll("wouldn't", "would not")
        .replaceAll("I'm", "I am")
        .replaceAll("you're", "you are")
        .replaceAll("we're", "we are")
        .replaceAll("they're", "they are")
        .replaceAll("it's", "it is")
        .replaceAll("that's", "that is")
        .replaceAll("what's", "what is")
        .replaceAll("here's", "here is")
        .replaceAll("there's", "there is")
        .replaceAll("let's", "let us")
        .replaceAll("we'll", "we will")
        .replaceAll("I'll", "I will")
        .replaceAll("you'll", "you will")
        .replaceAll("he'll", "he will")
        .replaceAll("she'll", "she will")
        .replaceAll("they'll", "they will")
        
        // Number pronunciation
        .replaceAll("1", "one")
        .replaceAll("2", "two")
        .replaceAll("3", "three")
        .replaceAll("4", "four")
        .replaceAll("5", "five")
        .replaceAll("6", "six")
        .replaceAll("7", "seven")
        .replaceAll("8", "eight")
        .replaceAll("9", "nine")
        .replaceAll("10", "ten")
        
        // Special character names and sounds
        .replaceAll("haha", "ha ha ha")
        .replaceAll("hehe", "he he he")
        .replaceAll("hmm", "hmmm")
        .replaceAll("shh", "shhh")
        .replaceAll("wow", "<emphasis level=\"strong\">wow</emphasis>")
        .replaceAll("oh", "<emphasis level=\"moderate\">oh</emphasis>");
    
    // Clean up extra spaces but preserve SSML tags
    cleanedStory = cleanedStory.replaceAll(RegExp(r' +'), ' ').trim();
    
    // Wrap in SSML for advanced speech control
    cleanedStory = '<speak version="1.0" xmlns="http://www.w3.org/2001/10/synthesis" xml:lang="en-US">'
                  '<prosody rate="slow" pitch="medium" volume="medium">'
                  '$cleanedStory'
                  '</prosody>'
                  '</speak>';
    
    return cleanedStory;
  }

  Future<void> _generateStoryImage() async {
    try {
      setState(() {
        _isGeneratingImage = true;
        _imageError = null;
      });

      // Clean the story content to remove any JSON formatting
      String cleanedStory = _cleanStoryContent(widget.story);

      // Generate image using your custom backend API
      final imageUrl = await _geminiService.generateImageFromStory(
        story: cleanedStory,
      );

      if (mounted) {
        setState(() {
          _imageUrl = imageUrl;
          _isGeneratingImage = false;
        });
        
        // Save the story with the generated image
        await _saveStory(imageUrl, cleanedStory);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _imageError = e.toString();
          _isGeneratingImage = false;
        });
        
        // Save the story even without an image
        await _saveStory(null, _cleanStoryContent(widget.story));
      }
    }
  }

  Future<void> _saveStory(String? imageUrl, [String? cleanedStoryContent]) async {
    if (_storySaved) return; // Prevent duplicate saves
    
    try {
      final currentUser = await UserService.getCurrentUserName();
      print('Saving story for user: $currentUser');
      
      // Generate AI-powered title for the story
      setState(() {
        _isGeneratingTitle = true;
      });
      
      String aiGeneratedTitle;
      try {
        print('Generating AI title for story...');
        aiGeneratedTitle = await _geminiService.generateStoryTitle(story: widget.story);
        print('Generated title: $aiGeneratedTitle');
      } catch (e) {
        print('Failed to generate AI title, using fallback: $e');
        aiGeneratedTitle = Story.generateTitle(widget.story);
      }
      
      setState(() {
        _isGeneratingTitle = false;
      });
      
      final story = Story(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: aiGeneratedTitle,
        content: cleanedStoryContent ?? _cleanStoryContent(widget.story),
        imageUrl: imageUrl,
        choices: widget.choices,
        createdAt: DateTime.now(),
      );
      
      await StoryStorageService.saveStory(story);
      
      setState(() {
        _storySaved = true;
      });
      
      print('Story saved successfully for user: $currentUser with title: $aiGeneratedTitle');
    } catch (e) {
      print('Error saving story: $e');
      // Continue even if saving fails - don't disrupt user experience
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6B73FF)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                widget.existingStory != null ? widget.existingStory!.title : 'Your Story',
                style: const TextStyle(
                  color: Color(0xFF2D3436),
                  fontWeight: FontWeight.w700,
                  fontSize: 24,
                ),
              ),
            ),
            if (_isGeneratingTitle) ...[
              const SizedBox(width: 8),
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6B73FF)),
                ),
              ),
            ],
          ],
        ),
        centerTitle: true,
        actions: [
          // Big orange audio button
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
                onTap: _speakStory,
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              
              // Story content card with enhanced design
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0.95),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                    ),
                    BoxShadow(
                      color: Colors.blue.withOpacity(0.05),
                      blurRadius: 40,
                      offset: const Offset(0, 16),
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Story text with beautiful typography
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FF).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFF6B73FF).withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        child: _buildHighlightedStoryText(),
                      ),
                      
                      // Image section - naturally integrated
                      const SizedBox(height: 24),
                      
                      if (_isGeneratingImage || _imageError != null || _imageUrl != null)
                        _buildImageSection(),
                      
                      // Show creation date for existing stories OR title generation status
                      if (widget.existingStory != null) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Created ${_formatDate(widget.existingStory!.createdAt)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] else if (_isGeneratingTitle) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B73FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6B73FF)),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Creating the perfect title for your story...',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: const Color(0xFF6B73FF),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 32),
              
              // Enhanced action buttons
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.15),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          // Get current user info to navigate to proper home
                          final userName = await UserService.getCurrentUserName();
                          
                          if (userName != null) {
                            // Navigate to student home screen
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StorytimeHomeScreen(
                                  studentName: userName,
                                ),
                              ),
                              (route) => false, // Remove all previous routes
                            );
                          } else {
                            // Fallback: just pop back
                            Navigator.pop(context);
                          }
                        },
                        icon: const Icon(Icons.home_rounded, size: 20),
                        label: const Text(
                          'Home',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[50],
                          foregroundColor: Colors.grey[700],
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF6B73FF),
                            const Color(0xFF9B59B6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF6B73FF).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.auto_stories_rounded, size: 20),
                        label: const Text(
                          'New Story',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          shadowColor: Colors.transparent,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    if (_isGeneratingImage) {
      return _buildLoadingImage();
    } else if (_imageError != null) {
      return _buildErrorImage();
    } else if (_imageUrl != null) {
      return _buildGeneratedImage();
    } else {
      return const SizedBox();
    }
  }

  Widget _buildLoadingImage() {
    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF6B73FF).withOpacity(0.05),
            const Color(0xFF9B59B6).withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF6B73FF).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF6B73FF).withOpacity(0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Center(
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6B73FF)),
                  strokeWidth: 3,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Creating your illustration...',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B73FF),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'This may take a moment',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorImage() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red[100]!),
      ),
      child: Column(
        children: [
          Icon(
            Icons.image_not_supported_rounded,
            size: 40,
            color: Colors.red[400],
          ),
          const SizedBox(height: 12),
          Text(
            'Illustration unavailable',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.red[700],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Your story is still amazing without it!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.red[600],
            ),
            textAlign: TextAlign.center,
          ),
          // Only show Try Again for new stories, not existing ones
          if (widget.existingStory == null) ...[
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: _generateStoryImage,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text(
                'Try Again',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6B73FF),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildGeneratedImage() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          _imageUrl!,
          width: double.infinity,
          height: 240,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              height: 240,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF6B73FF).withOpacity(0.05),
                    const Color(0xFF9B59B6).withOpacity(0.05),
                  ],
                ),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6B73FF)),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              height: 240,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.broken_image_rounded,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Image could not load',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  String _cleanStoryContent(String storyContent) {
    // Remove any JSON formatting that might have been added to the story
    String cleaned = storyContent;
    
    // Remove JSON patterns like {"story_name": "..."} or similar
    cleaned = cleaned.replaceAll(RegExp(r'\{[^}]*"story_name"[^}]*\}'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\{[^}]*"title"[^}]*\}'), '');
    cleaned = cleaned.replaceAll(RegExp(r'\{[^}]*"name"[^}]*\}'), '');
    
    // Remove any other JSON-like patterns
    cleaned = cleaned.replaceAll(RegExp(r'\{[^}]*\}'), '');
    
    // Clean up extra whitespace and newlines
    cleaned = cleaned.replaceAll(RegExp(r'\n\s*\n'), '\n\n');
    cleaned = cleaned.trim();
    
    return cleaned;
  }
} 