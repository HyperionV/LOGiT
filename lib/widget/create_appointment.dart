import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logit/model/event.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<DateTime?> showDatePickerDialog(BuildContext context) async {
  final currentDate = DateTime.now();
  final selectedDate = await showDatePicker(
    context: context,
    initialDate: currentDate,
    firstDate: currentDate,
    lastDate: DateTime(currentDate.year + 1),
  );

  return selectedDate;
}

void showDatePickDialog(BuildContext context, String doctorId) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return CreateAppointment(doctorId);
    },
  );
}

class CreateAppointment extends StatefulWidget {
  final String doctorId;
  const CreateAppointment(this.doctorId, {super.key});
  @override
  _CreateAppointmentState createState() => _CreateAppointmentState();
}

class _CreateAppointmentState extends State<CreateAppointment> {
  DateTime? selectedDate;
  bool booked = false;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
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
          selectedDate = DateTime(
            selectedDate!.year,
            selectedDate!.month,
            selectedDate!.day,
            picked.hour,
            picked.minute,
          );
        },
      );
    }
  }

  @override
  void initState() {
    selectedDate = DateTime.now();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
        child: Text(
          booked ? 'Appointment requested' : 'Book an appointment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      content: booked
          ? SizedBox(
              width: 450,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    color: Color.fromARGB(255, 106, 191, 151),
                    size: 75,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'You will be notified when the doctor confirm.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : SizedBox(
              width: 450,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(100, 217, 217, 217),
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.calendar_today),
                                const SizedBox(width: 8.0),
                                Text('Date:', style: TextStyle(fontSize: 16.0)),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => _selectDate(context),
                                  child: Text(
                                    formatter.format(selectedDate!),
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ],
                            ),
                            Row(
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
                                    formatTime(selectedDate!.hour +
                                        selectedDate!.minute / 60),
                                    style: TextStyle(fontSize: 16.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.doctorId)
                            .collection('notifications')
                            .add({
                          'type': 3,
                          'sender': FirebaseAuth.instance.currentUser!.uid,
                          'createTime': Timestamp.now(),
                          'timeAttached': Timestamp.fromDate(selectedDate!),
                          'isRead': false,
                        });

                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(widget.doctorId)
                            .collection('appointments')
                            .doc(FirebaseAuth.instance.currentUser!.uid)
                            .set({
                          'accepted': false,
                          'time': Timestamp.fromDate(selectedDate!),
                        });
                        setState(() {
                          booked = true;
                        });
                      },
                      child: Text('Book'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
