import 'package:flutter/material.dart';

class ViewAllStudentsScreen extends StatelessWidget {
  final String className;
  final String grade;
  
  const ViewAllStudentsScreen({
    super.key,
    required this.className,
    required this.grade,
  });

  @override
  Widget build(BuildContext context) {
    // All students data - in a real app this would come from a database
    final allStudentsData = [
      {
        'name': 'Emma S.',
        'lastStory': 'The Brave Little Fox',
        'emotions': ['Courage', 'Friendship'],
        'progress': 4,
        'maxProgress': 5,
        'className': 'Morning Reading',
        'grade': '2nd Grade',
      },
      {
        'name': 'Liam K.',
        'lastStory': 'Magic Garden Adventure',
        'emotions': ['Wonder', 'Kindness'],
        'progress': 3,
        'maxProgress': 5,
        'className': 'Morning Reading',
        'grade': '2nd Grade',
      },
      {
        'name': 'Sophia M.',
        'lastStory': 'The Helpful Robot',
        'emotions': ['Empathy', 'Innovation'],
        'progress': 5,
        'maxProgress': 5,
        'className': 'Morning Reading',
        'grade': '2nd Grade',
      },
      {
        'name': 'Noah P.',
        'lastStory': 'Journey to the Stars',
        'emotions': ['Curiosity', 'Perseverance'],
        'progress': 2,
        'maxProgress': 5,
        'className': 'Morning Reading',
        'grade': '2nd Grade',
      },
      {
        'name': 'Olivia R.',
        'lastStory': 'The Kind Dragon',
        'emotions': ['Compassion', 'Courage'],
        'progress': 4,
        'maxProgress': 5,
        'className': 'Morning Reading',
        'grade': '2nd Grade',
      },
      {
        'name': 'Ethan L.',
        'lastStory': 'Underwater Mystery',
        'emotions': ['Discovery', 'Teamwork'],
        'progress': 3,
        'maxProgress': 5,
        'className': 'Morning Reading',
        'grade': '2nd Grade',
      },
      {
        'name': 'Isabella T.',
        'lastStory': 'Forest Friends',
        'emotions': ['Friendship', 'Kindness'],
        'progress': 5,
        'maxProgress': 5,
        'className': 'Morning Reading',
        'grade': '2nd Grade',
      },
      {
        'name': 'Mason B.',
        'lastStory': 'Super Hero Academy',
        'emotions': ['Courage', 'Justice'],
        'progress': 3,
        'maxProgress': 5,
        'className': 'Morning Reading',
        'grade': '2nd Grade',
      },
      {
        'name': 'Ava C.',
        'lastStory': 'Musical Journey',
        'emotions': ['Joy', 'Creativity'],
        'progress': 4,
        'maxProgress': 5,
        'className': 'Morning Reading',
        'grade': '2nd Grade',
      },
      {
        'name': 'Lucas D.',
        'lastStory': 'Time Travel Adventure',
        'emotions': ['Curiosity', 'Wonder'],
        'progress': 2,
        'maxProgress': 5,
        'className': 'Morning Reading',
        'grade': '2nd Grade',
      },
    ];

    // Filter students to only show those from the current class
    final students = allStudentsData
        .where((student) => student['className'] == className)
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          '$className Students',
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
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6B73FF), Color(0xFF9B59B6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF6B73FF).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$className',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${students.length} students • $grade',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Students List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: const Color(0xFF6B73FF).withOpacity(0.1),
                            child: Text(
                              student['name'].toString().substring(0, 1),
                              style: const TextStyle(
                                color: Color(0xFF6B73FF),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
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
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2D3436),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Last active: 2 hours ago',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[500],
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
                      
                      // Last Story
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.auto_stories_outlined,
                              color: Colors.grey[600],
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Last story: ',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                student['lastStory'] as String,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(0xFF2D3436),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Emotions
                      Row(
                        children: [
                          Text(
                            'Emotions practiced:',
                            style: TextStyle(
                              fontSize: 14,
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
                                          horizontal: 10,
                                          vertical: 6,
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
                                            fontSize: 12,
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
        ),
      ),
    );
  }



  Widget _buildProgressIndicator(int progress, int maxProgress) {
    return Column(
      children: [
        Row(
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
        ),
        const SizedBox(height: 4),
        Text(
          '$progress/$maxProgress',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
      case 'creativity':
        return Colors.orange;
      case 'joy':
        return Colors.amber;
      case 'justice':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
} 