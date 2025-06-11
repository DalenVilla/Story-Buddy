import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TeacherClassDetailScreen extends StatelessWidget {
  final String className;
  final String grade;
  final String subject;
  final int students;

  const TeacherClassDetailScreen({
    super.key,
    required this.className,
    required this.grade,
    required this.subject,
    required this.students,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          className,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6B73FF),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(context),
            
            const SizedBox(height: 32),
            
            // Emotional Focus Areas
            _buildEmotionalFocusAreas(),
            
            const SizedBox(height: 32),
            
            // Quick Stats Panel
            _buildQuickStats(),
            
            const SizedBox(height: 32),
            
            // Student List
            _buildStudentList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Ms. Johnson's $grade",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$grade • $students students • $subject',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Edit class functionality coming soon!'),
                          backgroundColor: Color(0xFF6B73FF),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit Class'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6B73FF),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Copy class code to clipboard
                      const classCode = 'ABC123';
                      Clipboard.setData(const ClipboardData(text: classCode));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Class code ABC123 copied to clipboard!'),
                          backgroundColor: Color(0xFF6B73FF),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copy Code'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF6B73FF),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: const BorderSide(color: Color(0xFF6B73FF)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionalFocusAreas() {
    final emotions = [
      {'name': 'Empathy', 'icon': Icons.favorite, 'color': Colors.pink},
      {'name': 'Resilience', 'icon': Icons.shield, 'color': Colors.blue},
      {'name': 'Kindness', 'icon': Icons.star, 'color': Colors.amber},
      {'name': 'Confidence', 'icon': Icons.psychology, 'color': Colors.purple},
      {'name': 'Friendship', 'icon': Icons.people, 'color': Colors.green},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Emotional Focus Areas',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: emotions.length,
            itemBuilder: (context, index) {
              final emotion = emotions[index];
              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: Chip(
                  avatar: Icon(
                    emotion['icon'] as IconData,
                    color: emotion['color'] as Color,
                    size: 20,
                  ),
                  label: Text(
                    emotion['name'] as String,
                    style: TextStyle(
                      color: emotion['color'] as Color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  backgroundColor: (emotion['color'] as Color).withOpacity(0.1),
                  side: BorderSide(
                    color: (emotion['color'] as Color).withOpacity(0.3),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Stats',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.menu_book_outlined,
                value: '47',
                label: 'Total Stories\nRead',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.sentiment_very_satisfied,
                value: 'Joy',
                label: 'Most Selected\nEmotion',
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.timer_outlined,
                value: '8.5m',
                label: 'Average Story\nTime',
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.trending_up,
                value: '94%',
                label: 'Engagement\nRate',
                color: Colors.purple,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3436),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStudentList() {
    final students = [
      {
        'name': 'Emma S.',
        'lastStory': 'The Brave Little Fox',
        'emotions': ['Courage', 'Friendship'],
        'progress': 4,
        'maxProgress': 5,
      },
      {
        'name': 'Liam K.',
        'lastStory': 'Magic Garden Adventure',
        'emotions': ['Wonder', 'Kindness'],
        'progress': 3,
        'maxProgress': 5,
      },
      {
        'name': 'Sophia M.',
        'lastStory': 'The Helpful Robot',
        'emotions': ['Empathy', 'Innovation'],
        'progress': 5,
        'maxProgress': 5,
      },
      {
        'name': 'Noah P.',
        'lastStory': 'Journey to the Stars',
        'emotions': ['Curiosity', 'Perseverance'],
        'progress': 2,
        'maxProgress': 5,
      },
      {
        'name': 'Olivia R.',
        'lastStory': 'The Kind Dragon',
        'emotions': ['Compassion', 'Courage'],
        'progress': 4,
        'maxProgress': 5,
      },
      {
        'name': 'Ethan L.',
        'lastStory': 'Underwater Mystery',
        'emotions': ['Discovery', 'Teamwork'],
        'progress': 3,
        'maxProgress': 5,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Student Progress',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
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
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFF6B73FF).withOpacity(0.1),
                        child: Text(
                          student['name'].toString().substring(0, 1),
                          style: const TextStyle(
                            color: Color(0xFF6B73FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student['name'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D3436),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Last story: ${student['lastStory']}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      _buildProgressIndicator(
                        student['progress'] as int,
                        student['maxProgress'] as int,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        'Emotions practiced:',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Wrap(
                          spacing: 6,
                          children: (student['emotions'] as List<String>)
                              .map((emotion) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: _getEmotionColor(emotion).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: _getEmotionColor(emotion).withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      emotion,
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: _getEmotionColor(emotion),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(int progress, int maxProgress) {
    return Row(
      children: List.generate(maxProgress, (index) {
        return Container(
          margin: const EdgeInsets.only(right: 4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < progress
                ? const Color(0xFF6B73FF)
                : Colors.grey[300],
          ),
        );
      }),
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'courage':
      case 'perseverance':
        return Colors.red;
      case 'friendship':
      case 'teamwork':
        return Colors.green;
      case 'wonder':
      case 'curiosity':
      case 'discovery':
        return Colors.blue;
      case 'kindness':
      case 'compassion':
        return Colors.pink;
      case 'empathy':
        return Colors.purple;
      case 'innovation':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
} 