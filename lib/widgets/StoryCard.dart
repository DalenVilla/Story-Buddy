// lib/library/widgets/story_card.dart
import 'package:flutter/material.dart';

class StoryCard extends StatelessWidget {
  final String title, imagePath;
  const StoryCard({required this.title, required this.imagePath});
  @override
  Widget build(_) => Column(
    children:[
      Container(height:120, width:100, child: Image.asset(imagePath, fit:BoxFit.cover)),
      SizedBox(height:8),
      Text(title, style:TextStyle(fontSize:14))
    ]
  );
}
