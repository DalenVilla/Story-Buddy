import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'teacher_class_detail_screen.dart';
import 'teacher_dashboard_screen.dart';
import 'dart:async';

class TeacherClassesScreen extends StatefulWidget {
  const TeacherClassesScreen({super.key});

  @override
  State<TeacherClassesScreen> createState() => _TeacherClassesScreenState();
}

class _TeacherClassesScreenState extends State<TeacherClassesScreen> {
  List<Map<String, dynamic>> _localClasses = [];
  bool _isLoading = true;

  Timer? _refreshTimer;

  // Hardcoded classes to show alongside local ones
  final List<Map<String, dynamic>> _hardcodedClasses = [
    {
      'id': 'hardcoded_1',
      'name': 'Morning Reading',
      'grade': '3rd Grade',
      'studentsList': ['Emma S.', 'Liam K.', 'Sophia M.', 'Noah P.', 'Olivia R.', 'Ava T.', 'Jackson L.', 'Isabella M.', 'Lucas W.', 'Mia R.', 'Ethan C.', 'Charlotte H.'],
      'students': 12,
      'stories': 8,
      'storiesRead': 47,
      'engagementRate': 89,
      'averageReadingTime': '12 min',
      'popularEmotion': 'Empathy',
      'weeklyProgress': 15,
      'lastActivity': '2 hours ago',
      'color': Colors.blue,
      'isHardcoded': true,
      'achievements': ['Reading Champion', 'Story Explorer'],
      'currentStreak': 7,
      'totalReadingHours': 23.5,
    },
    {
      'id': 'hardcoded_2',
      'name': 'Creative Stories',
      'grade': '4th Grade',
      'studentsList': ['Alex T.', 'Maya L.', 'James W.', 'Isabella C.', 'Lucas D.', 'Zoe R.', 'Mason K.', 'Lily P.', 'Oliver S.', 'Grace M.', 'Benjamin F.', 'Chloe A.', 'Henry J.', 'Emma B.', 'Samuel G.'],
      'students': 15,
      'stories': 5,
      'storiesRead': 32,
      'engagementRate': 76,
      'averageReadingTime': '9 min',
      'popularEmotion': 'Curiosity',
      'weeklyProgress': 12,
      'lastActivity': '4 hours ago',
      'color': Colors.green,
      'isHardcoded': true,
      'achievements': ['Creative Thinker', 'Imagination Master'],
      'currentStreak': 4,
      'totalReadingHours': 18.2,
    },
   ];

  @override
  void initState() {
    super.initState();
    _loadLocalClasses();

    // Set up periodic refresh to capture delayed student additions
    _refreshTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _loadLocalClasses();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadLocalClasses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final classesJson = prefs.getString('teacher_classes') ?? '[]';
      final List<dynamic> classesList = jsonDecode(classesJson);
      setState(() {
        _localClasses = classesList.cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading local classes: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get _allClasses {
    return [..._hardcodedClasses, ..._localClasses];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'My Classes',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6B73FF),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Active Classes',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B73FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _isLoading ? 'Loading...' : '${_allClasses.length} Classes',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B73FF),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Class Cards
            if (_isLoading)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF6B73FF)),
                  ),
                ),
              )
            else
              ..._allClasses.map((classData) => Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: _buildClassCard(
                  context: context,
                  classData: classData,
                ),
              )).toList(),
            
            const SizedBox(height: 32),
            
            // Add Class Button
            GestureDetector(
              onTap: () => _showCreateClassDialog(context),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF6B73FF).withOpacity(0.3),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
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
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6B73FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.add,
                        color: Color(0xFF6B73FF),
                        size: 32,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Create New Class',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6B73FF),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start building your classroom community',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassCard({
    required BuildContext context,
    required Map<String, dynamic> classData,
  }) {
    final bool isHardcoded = classData['isHardcoded'] ?? false;
    final String className = classData['name'] ?? 'Unknown Class';
    final String grade = classData['grade'] ?? 'Unknown Grade';
    // Safely determine student count to avoid type errors
    int students = 0;
    if (classData.containsKey('studentsList') && classData['studentsList'] is List) {
      students = (classData['studentsList'] as List).length;
    } else if (classData['students'] is int) {
      students = classData['students'] as int;
    } else if (classData['students'] is List) {
      students = (classData['students'] as List).length;
    }
    final int stories = classData['stories'] ?? 0;
    final String lastActivity = isHardcoded 
        ? (classData['lastActivity'] ?? 'No activity') 
        : 'Just created';
    final Color color = classData['color'] is int 
        ? Color(classData['color']) 
        : (classData['color'] ?? Colors.grey);
    
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeacherClassDetailScreen(
              classData: classData,
            ),
          ),
        );
      },
      child: Container(
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
            // Header Row
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.class_outlined,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        className,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2D3436),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        grade,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6B73FF).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios,
                    color: Color(0xFF6B73FF),
                    size: 16,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Stats Row
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.people_outline,
                    value: '$students',
                    label: 'Students',
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.auto_stories_outlined,
                    value: '$stories',
                    label: 'Stories',
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.access_time,
                    value: lastActivity.split(' ')[0],
                    label: lastActivity.split(' ').sublist(1).join(' '),
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D3436),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _showCreateClassDialog(BuildContext context) async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const CreateClassWizard();
      },
    );
    
    // If a class was created, refresh the list
    if (result == 'refresh') {
      _loadLocalClasses();
    }
  }
}
