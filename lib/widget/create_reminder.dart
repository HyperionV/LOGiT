

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logit/model/event.dart';

class AddReminderModal extends StatefulWidget {
  final Timestamp date;
  final VoidCallback onLongPress;
  final ReminderEvent reminder;

  AddReminderModal(this.date, this.onLongPress, {super.key})
      : reminder = ReminderEvent(date, '', 0, 0);

  const AddReminderModal.createWith(this.date, this.onLongPress, this.reminder,
      {super.key});

  @override
  _AddReminderModalState createState() => _AddReminderModalState();
}

class _AddReminderModalState extends State<AddReminderModal> {
  late TextEditingController _titleController;
  late TimeOfDay _hourStart;
  late TimeOfDay _hourEnd;
  late DateTime _endDate;

  @override
  void initState() {
    _titleController = TextEditingController(text: widget.reminder.description);
    _hourStart = TimeOfDay(
        hour: widget.reminder.hourStart.floor(),
        minute: ((widget.reminder.hourStart % 1) * 60).floor());
    _hourEnd = TimeOfDay(
        hour: widget.reminder.hourEnd.floor(),
        minute: ((widget.reminder.hourEnd % 1) * 60).floor());
    _endDate = widget.reminder.endDate.toDate();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _hourStart : _hourEnd,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _hourStart = picked;
        } else {
          _hourEnd = picked;
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: [
              const Text(
                'Create Reminder',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32.0),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'Enter a title',
              prefixIcon: const Icon(Icons.title),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(
                  color: Theme.of(context).primaryColor,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
            autocorrect: false,
            textCapitalization: TextCapitalization.none,
          ),
          const SizedBox(height: 32.0),
          SizedBox(
            height: 100,
            width: double.infinity,
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today),
                      const SizedBox(width: 8.0),
                      Text('End Date:', style: TextStyle(fontSize: 16.0)),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _selectDate(context),
                        child: Text(
                          formatter.format(_endDate),
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.access_time),
                      const SizedBox(width: 8.0),
                      Text(
                        'From: ',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _selectTime(context, true),
                        child: Text(
                          _hourStart.format(context),
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Row(
                    children: [
                      Icon(Icons.access_time),
                      const SizedBox(width: 8.0),
                      Text('To:', style: TextStyle(fontSize: 16.0)),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _selectTime(context, false),
                        child: Text(
                          _hourEnd.format(context),
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              const SizedBox(width: 8.0),
              ElevatedButton(
                onPressed: () {
                  if (!events.containsKey(formatddMMyy(_endDate))) {
                    events[formatddMMyy(_endDate)] = [];
                  }
                  events[formatddMMyy(_endDate)]!.add(
                    ReminderEvent(
                      Timestamp.fromDate(_endDate),
                      _titleController.text,
                      _hourStart.hour + _hourStart.minute / 60.0,
                      _hourEnd.hour + _hourEnd.minute / 60.0,
                    ),
                  );
                  updateSchedule();
                  widget.onLongPress();
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
