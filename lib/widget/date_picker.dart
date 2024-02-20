// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:logit/widget/date_button.dart';
// import 'package:logit/widget/reminder_card.dart';
// import 'package:logit/model/event.dart';
import 'package:table_calendar/table_calendar.dart';

class DatePicker extends StatefulWidget {
  final void Function(DateTime) onDateSelected;

  const DatePicker(this.onDateSelected, {super.key});

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  late Widget current;

  @override
  void initState() {
    current = DateRow(widget.onDateSelected);
    super.initState();
  }

  String textToDisplay = 'View full calendar';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        current,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Spacer(),
            TextButton(
              child: Text(textToDisplay),
              onPressed: () {
                setState(
                  () {
                    if (current is FullCalendar) {
                      current = DateRow(widget.onDateSelected);
                      textToDisplay = 'View full calendar';
                    } else {
                      current = FullCalendar(widget.onDateSelected);
                      textToDisplay = 'View recent dates';
                    }
                      widget.onDateSelected(DateTime.now());
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}

class DateRow extends StatefulWidget {
  final void Function(DateTime) onDateSelected;
  const DateRow(this.onDateSelected, {super.key});

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
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
              5,
              (index) {
                final date = _currentDate.subtract(Duration(days: 2 - index));
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
                      widget.onDateSelected(date);
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class FullCalendar extends StatefulWidget {
  final Function(DateTime) onDateSelected;

  const FullCalendar(this.onDateSelected, {super.key});
  @override
  _FullCalendarState createState() => _FullCalendarState();
}

class _FullCalendarState extends State<FullCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDate = DateTime.now();
  DateTime _focusedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      calendarFormat: _calendarFormat,
      focusedDay: _focusedDate,
      firstDay: DateTime(2000),
      lastDay: DateTime(2100),
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDate, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDate = selectedDay;
          _focusedDate = focusedDay;
        });
        widget.onDateSelected(selectedDay);
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
    );
  }
}
