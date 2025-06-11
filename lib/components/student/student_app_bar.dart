import 'package:flutter/material.dart';

class StorytimeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String studentName;
  final String teacherName;
  final String grade;

  const StorytimeAppBar({
    super.key,
    this.studentName = 'Ava',
    this.teacherName = 'Ms. Johnson',
    this.grade = '3rd Grade',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Settings button row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.settings, color: Colors.grey[600]),
                    onPressed: () {
                      // Handle settings tap
                    },
                  ),
                ],
              ),
              
              // Greeting
              Text(
                '👋 Hi $studentName!',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              
              const SizedBox(height: 8),
              
              // Class welcome
              Text(
                '🎓 Welcome to $teacherName\'s $grade',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(155);
}