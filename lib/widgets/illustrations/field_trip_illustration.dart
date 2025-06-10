import 'package:flutter/material.dart';

class FieldTripIllustration extends StatelessWidget {
  const FieldTripIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.park, color: Colors.green[700], size: 40),
              const SizedBox(width: 10),
              Icon(Icons.park, color: Colors.green[600], size: 35),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.orange[400],
                child: const Icon(Icons.person, color: Colors.white, size: 12),
              ),
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.blue[400],
                child: const Icon(Icons.person, color: Colors.white, size: 12),
              ),
              CircleAvatar(
                radius: 10,
                backgroundColor: Colors.red[400],
                child: const Icon(Icons.person, color: Colors.white, size: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
