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
        'image': '🏰', // Castle placeholder
      },
      {
        'title': 'Lily\'s First Day Adventure',
        'emotion': 'Trying New Things',
        'emoji': '👧',
        'bigEmoji': '🧠',
        'color': Colors.blue,
        'description': 'Join Lily\'s exciting new adventure!',
        'image': '🌈', // Rainbow placeholder
      },
      {
        'title': 'The Kindness Tree',
        'emotion': 'Kindness',
        'emoji': '🌳',
        'bigEmoji': '💖',
        'color': Colors.pink,
        'description': 'Watch kindness grow like magic!',
        'image': '🌸', // Flower placeholder
      },
      {
        'title': 'Max and the Friendship Club',
        'emotion': 'Friendship',
        'emoji': '🐶',
        'bigEmoji': '🤝',
        'color': Colors.orange,
        'description': 'Making friends is awesome!',
        'image': '🎈', // Balloon placeholder
      },
      {
        'title': 'The Curious Cat\'s Quest',
        'emotion': 'Curiosity',
        'emoji': '🐱',
        'bigEmoji': '🔍',
        'color': Colors.purple,
        'description': 'Explore with the curious cat!',
        'image': '🚀', // Rocket placeholder
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome message with big friendly text
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
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: (story['color'] as Color).withOpacity(0.3),
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
        child: Row(
          children: [
            // Big emoji image placeholder
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: (story['color'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: (story['color'] as Color).withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  story['image'] as String,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            
            const SizedBox(width: 20),
            
            // Story details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Emotion chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: (story['color'] as Color).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
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
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: story['color'] as Color,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 12),
                  
                  Text(
                    story['title'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D3436),
                    ),
                  ),
                  
                  const SizedBox(height: 6),
                  
                  Text(
                    story['description'] as String,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            
            // Big play button
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: story['color'] as Color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (story['color'] as Color).withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
