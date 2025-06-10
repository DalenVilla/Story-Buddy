// lib/library/widgets/section_title.dart
import 'package:flutter/material.dart';

class SectionTitle extends StatelessWidget {
  final String text;
  const SectionTitle(this.text);
  @override
  Widget build(_) => Padding(
    padding:EdgeInsets.symmetric(vertical:12),
    child: Text(text, style:TextStyle(fontSize:18, fontWeight:FontWeight.bold))
  );
}
