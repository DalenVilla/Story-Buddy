import 'package:flutter/material.dart';
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
  
  String? _imageUrl;
  bool _isGeneratingImage = true;
  String? _imageError;
  bool _storySaved = false;
  bool _isGeneratingTitle = false;

  @override
  void initState() {
    super.initState();
    
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
                        child: Text(
                          widget.story,
                          style: const TextStyle(
                            fontSize: 17,
                            height: 1.7,
                            color: Color(0xFF2D3436),
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.2,
                          ),
                        ),
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