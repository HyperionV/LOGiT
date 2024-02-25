// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logit/model/event.dart';
import 'package:logit/model/medical_record.dart';
import 'package:logit/screen/new_symptom.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CreateReport extends StatefulWidget {
  final MedicalRecordData medicalRecord;
  final String medicalRecordID;
  final String doctorId;
  final void Function() updateSuper;
  const CreateReport(
      this.medicalRecord, this.medicalRecordID, this.doctorId, this.updateSuper,
      {super.key});
  @override
  _CreateReportState createState() => _CreateReportState();
}

class _CreateReportState extends State<CreateReport> {
  late TextEditingController _contentController;
  late DateTime _endDate;

  Map<String, String> symptomNote = {};

  String getBodyPartSymptom(String bodyPart) {
    return symptomNote[bodyPart] ?? '';
  }

  void updateSymptom(String bodyPart, String content) {
    symptomNote[bodyPart] = content;
    if (symptomNote[bodyPart] == '@REMOVED@') {
      symptomNote.remove(bodyPart);
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

    if (_contentController.text
        .toLowerCase()
        .contains(widget.medicalRecord.critical.toLowerCase())) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.doctorId)
          .collection('notifications')
          .add(
        {
          'type': 6,
          'createTime': Timestamp.now(),
          'sender': FirebaseAuth.instance.currentUser!.uid,
          'timeAttached': Timestamp.now(),
          'isRead': false,
        },
      );
    }

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


  String bodyPartFormat(String input, bool isVNmese) {
    if(isVNmese) {
      final Map<String, String> bodyPartsVN = {
          'head': 'Đầu',
          'neck': 'Cổ',
          'leftShoulder': 'Vai trái',
          'leftUpperArm': 'Cánh tay trái',
          'leftElbow': 'Khuỷu tay trái',
          'leftLowerArm': 'Cẳng tay trái',
          'leftHand': 'Bàn tay trái',
          'rightShoulder': 'Vai phải',
          'rightUpperArm': 'Cánh tay phải',
          'rightElbow': 'Khuỷu tay phải',
          'rightLowerArm': 'Cẳng tay phải',
          'rightHand': 'Bàn tay phải',
          'upperBody': 'Thân trên',
          'lowerBody': 'Thân dưới',
          'leftUpperLeg': 'Đùi trái',
          'leftKnee': 'Đầu gối trái',
          'leftLowerLeg': 'Cẳng chân trái',
          'leftFoot': 'Bàn chân trái',
          'rightUpperLeg': 'Đùi phải',
          'rightKnee': 'Đầu gối phải',
          'rightLowerLeg': 'Cẳng chân phải',
          'rightFoot': 'Bàn chân phải',
          'abdomen': 'Bụng',
          'vestibular': 'Hệ thống tiền đình',
        };

      return bodyPartsVN[input]!;
    }
    else {
      String result = '';

      result += input[0].toUpperCase();

      for (int i = 1; i < input.length; i++) {
        if (input[i].toUpperCase() == input[i]) {
          result += ' ${input[i]}';
        } else {
          result += input[i];
        }
      }

      return result;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> symptoms = widget.medicalRecord.critical.split(',');

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
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Critical symptoms:',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 8.0),
                  SingleChildScrollView(
                    child: Row(
                      children: List.generate(
                        symptoms.length,
                        (index) => SizedBox(
                          height: 44,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    Color.fromARGB(255, 240, 240, 240),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: Text(
                                symptoms[index],
                                style: TextStyle(
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w400),
                              ),
                              onPressed: () {
                                _contentController.text +=
                                    symptoms[index] + '\n';
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 25.0),
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
                  builder: (context) => ReportSymptomScreen(
                      widget.medicalRecord, updateSymptom, getBodyPartSymptom),
                ),
              );

              setState(() {
                for (String key in symptomNote.keys) {
                  _contentController.text +=
                      bodyPartFormat(key, false) + ' : ' + symptomNote[key]! + '\n';
                }
                symptomNote.clear();
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
