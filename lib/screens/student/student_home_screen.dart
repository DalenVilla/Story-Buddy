import 'package:flutter/material.dart';
import '../../components/student/student_app_bar.dart';
import '../../components/student/student_home_content.dart';
import '../../components/student/student_bottom_nav_bar.dart';
import '../../services/user_service.dart';
import 'story_library_screen.dart';
import 'student_profile_screen.dart';

class StorytimeHomeScreen extends StatefulWidget {
  final String studentName;
  final String teacherName;
  final String grade;
  
  const StorytimeHomeScreen({
    super.key,
    this.studentName = 'Ava',
    this.teacherName = 'Mr. Villa',
    this.grade = '3rd Grade',
  });

  @override
  State<StorytimeHomeScreen> createState() => _StorytimeHomeScreenState();
}

class _StorytimeHomeScreenState extends State<StorytimeHomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Set current user when home screen loads
    UserService.setCurrentUser(widget.studentName, userType: 'student');
  }

  @override
  Widget build(BuildContext context) {
    const classEmotions = [
      {'name': 'Bravery', 'emoji': '💪', 'color': Colors.red},
      {'name': 'Trying New Things', 'emoji': '🧠', 'color': Colors.blue},
      {'name': 'Kindness', 'emoji': '💖', 'color': Colors.pink},
    ];

    // Define the pages for each nav item
    final List<Widget> pages = [
      // Home page - main content with app bar
      Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: StorytimeAppBar(
          studentName: widget.studentName,
          teacherName: widget.teacherName,
          grade: widget.grade,
        ),
        body: StorytimeHomeContent(
          classEmotions: classEmotions,
        ),
      ),
                    // Library page - create new instance each time to ensure fresh data
              StoryLibraryScreen(key: ValueKey(_currentIndex)),
      // Profile page
      StudentProfileScreen(
        studentName: widget.studentName,
        teacherName: widget.teacherName,
        grade: widget.grade,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: StorytimeBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}