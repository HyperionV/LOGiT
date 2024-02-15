// ignore_for_file: library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class CurrentLogs extends StatefulWidget {
  const CurrentLogs({super.key});

  @override
  _CurrentLogsState createState() => _CurrentLogsState();
}

class _CurrentLogsState extends State<CurrentLogs> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(children: [Image.asset('assets/images/doctor.png')]),
    );
  }
}
