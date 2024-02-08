// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:logit/widget/date_button.dart';

class DateRow extends StatefulWidget {
  const DateRow({Key? key}) : super(key: key);

  @override
  _DateRowState createState() => _DateRowState();
}

class _DateRowState extends State<DateRow> {
  final DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
        5,
        (index) {
          final date = _currentDate
              .subtract(Duration(days: _currentDate.weekday - 1 - index));
          final isSelected = date.day == DateTime.now().day &&
              date.month == DateTime.now().month &&
              date.year == DateTime.now().year;

          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: DateButton(date, isSelected),
          );
        },
      ),
    );
  }
}
