import 'package:flutter/material.dart';
import '../../widgets/story_card.dart';
import '../../widgets/illustrations/classroom_illustration.dart';
import '../../widgets/illustrations/field_trip_illustration.dart';
import '../../widgets/illustrations/school_illustration.dart';

class ForTeachersSection extends StatelessWidget {
  const ForTeachersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'For Teachers',
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
                title: 'Classroom Adventure',
                backgroundColor: const Color(0xFFE8D5B7),
                onTap: () {
                  // Handle classroom story tap
                },
                child: const ClassroomIllustration(),
              ),
              const SizedBox(width: 15),
              StoryCard(
                title: 'Field Trip Fun',
                backgroundColor: const Color(0xFFD5E8D5),
                onTap: () {
                  // Handle field trip story tap
                },
                child: const FieldTripIllustration(),
              ),
              const SizedBox(width: 15),
              StoryCard(
                title: 'School Days',
                backgroundColor: const Color(0xFFE8D5D5),
                onTap: () {
                  // Handle school days story tap
                },
                child: const SchoolIllustration(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
