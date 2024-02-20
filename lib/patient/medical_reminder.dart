// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';

class MedicalReminder extends StatefulWidget {
  const MedicalReminder({super.key});
  @override
  _MedicalReminderState createState() => _MedicalReminderState();
}

class _MedicalReminderState extends State<MedicalReminder> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Medical Reminder'),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              icon: Icon(Icons.upload),
              onPressed: () {},
              style: ButtonStyle(),
              label: Text('Upload'),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.camera_alt_outlined),
              onPressed: () {},
              label: Text('Scan'),
            ),
          ],
        ),
      ),
    );
  }
}
