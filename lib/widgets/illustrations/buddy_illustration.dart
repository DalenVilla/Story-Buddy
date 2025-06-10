import 'package:flutter/material.dart';

class BuddyIllustration extends StatelessWidget {
  const BuddyIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.brown, width: 3),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Color(0xFF8B4513),
                  child: Icon(Icons.person, color: Colors.white, size: 20),
                ),
                SizedBox(height: 5),
                Icon(Icons.pets, color: Color(0xFFD2691E), size: 20),
                SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
