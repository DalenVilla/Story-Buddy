import 'package:flutter/material.dart';

class WoodsIllustration extends StatelessWidget {
  const WoodsIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Icon(
        Icons.forest,
        size: 60,
        color: Color(0xFF228B22),
      ),
    );
  }
}
