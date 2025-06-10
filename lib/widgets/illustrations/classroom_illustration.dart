import 'package:flutter/material.dart';

class ClassroomIllustration extends StatelessWidget {
  const ClassroomIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Center(
              child: Text(
                'ABC',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStudent(Colors.red),
              _buildStudent(Colors.blue),
              _buildStudent(Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStudent(Color color) {
    return CircleAvatar(
      radius: 12,
      backgroundColor: color,
      child: const Icon(Icons.person, color: Colors.white, size: 16),
    );
  }
}
