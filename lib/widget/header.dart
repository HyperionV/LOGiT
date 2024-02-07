import 'package:flutter/material.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  const ScreenHeader(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.account_circle_rounded,
              size: 45,
            ),
            onPressed: () {
              // Handle button press
            },
          ),
        ],
      ),
    );
  }
}
