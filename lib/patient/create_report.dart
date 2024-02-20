// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logit/model/event.dart';
import 'package:logit/screen/new_symptom.dart';

class CreateReport extends StatefulWidget {
  final String medicalRecordID;
  final String doctorId;
  final void Function() updateSuper;
  const CreateReport(this.medicalRecordID, this.doctorId, this.updateSuper,
      {super.key});

  @override
  _CreateReportState createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  late TextEditingController _contentController;
  late DateTime _endDate;

  Map<String, int> partCounter = {};

  void count(String bodyPart) {
    partCounter[bodyPart] = (partCounter[bodyPart] ?? 0) + 1;
    if (partCounter[bodyPart]! % 2 == 0) {
      partCounter.remove(bodyPart);
    }
  }

  @override
  void initState() {
    _contentController = TextEditingController(text: '');
    _endDate = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
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

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: 0, minute: 0),
    );
    if (picked != null) {
      setState(
        () {
          _endDate = DateTime(
            _endDate.year,
            _endDate.month,
            _endDate.day,
            picked.hour,
            picked.minute,
          );
        },
      );
    }
  }

  Future<void> onSave() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.doctorId)
        .collection('notifications')
        .add(
      {
        'type': 5,
        'createTime': Timestamp.now(),
        'sender': FirebaseAuth.instance.currentUser!.uid,
        'timeAttached': Timestamp.now(),
        'isRead': false,
      },
    );

    await FirebaseFirestore.instance
        .collection('medical_records')
        .doc(widget.medicalRecordID)
        .collection('Reports')
        .add(
      {
        'content': _contentController.text,
        'time': Timestamp.fromDate(_endDate),
      },
    );
  }

  Future<void> onSaveAndPop() async {
    await onSave();
    widget.updateSuper();
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
                'Create symptom report',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32.0),
          SizedBox(
            height: 150,
            child: TextField(
              expands: true,
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'Enter symptom description',
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
              minLines: null,
              maxLines: null,
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(100, 217, 217, 217),
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today),
                      const SizedBox(width: 8.0),
                      Text('Created date:', style: TextStyle(fontSize: 16.0)),
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
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.access_time),
                      const SizedBox(width: 8.0),
                      Text(
                        'At: ',
                        style: TextStyle(fontSize: 16.0),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _selectTime(context),
                        child: Text(
                          formatTime(_endDate.hour + _endDate.minute / 60),
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ReportSymptomScreen(count),
                ),
              );

              setState(() {
                _contentController.text += partCounter.keys.join('\n');
              });
            },
            child: Text('Full body view'),
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
                  onSaveAndPop();
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
