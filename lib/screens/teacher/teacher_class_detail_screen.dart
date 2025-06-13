import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'view_all_students_screen.dart';
import 'student_analytics_screen.dart';

class TeacherClassDetailScreen extends StatefulWidget {
  final Map<String, dynamic> classData;

  const TeacherClassDetailScreen({
    super.key,
    required this.classData,
  });

  @override
  State<TeacherClassDetailScreen> createState() => _TeacherClassDetailScreenState();
}

class _TeacherClassDetailScreenState extends State<TeacherClassDetailScreen> {
  // Current selected emotions (up to 3)
  List<String> selectedEmotions = ['Empathy', 'Resilience', 'Kindness'];

  // All available emotions (9 total)
  final List<Map<String, dynamic>> allEmotions = [
    {'name': 'Empathy', 'icon': Icons.favorite, 'color': Colors.pink},
    {'name': 'Resilience', 'icon': Icons.shield, 'color': Colors.blue},
    {'name': 'Kindness', 'icon': Icons.star, 'color': Colors.amber},
    {'name': 'Confidence', 'icon': Icons.psychology, 'color': Colors.purple},
    {'name': 'Friendship', 'icon': Icons.people, 'color': Colors.green},
    {'name': 'Courage', 'icon': Icons.bolt, 'color': Colors.red},
    {'name': 'Patience', 'icon': Icons.schedule, 'color': Colors.teal},
    {'name': 'Gratitude', 'icon': Icons.celebration, 'color': Colors.orange},
    {'name': 'Curiosity', 'icon': Icons.search, 'color': Colors.indigo},
  ];

  // Helper getters for class data
  String get className => widget.classData['name'] ?? 'Unknown Class';
  String get grade => widget.classData['grade'] ?? 'Unknown Grade';
  int get studentCount {
    // Safely determine student count regardless of underlying data type
    if (widget.classData.containsKey('studentsList') && widget.classData['studentsList'] is List) {
      return (widget.classData['studentsList'] as List).length;
    }
    if (widget.classData['students'] is int) {
      return widget.classData['students'] as int;
    }
    if (widget.classData['students'] is List) {
      return (widget.classData['students'] as List).length;
    }
    return 0;
  }
  List<String> get studentsList => widget.classData['isHardcoded'] == true
      ? List<String>.from(widget.classData['studentsList'] ?? [])
      : List<String>.from(widget.classData['students'] ?? []);
  
  // Stats with defaults for new classes
  int get storiesRead => widget.classData['storiesRead'] ?? 0;
  dynamic get engagementRate => widget.classData['engagementRate'] ?? 'N/A';
  String get averageReadingTime => widget.classData['averageReadingTime'] ?? 'N/A';
  String get popularEmotion => widget.classData['popularEmotion'] ?? 'N/A';
  int get weeklyProgress => widget.classData['weeklyProgress'] ?? 0;
  String get lastActivity => widget.classData['lastActivity'] ?? 'Just created';
  List<String> get achievements => List<String>.from(widget.classData['achievements'] ?? []);
  int get currentStreak => widget.classData['currentStreak'] ?? 0;
  dynamic get totalReadingHours => widget.classData['totalReadingHours'] ?? 0.0;

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
                      "Mr. Villa's $grade",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2D3436),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$grade • $studentCount students',
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Current Emotional Focus',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            TextButton.icon(
              onPressed: () => _showEmotionSelectionDialog(),
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Edit'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF6B73FF),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: selectedEmotions.length,
            itemBuilder: (context, index) {
              final emotionName = selectedEmotions[index];
              final emotion = allEmotions.firstWhere(
                (e) => e['name'] == emotionName,
              );
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
                value: storiesRead.toString(),
                label: 'Total Stories\nRead',
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.favorite,
                value: popularEmotion,
                label: 'Popular\nEmotion',
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
                value: averageReadingTime,
                label: 'Average Reading\nTime',
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                icon: Icons.trending_up,
                value: engagementRate is int ? '${engagementRate}%' : engagementRate.toString(),
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
    final students = studentsList;
    
    // For hardcoded classes, create sample data
    List<Map<String, dynamic>> allStudents = [];
    if (students.isNotEmpty) {
      final sampleStories = [
        'The Brave Little Fox',
        'Magic Garden Adventure', 
        'The Helpful Robot',
        'Journey to the Stars',
        'The Kind Dragon',
        'Underwater Mystery',
        'Rainbow Bridge Quest',
        'Secret Forest Path',
        'Dancing Butterfly',
        'Mountain Echo',
        'Ocean Whispers',
        'Star Collector'
      ];
      
      final sampleEmotions = [
        ['Courage', 'Friendship'],
        ['Wonder', 'Kindness'],
        ['Empathy', 'Innovation'],
        ['Curiosity', 'Perseverance'],
        ['Compassion', 'Courage'],
        ['Discovery', 'Teamwork']
      ];
      
      allStudents = students.asMap().entries.map((entry) {
        final index = entry.key;
        final name = entry.value;
        return {
          'name': name,
          'lastStory': sampleStories[index % sampleStories.length],
          'emotions': sampleEmotions[index % sampleEmotions.length],
          'progress': (index % 5) + 1,
          'maxProgress': 5,
        };
      }).toList();
    }

    // Show only first 4 students
    final displayStudents = allStudents.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Students',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 4),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewAllStudentsScreen(
                      className: className,
                      grade: grade,
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6B73FF).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color(0xFF6B73FF).withOpacity(0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        color: const Color(0xFF6B73FF),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: const Color(0xFF6B73FF),
                      size: 14,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        displayStudents.isEmpty 
          ? _buildEmptyStudentState()
          : ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: displayStudents.length,
              itemBuilder: (context, index) {
                final student = displayStudents[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentAnalyticsScreen(
                          studentName: student['name'] as String,
                          grade: grade,
                          className: className,
                        ),
                      ),
                    );
                  },
                  child: Container(
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
                  ),
                );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyStudentState() {
    return Container(
      padding: const EdgeInsets.all(40),
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
        children: [
          Icon(
            Icons.people_outline,
            size: 48,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No students yet',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Students will appear here once they join your class using the class code.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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

  void _showEmotionSelectionDialog() {
    List<String> tempSelectedEmotions = List.from(selectedEmotions);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B73FF).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.psychology_outlined,
                            color: Color(0xFF6B73FF),
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Select Emotional Focus',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2D3436),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.close),
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Choose up to 3 emotional themes for your class (${tempSelectedEmotions.length}/3 selected)',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 24),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: allEmotions.map((emotion) {
                        final emotionName = emotion['name'] as String;
                        final isSelected = tempSelectedEmotions.contains(emotionName);
                        final canSelect = tempSelectedEmotions.length < 3 || isSelected;

                        return GestureDetector(
                          onTap: canSelect ? () {
                            setState(() {
                              if (isSelected) {
                                tempSelectedEmotions.remove(emotionName);
                              } else {
                                if (tempSelectedEmotions.length < 3) {
                                  tempSelectedEmotions.add(emotionName);
                                }
                              }
                            });
                          } : null,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (emotion['color'] as Color).withOpacity(0.2)
                                  : Colors.grey[50],
                              border: Border.all(
                                color: isSelected
                                    ? emotion['color'] as Color
                                    : canSelect
                                        ? Colors.grey[300]!
                                        : Colors.grey[200]!,
                                width: isSelected ? 2 : 1,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  emotion['icon'] as IconData,
                                  color: isSelected || canSelect
                                      ? emotion['color'] as Color
                                      : Colors.grey[400],
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  emotionName,
                                  style: TextStyle(
                                    color: isSelected
                                        ? emotion['color'] as Color
                                        : canSelect
                                            ? const Color(0xFF2D3436)
                                            : Colors.grey[400],
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                                  ),
                                ),
                                if (isSelected) ...[
                                  const SizedBox(width: 8),
                                  Icon(
                                    Icons.check_circle,
                                    color: emotion['color'] as Color,
                                    size: 18,
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              side: BorderSide(color: Colors.grey[300]!),
                            ),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: tempSelectedEmotions.isNotEmpty ? () {
                              this.setState(() {
                                selectedEmotions = List.from(tempSelectedEmotions);
                              });
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Emotional focus updated! Now focusing on: ${tempSelectedEmotions.join(", ")}',
                                  ),
                                  backgroundColor: const Color(0xFF6B73FF),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            } : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6B73FF),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
} 