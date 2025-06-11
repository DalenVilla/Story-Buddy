import 'package:flutter/material.dart';

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
        'emoji': '💪',
        'color': Colors.red,
        'description': 'Follow a tiny mouse as they overcome their biggest fears!',
      },
      {
        'title': 'Lily\'s First Day Adventure',
        'emotion': 'Trying New Things',
        'emoji': '🧠',
        'color': Colors.blue,
        'description': 'Join Lily as she tries something completely new and exciting!',
      },
      {
        'title': 'The Kindness Tree',
        'emotion': 'Kindness',
        'emoji': '💖',
        'color': Colors.pink,
        'description': 'Discover how small acts of kindness can grow into something magical!',
      },
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current class emotions section
          _buildClassEmotionsSection(),
          
          const SizedBox(height: 32),
          
          // What do you want to do today?
          const Text(
            '👇 What do you want to do today?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Main action buttons
          Row(
            children: [
              // Start a New Story button
              Expanded(
                child: _buildActionButton(
                  icon: '📝',
                  title: 'Start a New Story',
                  subtitle: 'Create your own adventure',
                  color: const Color(0xFF6B73FF),
                  onTap: () {
                    // Navigate to story creation
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Story creation coming soon!'),
                        backgroundColor: Color(0xFF6B73FF),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(width: 16),
              
              // See My Stories button
              Expanded(
                child: _buildActionButton(
                  icon: '📚',
                  title: 'See My Stories',
                  subtitle: 'View your collection',
                  color: const Color(0xFF9B59B6),
                  onTap: () {
                    // Navigate to story library
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Story library coming soon!'),
                        backgroundColor: Color(0xFF9B59B6),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Stories from teacher section
          Row(
            children: [
              const Text(
                '👨‍🏫 Stories from Ms. Johnson',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {
                  // View all teacher stories
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                    color: const Color(0xFF6B73FF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 4),
          
          Text(
            'Stories specially picked for your class emotions:',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Teacher stories based on emotions
          ...emotionBasedStories.map((story) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: _buildStoryCard(story),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              icon,
              style: const TextStyle(fontSize: 32),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStoryCard(Map<String, dynamic> story) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Story emotion chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: (story['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (story['color'] as Color).withOpacity(0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  story['emoji'] as String,
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
          
          const SizedBox(width: 16),
          
          // Story details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story['title'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 4),
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
          
          // Play button
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6B73FF).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.play_arrow,
              color: Color(0xFF6B73FF),
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassEmotionsSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            '🎯 This current class emotions:',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3436),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Emotion chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: classEmotions.map((emotion) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: (emotion['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: (emotion['color'] as Color).withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        emotion['emoji'] as String,
                        style: const TextStyle(fontSize: 20),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        emotion['name'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: emotion['color'] as Color,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
