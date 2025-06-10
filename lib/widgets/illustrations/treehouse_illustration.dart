import 'package:flutter/material.dart';

class TreehouseIllustration extends StatelessWidget {
  const TreehouseIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Spacer(),
          CircleAvatar(
            radius: 25,
            backgroundColor: Color(0xFF8B7355),
            child: Icon(Icons.person, color: Colors.white, size: 30),
          ),
          SizedBox(height: 10),
          Icon(Icons.pets, color: Color(0xFFD2691E), size: 25),
        ],
      ),
    );
  }
}
