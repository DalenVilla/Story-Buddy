import 'package:flutter/material.dart';

class SchoolIllustration extends StatelessWidget {
  const SchoolIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.school, size: 50, color: Color(0xFF1976D2)),
          SizedBox(height: 10),
          Icon(Icons.menu_book, size: 30, color: Color(0xFF8B4513)),
        ],
      ),
    );
  }
}