import 'package:flutter/material.dart';
import '../../components/storytime_app_bar.dart';
import '../../components/storytime_home_content.dart';
import '../../components/storytime_bottom_nav_bar.dart';

class StorytimeHomeScreen extends StatefulWidget {
  const StorytimeHomeScreen({super.key});

  @override
  State<StorytimeHomeScreen> createState() => _StorytimeHomeScreenState();
}

class _StorytimeHomeScreenState extends State<StorytimeHomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: const StorytimeAppBar(),
      body: const StorytimeHomeContent(),
      bottomNavigationBar: StorytimeBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}