import 'package:flutter/material.dart';
import 'dart:async';
import '../../models/story.dart';
import '../../services/story_storage_service.dart';
import '../../services/story_event_service.dart';
import 'story_onboarding_screen.dart';
import 'story_result_screen.dart';
import '../../services/teacher_story_service.dart';

class StoryLibraryScreen extends StatefulWidget {
  const StoryLibraryScreen({super.key});

  @override
  State<StoryLibraryScreen> createState() => _StoryLibraryScreenState();
}

class _StoryLibraryScreenState extends State<StoryLibraryScreen> {
  List<Story> _userStories = [];
  bool _isLoading = true;
  StreamSubscription<void>? _storyUpdateSubscription;

  List<TeacherStory> _teacherStories = [];
  bool _isLoadingTeacher = true;

  @override
  void initState() {
    super.initState();
    _loadUserStories();
    _loadTeacherStories();
    
    // Listen for story updates
    _storyUpdateSubscription = StoryEventService.onStoryUpdated.listen((_) {
      _loadUserStories();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh stories when widget comes into view
    _loadUserStories();
  }

  @override
  void dispose() {
    _storyUpdateSubscription?.cancel();
    super.dispose();
  }

  Future<void> _loadUserStories() async {
    try {
      final stories = await StoryStorageService.getStories();
      if (mounted) {
        setState(() {
          _userStories = stories.reversed.toList(); // Show newest first
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading stories: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _loadTeacherStories() async {
    try {
      final stories = await TeacherStoryService.fetchTeacherStories();
      if (mounted) {
        setState(() {
          _teacherStories = stories;
          _isLoadingTeacher = false;
        });
      }
    } catch (e) {
      print('Error loading teacher stories: $e');
      if (mounted) {
        setState(() {
          _isLoadingTeacher = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6B73FF),
              Color(0xFF9B59B6),
              Color(0xFFFF6B9D),
              Color(0xFFFFA726),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Column(
                      children: [
                        Text(
                          '📚✨',
                          style: TextStyle(fontSize: 32),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Story Library',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 24,
                            shadows: [
                              Shadow(
                                offset: Offset(0, 2),
                                blurRadius: 4,
                                color: Colors.black26,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
              
              // Main content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F9FF),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Fun welcome message

            
            // Teacher Stories section
            const Text(
              'Teacher Stories',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 16),
            _buildTeacherStoriesSection(),
            
            // My Stories
            const Text(
              'My Stories',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 16),
            
            _buildMyStoriesSection(),
            
                         const SizedBox(height: 32),
                       ],
                     ),
                   ),
                 ),
               ),
             ],
           ),
         ),
       ),
     );
   }

  Widget _buildMyStoriesSection() {
    if (_isLoading) {
      return const SizedBox(
        height: 240,
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF6B73FF),
          ),
        ),
      );
    }

    if (_userStories.isEmpty) {
      return SizedBox(
        height: 240,
        child: Center(
          child: Container(
            width: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B73FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.auto_stories_outlined,
                    size: 48,
                    color: Color(0xFF6B73FF),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'No stories yet!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Create your first magical story',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const StoryOnboardingScreen(),
                        ),
                      ).then((_) {
                        // Refresh stories when returning from story creation
                        _loadUserStories();
                      });
                    },
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text(
                      'Create Story',
                      style: TextStyle(
                        fontSize: 16,
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
                      elevation: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _userStories.length,
        itemBuilder: (context, index) {
          final story = _userStories[index];
          return Padding(
            padding: EdgeInsets.only(right: index < _userStories.length - 1 ? 16 : 0),
            child: _buildUserStoryCard(story),
          );
        },
      ),
    );
  }

  Widget _buildUserStoryCard(Story story) {
    return GestureDetector(
      onTap: () {
        // Open the existing story in result screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryResultScreen(
              story: story.content,
              choices: story.choices,
              existingStory: story, // Pass the existing story
            ),
          ),
        );
      },
      child: Container(
      width: 160,
      decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6B73FF), Color(0xFF9B59B6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.8),
            blurRadius: 8,
            offset: const Offset(-2, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              // Story illustration/image
            Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                    child: story.imageUrl != null
                        ? Image.network(
                            story.imageUrl!,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                padding: const EdgeInsets.all(20),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFF6B73FF),
                                    strokeWidth: 2,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                padding: const EdgeInsets.all(20),
                                child: const Center(
                                  child: Icon(
                                    Icons.auto_stories_outlined,
                                    size: 40,
                                    color: Color(0xFF6B73FF),
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            padding: const EdgeInsets.all(20),
                            child: const Center(
                              child: Icon(
                                Icons.auto_stories_outlined,
                                size: 40,
                                color: Color(0xFF6B73FF),
                              ),
                            ),
                          ),
                  ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Title
            Text(
                story.title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                  color: Colors.white,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherStoriesSection() {
    if (_isLoadingTeacher) {
      return const SizedBox(
        height: 240,
        child: Center(
          child: CircularProgressIndicator(
            color: Color(0xFF9B59B6),
          ),
        ),
      );
    }

    if (_teacherStories.isEmpty) {
      return SizedBox(
        height: 120,
        child: Center(
          child: Text(
            'No assigned stories yet!',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 240,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _teacherStories.length,
        itemBuilder: (context, index) {
          final ts = _teacherStories[index];
          return Padding(
            padding: EdgeInsets.only(right: index < _teacherStories.length - 1 ? 16 : 0),
            child: _buildTeacherStoryCard(ts),
          );
        },
      ),
    );
  }

  Widget _buildTeacherStoryCard(TeacherStory ts) {
    return GestureDetector(
      onTap: () {
        final storyObj = Story(
          id: ts.id,
          title: ts.name,
          content: ts.content,
          imageUrl: ts.imageUrl,
          choices: const <int, String>{},
          createdAt: DateTime.now(),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoryResultScreen(
              story: ts.content,
              choices: const <int, String>{},
              existingStory: storyObj,
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF9B59B6), Color(0xFF6B73FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ts.imageUrl.isNotEmpty
                        ? Image.network(
                            ts.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => const Icon(Icons.image_not_supported),
                          )
                        : const Center(child: Icon(Icons.image, size: 40, color: Color(0xFF9B59B6))),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                ts.name,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTreehouseIllustration() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          // Background trees
          const Positioned(
            left: 10,
            top: 20,
            child: Text('🌳', style: TextStyle(fontSize: 24)),
          ),
          const Positioned(
            right: 10,
            top: 15,
            child: Text('🌲', style: TextStyle(fontSize: 20)),
          ),
          // Main treehouse
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Treehouse
                Container(
                  width: 70,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD2691E), Color(0xFF8B4513)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(2, 2),
                      ),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('🏠', style: TextStyle(fontSize: 20)),
                      SizedBox(height: 2),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('👦', style: TextStyle(fontSize: 12)),
                          Text('🧸', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                // Tree trunk
                Container(
                  width: 20,
                  height: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B4513),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          // Floating sparkles
          const Positioned(
            left: 5,
            top: 5,
            child: Text('✨', style: TextStyle(fontSize: 12)),
          ),
          const Positioned(
            right: 5,
            bottom: 10,
            child: Text('⭐', style: TextStyle(fontSize: 10)),
          ),
        ],
      ),
    );
  }

  Widget _buildBuddyIllustration() {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Stack(
        children: [
          // Background elements
          const Positioned(
            left: 5,
            top: 10,
            child: Text('🌤️', style: TextStyle(fontSize: 16)),
          ),
          const Positioned(
            right: 8,
            top: 5,
            child: Text('🦋', style: TextStyle(fontSize: 14)),
          ),
          // Main scene
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Girl and dog adventure
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Girl
                    Container(
                      width: 35,
                      height: 45,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF81C784), Color(0xFF4CAF50)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 3,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('👧', style: TextStyle(fontSize: 16)),
                          Text('🎒', style: TextStyle(fontSize: 10)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Dog
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text('🐕', style: TextStyle(fontSize: 28)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Adventure path
                Container(
                  width: 80,
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFEB3B), Color(0xFFFFC107)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ],
            ),
          ),
          // Adventure sparkles
          const Positioned(
            left: 15,
            bottom: 15,
            child: Text('✨', style: TextStyle(fontSize: 10)),
          ),
          const Positioned(
            right: 15,
            bottom: 20,
            child: Text('💫', style: TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildGardenIllustration() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('🌻', style: TextStyle(fontSize: 24)),
              Text('🌸', style: TextStyle(fontSize: 24)),
              Text('🌺', style: TextStyle(fontSize: 24)),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('🌿', style: TextStyle(fontSize: 20)),
              Text('🦋', style: TextStyle(fontSize: 20)),
              Text('🌿', style: TextStyle(fontSize: 20)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpaceIllustration() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('🚀', style: TextStyle(fontSize: 32)),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('⭐', style: TextStyle(fontSize: 16)),
              Text('🌙', style: TextStyle(fontSize: 20)),
              Text('⭐', style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildComingSoonIllustration() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: Colors.grey[400]!,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: const Center(
              child: Text('✨', style: TextStyle(fontSize: 24)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
} 