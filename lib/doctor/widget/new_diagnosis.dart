// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logit/model/event.dart';

class CreateDiagnosis extends StatefulWidget {
  final String medicalRecordID;
  final void Function() updateSuper;
  const CreateDiagnosis(this.medicalRecordID, this.updateSuper, {super.key});

  @override
  _CreateDiagnosisState createState() => _CreateDiagnosisState();
}

class _CreateDiagnosisState extends State<CreateDiagnosis> {
  late TextEditingController _contentController;
  late TextEditingController _diagnosisController;
  late DateTime _endDate;

  @override
  void initState() {
    _contentController = TextEditingController(text: '');
    _diagnosisController = TextEditingController(text: '');
    _endDate = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _diagnosisController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: DateTime(2001),
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
        .collection('medical_records')
        .doc(widget.medicalRecordID)
        .collection('Diagnosis')
        .add(
      {
        'diagnosis': _diagnosisController.text,
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
                'Create Diagnosis',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32.0),
          TextField(
            controller: _diagnosisController,
            decoration: InputDecoration(
              hintText: 'Enter diagnosis',
              prefixIcon: const Icon(Icons.edit_document),
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
          const SizedBox(height: 16.0),
          SizedBox(
            height: 150,
            child: TextField(
              expands: true,
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'Enter content of the diagnosis',
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
                      Text('Re-examination:', style: TextStyle(fontSize: 16.0)),
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
