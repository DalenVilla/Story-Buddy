import 'package:flutter/material.dart';
import '../widgets/story_card.dart';
import '../widgets/illustrations/treehouse_illustration.dart';
import '../widgets/illustrations/buddy_illustration.dart';
import '../widgets/illustrations/woods_illustration.dart';

class MyStoryJourneySection extends StatelessWidget {
  const MyStoryJourneySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Story Journey',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 200,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              StoryCard(
                title: 'The Magical Treehouse',
                backgroundColor: const Color(0xFFE8D5B7),
                onTap: () {
                  // Handle treehouse story tap
                },
                child: const TreehouseIllustration(),
              ),
              const SizedBox(width: 15),
              StoryCard(
                title: 'Adventures with Buddy',
                backgroundColor: const Color(0xFFE8D5D5),
                onTap: () {
                  // Handle buddy story tap
                },
                child: const BuddyIllustration(),
              ),
              const SizedBox(width: 15),
              StoryCard(
                title: 'The Wonder Woods',
                backgroundColor: const Color(0xFFD5E8D5),
                onTap: () {
                  // Handle woods story tap
                },
                child: const WoodsIllustration(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
