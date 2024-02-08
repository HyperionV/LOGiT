// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

List<String> week = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

class DateButton extends StatelessWidget {
  const DateButton(this.date, this._selected, {super.key});
  final DateTime date;
  final bool _selected;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: _selected
            ? Color.fromARGB(255, 104, 197, 166)
            : Color.fromARGB(255, 240, 240, 240),
      ),
      child: SizedBox(
        width: 23,
        height: 80,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              date.day < 10 ? '0${date.day}' : date.day.toString(),
              style: TextStyle(
                color: _selected
                    ? Color.fromARGB(255, 250, 250, 250)
                    : Color.fromARGB(255, 80, 160, 133),
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              week[date.weekday - 1],
              style: TextStyle(
                  color: !_selected
                      ? Color.fromARGB(255, 105, 110, 116)
                      : const Color.fromARGB(255, 250, 250, 250),
                  fontSize: 11,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
