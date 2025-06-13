import 'package:flutter/material.dart';
import 'teacher_dashboard_screen.dart';
import 'teacher_classes_screen.dart';
import 'teacher_actual_home_screen.dart';
import 'teacher_stories_screen.dart';

class TeacherHomeScreen extends StatefulWidget {
  const TeacherHomeScreen({super.key});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  int _currentIndex = 0;

  List<Widget> get _screens => [
    TeacherActualHomeScreen(onNavigate: (index) {
      setState(() {
        _currentIndex = index;
      });
    }),
    TeacherDashboardScreen(onNavigateToClasses: () {
      setState(() {
        _currentIndex = 2; // Switch to Classes tab
      });
    }),
    const TeacherClassesScreen(),
    const TeacherStoriesScreen(),
    const PlaceholderScreen(title: 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF6B73FF),
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 24),
              activeIcon: Icon(Icons.home, size: 24),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined, size: 24),
              activeIcon: Icon(Icons.dashboard, size: 24),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.class_outlined, size: 24),
              activeIcon: Icon(Icons.class_, size: 24),
              label: 'Classes',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.auto_stories_outlined, size: 24),
              activeIcon: Icon(Icons.auto_stories, size: 24),
              label: 'Stories',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_outlined, size: 24),
              activeIcon: Icon(Icons.settings, size: 24),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF6B73FF),
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF6B73FF).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.construction_outlined,
                size: 64,
                color: const Color(0xFF6B73FF),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              '$title Screen',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'This feature is coming soon!',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}