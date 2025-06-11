import 'package:flutter/material.dart';
import '../../sections/student/welcome_section.dart';
import '../../sections/student/discover_button_section.dart';
import '../../sections/student/my_story_journey_section.dart';
import '../../sections/student/for_teachers_section.dart';


class StorytimeHomeContent extends StatelessWidget {
  const StorytimeHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WelcomeSection(),
          const SizedBox(height: 30),
          const DiscoverButtonSection(),
          const SizedBox(height: 30),
          const MyStoryJourneySection(),
          const SizedBox(height: 30),
          const ForTeachersSection(),
        ],
      ),
    );
  }
}
