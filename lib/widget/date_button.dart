// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

List<String> week = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

class DateButton extends StatelessWidget {
  final DateTime date;
  final bool isSelected;
  final VoidCallback onTap;

  const DateButton(
      {required this.date,
      required this.isSelected,
      required this.onTap,
      super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: isSelected
            ? Color.fromARGB(255, 104, 197, 166)
            : Color.fromARGB(255, 240, 240, 240),
      ),
      child: SizedBox(
        width: 23,
        height: 90,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              date.day < 10 ? '0${date.day}' : date.day.toString(),
              style: TextStyle(
                color: isSelected
                    ? Color.fromARGB(255, 250, 250, 250)
                    : Color.fromARGB(255, 80, 160, 133),
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              week[date.weekday - 1],
              style: TextStyle(
                color: !isSelected
                    ? Color.fromARGB(255, 105, 110, 116)
                    : Color.fromARGB(255, 250, 250, 250),
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
