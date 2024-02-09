// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:logit/widget/date_button.dart';
import 'package:logit/widget/reminder_card.dart';
import 'package:logit/model/event.dart';

class DateRow extends StatefulWidget {
  const DateRow({Key? key}) : super(key: key);

  @override
  _DateRowState createState() => _DateRowState();
}

class _DateRowState extends State<DateRow> {
  final DateTime _currentDate = DateTime.now();
  DateTime _selectedDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(
            5,
            (index) {
              final date = _currentDate
                  .subtract(Duration(days: _currentDate.weekday - 3 - index));
              final isSelected = date.day == _selectedDate.day &&
                  date.month == _selectedDate.month &&
                  date.year == _selectedDate.year;

              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: DateButton(
                  date: date,
                  isSelected: isSelected,
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 30),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: List.generate(
                events.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 8,
                  ),
                  child: ReminderCard(events[index]),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
