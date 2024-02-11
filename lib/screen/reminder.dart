// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:logit/widget/date_picker.dart';
import 'package:logit/widget/reminder_card.dart';
import 'package:logit/model/event.dart';
import 'package:logit/widget/create_reminder.dart';

class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  _ReminderScreenState createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  DateTime? selectedDate;

  @override
  void initState() {
    selectedDate = DateTime.now();
    super.initState();
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void _onLongPress() {
    setState(() {});
  }

  void _addNewReminder() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return AddReminderModal(selectedDate!, _onLongPress);
      },
    );
  }

  void _removeReminder(ReminderEvent reminder) {
    setState(() {
      events[formatDate(selectedDate!)]!.remove(reminder);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Reminder removed'),
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(
              () {
                events[formatDate(selectedDate!)]!.insert(0, reminder);
                // sortEvents();
              },
            );
          },
        ),
      ),
    );
  }

  void sortEvents() {
    final formattedDate = formatDate(selectedDate!);
    final eventList = events[formattedDate];

    if (eventList != null) {
      setState(() {
        eventList.sort((a, b) => a.hourStart.compareTo(b.hourStart));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 24.0, right: 24),
                child: Text(
                  'Reminder',
                  style: TextStyle(
                    fontSize: 32,
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
                onPressed: _addNewReminder,
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
          Expanded(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: Column(
                children: [
                  DatePicker(_onDateSelected),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: selectedDate != null &&
                                events[formatDate(selectedDate!)] != null
                            ? events[formatDate(selectedDate!)]!.map((event) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 8,
                                  ),
                                  child: ReminderCard(event, _onLongPress,
                                      () => _removeReminder(event)),
                                );
                              }).toList()
                            : [
                                const SizedBox(height: 8),
                                const Text('There is no event for this date.'),
                              ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
