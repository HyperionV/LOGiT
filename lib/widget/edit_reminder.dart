// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:logit/model/event.dart';

class EditReminderModal extends StatefulWidget {
  final ReminderEvent reminder;
  final VoidCallback onLongPress;

  const EditReminderModal(this.reminder, this.onLongPress, {Key? key})
      : super(key: key);

  @override
  _EditReminderModalState createState() => _EditReminderModalState();
}

class _EditReminderModalState extends State<EditReminderModal> {
  late TextEditingController _titleController;
  late TimeOfDay _hourStart;
  late TimeOfDay _hourEnd;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.reminder.description);
    _hourStart = TimeOfDay(
        hour: widget.reminder.hourStart.floor(),
        minute:
            ((widget.reminder.hourStart - widget.reminder.hourStart.floor()) *
                    60)
                .floor());
    _hourEnd = TimeOfDay(
        hour: widget.reminder.hourEnd.floor(),
        minute:
            ((widget.reminder.hourEnd - widget.reminder.hourEnd.floor()) * 60)
                .floor());
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
                'Edit Reminder',
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
              // labelText: 'Title',
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
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.access_time),
                      const SizedBox(width: 8.0),
                      Text('From: ', style: TextStyle(fontSize: 16.0)),
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
                        child: Text(_hourEnd.format(context),
                            style: TextStyle(fontSize: 16.0)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16.0),
          // const SizedBox(height: 16.0),
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
                  widget.reminder.description = _titleController.text;
                  widget.reminder.hourStart =
                      _hourStart.hour + _hourStart.minute / 60.0;
                  widget.reminder.hourEnd =
                      _hourEnd.hour + _hourEnd.minute / 60.0;
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
