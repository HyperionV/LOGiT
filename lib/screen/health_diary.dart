// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';

class HealthDiary extends StatefulWidget {
  const HealthDiary({super.key});

  @override
  _HealthDiaryState createState() => _HealthDiaryState();
}

class _HealthDiaryState extends State<HealthDiary> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Health Diary',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                  icon: const Icon(
                    Icons.qr_code_scanner_rounded,
                    size: 40,
                  ),
                  onPressed: () {}),
            ],
          ),
        ),
      ],
    );
  }
}
