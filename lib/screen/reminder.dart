// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:logit/widget/date_row.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
              child: Text(
                'Reminder',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Spacer(),
            IconButton(
              icon: Icon(
                Icons.edit_calendar_rounded,
                size: 35,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.medical_information_rounded,
                size: 35,
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 16),
          ],
        ),
        SizedBox(
          height: 120,
          child: DateRow(),
        )
      ],
    );
  }
}
