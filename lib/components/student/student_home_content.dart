import 'package:flutter/material.dart';
import '../../screens/student/story_onboarding_screen.dart';

class StorytimeHomeContent extends StatelessWidget {
  final List<Map<String, dynamic>> classEmotions;

  const StorytimeHomeContent({
    super.key,
    this.classEmotions = const [
      {'name': 'Bravery', 'emoji': '💪', 'color': Colors.red},
      {'name': 'Trying New Things', 'emoji': '🧠', 'color': Colors.blue},
      {'name': 'Kindness', 'emoji': '💖', 'color': Colors.pink},
    ],
  });

  @override
  Widget build(BuildContext context) {
    // Sample teacher-curated stories based on emotions
    final emotionBasedStories = [
      {
        'title': 'The Brave Little Mouse',
        'emotion': 'Bravery',
        'emoji': '🐭',
        'bigEmoji': '💪',
        'color': Colors.red,
        'description': 'A tiny mouse becomes super brave!',
        'backgroundImage': 'https://images.unsplash.com/photo-1518709268805-4e9042af2176?w=600&h=300&fit=crop&crop=center',
      },
      {
        'title': 'Lily\'s First Day Adventure',
        'emotion': 'Trying New Things',
        'emoji': '👧',
        'bigEmoji': '🧠',
        'color': Colors.blue,
        'description': 'Join Lily\'s exciting new adventure!',
        'backgroundImage': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=600&h=300&fit=crop&crop=center',
      },
      {
        'title': 'The Kindness Tree',
        'emotion': 'Kindness',
        'emoji': '🌳',
        'bigEmoji': '💖',
        'color': Colors.pink,
        'description': 'Watch kindness grow like magic!',
        'backgroundImage': 'https://images.unsplash.com/photo-1441974231531-c6227db76b6e?w=600&h=300&fit=crop&crop=center',
      },
      {
        'title': 'Max and the Friendship Club',
        'emotion': 'Friendship',
        'emoji': '🐶',
        'bigEmoji': '🤝',
        'color': Colors.orange,
        'description': 'Making friends is awesome!',
        'backgroundImage': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=600&h=300&fit=crop&crop=center',
      },
      {
        'title': 'The Curious Cat\'s Quest',
        'emotion': 'Curiosity',
        'emoji': '🐱',
        'bigEmoji': '🔍',
        'color': Colors.purple,
        'description': 'Explore with the curious cat!',
        'backgroundImage': 'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=600&h=300&fit=crop&crop=center',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message with big friendly text
          Stack(
            children: [
              // Hanging monkey on the left
              Positioned(
                left: -40,
                top: 0,
                child: Container(
                  width: 150,
                  height: 120,
                  child: Image.asset(
                    'lib/assets/hang_monkey.gif',
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Text('🐵', style: TextStyle(fontSize: 20));
                    },
                  ),
                ),
              ),
              // Main content centered
              Center(
                child: Column(
                  children: [
                    const SizedBox(width: 8),
                    Container(
                      width: 100,
                      height: 100,
                      child: Image.asset(
                        'lib/assets/floating_monkey.gif',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('🐵', style: TextStyle(fontSize: 24));
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Story Time! 📚✨',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6B73FF),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Stories specially picked for your class!',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Quick action button - Write Story
          Center(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 400),
              child: _buildBigActionButton(
                emoji: '✏️',
                title: 'Write Story',
                color: const Color(0xFF6B73FF),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StoryOnboardingScreen(),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Quick action button - Create Adventure
          Center(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(maxWidth: 400),
              child: _buildBigActionButton(
                emoji: '🗺️',
                title: 'Create Adventure',
                color: const Color(0xFF9B59B6),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const StoryOnboardingScreen(isAdventure: true),
                    ),
                  );
                },
              ),
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Fun divider
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 3,
                  width: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6B73FF), Color(0xFF9B59B6)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('🌟', style: TextStyle(fontSize: 24)),
                ),
                Container(
                  height: 3,
                  width: 60,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF9B59B6), Color(0xFF6B73FF)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 40),
          
          // Stories section title
          const Center(
            child: Text(
              '🎭 Amazing Stories for You!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Teacher stories - big kid-friendly cards
          ...emotionBasedStories.map((story) {
            return Container(
              margin: const EdgeInsets.only(bottom: 20),
              child: _buildKidFriendlyStoryCard(story),
            );
          }).toList(),
          
          const SizedBox(height: 32),
          
          // Bottom encouragement message
          Center(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B73FF), Color(0xFF9B59B6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B73FF).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Text(
                    '🌟',
                    style: TextStyle(fontSize: 32),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Keep Reading!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You\'re doing amazing! 🎉',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBigActionButton({
    required String emoji,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: color.withOpacity(0.4),
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 40),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKidFriendlyStoryCard(Map<String, dynamic> story) {
    return GestureDetector(
      onTap: () {
        // Handle story tap
      },
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Background image
              Positioned.fill(
                child: Image.network(
                  story['backgroundImage'] as String,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: (story['color'] as Color).withOpacity(0.3),
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            (story['color'] as Color).withOpacity(0.8),
                            (story['color'] as Color),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    );
                  },
                ),
              ),
              
              // Dark overlay for better text readability
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.black.withOpacity(0.6),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
              
              // Content overlay
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      // Left side - Story info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Emotion chip with emoji
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    story['bigEmoji'] as String,
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    story['emotion'] as String,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(1, 1),
                                          blurRadius: 2,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 12),
                            
                            // Story title with black outline
                            Text(
                              story['title'] as String,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(-1, -1),
                                    blurRadius: 2,
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    offset: Offset(1, -1),
                                    blurRadius: 2,
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    offset: Offset(-1, 1),
                                    blurRadius: 2,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            
                            const SizedBox(height: 8),
                            
                            // Story description with black outline
                            Text(
                              story['description'] as String,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    offset: Offset(-1, -1),
                                    blurRadius: 2,
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    offset: Offset(1, -1),
                                    blurRadius: 2,
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: Colors.black,
                                  ),
                                  Shadow(
                                    offset: Offset(-1, 1),
                                    blurRadius: 2,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(width: 16),
                      
                      // Right side - Play button
                      Container(
                        width: 70,
                        height: 70,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.play_arrow,
                          color: story['color'] as Color,
                          size: 36,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
