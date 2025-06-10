
// lib/library/widgets/bottom_nav.dart
import 'package:flutter/material.dart';



class BottomNav extends StatelessWidget {
  @override
  Widget build(_) => BottomNavigationBar(
    items:[
      BottomNavigationBarItem(icon:Icon(Icons.home), label:'Home'),
      BottomNavigationBarItem(icon:Icon(Icons.book), label:'Library'),
      BottomNavigationBarItem(icon:Icon(Icons.person), label:'Profile'),
    ]
  );
}
