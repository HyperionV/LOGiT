// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logit/model/event.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateTreatmentModal extends StatefulWidget {
  final String patientID;
  final VoidCallback updateSuper;
  const CreateTreatmentModal(this.patientID, this.updateSuper, {super.key});

  @override
  _CreateTreatmentModalState createState() => _CreateTreatmentModalState();
}

class _CreateTreatmentModalState extends State<CreateTreatmentModal> {
  late TextEditingController _titleController;
  late TextEditingController _diagnosisController;
  late TextEditingController _criticalController;
  late TextEditingController _recordIDController;
  late TextEditingController _facilityController;
  late DateTime _endDate;

  @override
  void initState() {
    _titleController = TextEditingController(text: '');
    _diagnosisController = TextEditingController(text: '');
    _criticalController = TextEditingController(text: '');
    _recordIDController = TextEditingController(text: '');
    _facilityController = TextEditingController(text: '');
    _endDate = DateTime.now();
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _diagnosisController.dispose();
    _criticalController.dispose();
    _recordIDController.dispose();
    _facilityController.dispose();
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
    final docRef =
        await FirebaseFirestore.instance.collection('medical_records').add(
      {
        'title': _titleController.text,
        'diagnosis': _diagnosisController.text,
        'critical': _criticalController.text,
        'recordID': _recordIDController.text,
        'facility': _facilityController.text,
        'patientId': widget.patientID,
        'endDate': Timestamp.fromDate(_endDate),
        'startDate': Timestamp.now(),
        'doctorId': FirebaseAuth.instance.currentUser!.uid,
      },
    );

    final newRecordUid = docRef.id;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('connections')
        .doc(widget.patientID)
        .set({});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('connections')
        .doc(widget.patientID)
        .collection('treatments')
        .doc(newRecordUid)
        .set({});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.patientID)
        .collection('connections')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.patientID)
        .collection('connections')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('treatments')
        .doc(newRecordUid)
        .set({});

    final patientConnectionsDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.patientID)
        .collection('connections')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    if (!patientConnectionsDoc.data()!.containsKey('conversations')) {
      final convRef =
          await FirebaseFirestore.instance.collection('conversations').add({
        'receiver': widget.patientID,
        'sender': FirebaseAuth.instance.currentUser!.uid,
      });
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.patientID)
          .collection('connections')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('treatments')
          .doc(newRecordUid)
          .set({'conversation': convRef.id});
    }
  }

  Future<void> onSaveAndPop() async {
    widget.updateSuper();
    await onSave();
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
                'Create Treatment',
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
              hintText: 'Enter a title for this treatment',
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
          const SizedBox(height: 16.0),
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
          TextField(
            controller: _criticalController,
            decoration: InputDecoration(
              hintText: 'Enter critical symptoms',
              prefixIcon: const Icon(Icons.notification_important_rounded),
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
          TextField(
            controller: _recordIDController,
            decoration: InputDecoration(
              hintText: 'Enter local record ID',
              prefixIcon: const Icon(Icons.library_books_rounded),
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
          TextField(
            controller: _facilityController,
            decoration: InputDecoration(
              hintText: 'Enter examination facility',
              prefixIcon: const Icon(Icons.location_city_outlined),
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
