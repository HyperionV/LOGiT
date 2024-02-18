// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:logit/model/user.dart';
import 'package:logit/widget/report_card.dart';
import 'package:logit/screen/medical_record.dart';
import 'package:logit/model/medical_record.dart';
import 'package:logit/screen/message.dart';
import 'package:firebase_auth/firebase_auth.dart';

class _CustomFloatingActionButtonLocation extends FloatingActionButtonLocation {
  final double offsetX;
  final double offsetY;

  const _CustomFloatingActionButtonLocation({
    required this.offsetX,
    required this.offsetY,
  });

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry scaffoldGeometry) {
    final double fabX = scaffoldGeometry.scaffoldSize.width - offsetX;
    final double fabY = scaffoldGeometry.scaffoldSize.height - offsetY;
    return Offset(fabX, fabY);
  }
}

class _CustomFloatingActionButtonAnimator extends FloatingActionButtonAnimator {
  @override
  Offset getOffset(
      {required Offset begin, required Offset end, required double progress}) {
    return Offset.lerp(begin, end, progress)!;
  }

  @override
  Animation<double> getRotationAnimation({required Animation<double> parent}) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(parent);
  }

  @override
  Animation<double> getScaleAnimation({required Animation<double> parent}) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(parent);
  }
}

class SymptomReport extends StatefulWidget {
  final String doctorID;
  final MedicalRecordData medicalRecord;
  const SymptomReport(this.doctorID, this.medicalRecord, {super.key});

  @override
  _SymptomReportState createState() => _SymptomReportState();
}

class _SymptomReportState extends State<SymptomReport> {
  final Color iconColor = Color.fromARGB(255, 15, 145, 133);
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchWithUID(widget.doctorID),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final UserData user = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: Padding(
                padding: const EdgeInsets.only(left: 55),
                child: Text(
                  'Symptom Report',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              leading: IconButton(
                icon: Icon(Icons.close, size: 30, color: iconColor),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageScreen(FirebaseAuth.instance.currentUser!.uid, widget.doctorID),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.notifications_none,
                    size: 35,
                    color: iconColor,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MedicalRecord(widget.medicalRecord),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.info_outline_rounded,
                    size: 35,
                    color: iconColor,
                  ),
                ),
                const SizedBox(width: 12)
              ],
            ),
            body: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                  ),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: Row(
                          children: [
                            ClipOval(
                              child: Image.network(
                                user.imageUrl,
                                width: 76,
                                height: 76,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.fullName,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  user.address,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color.fromARGB(255, 125, 125, 125),
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Email: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Color.fromARGB(255, 125, 125, 125),
                                      ),
                                    ),
                                    Text(
                                      user.email,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Color.fromARGB(255, 125, 125, 125),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'Phone: ',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color:
                                            Color.fromARGB(255, 125, 125, 125),
                                      ),
                                    ),
                                    Text(
                                      user.phoneNumber,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color:
                                            Color.fromARGB(255, 125, 125, 125),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.calendar_month,
                                size: 30,
                                color: iconColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 242, 242, 242),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(95, 87, 191, 156)),
                                    borderRadius: BorderRadius.circular(4),
                                    color: Colors.white,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: DropdownButton<String>(
                                    // value: selectedFilter,
                                    icon: Icon(
                                      Icons.keyboard_arrow_down,
                                      color: iconColor,
                                      size: 30,
                                    ),
                                    iconSize: 24,
                                    elevation: 16,
                                    hint: Text('Choose a filter'),
                                    style: TextStyle(color: Colors.black),
                                    underline: SizedBox(),
                                    isExpanded: true,
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedFilter = newValue ?? '';
                                      });
                                    },
                                    items: <String>[
                                      'All',
                                      'Option 1',
                                      'Option 2',
                                      'Option 3'
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                height: 48,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Color.fromARGB(95, 87, 191, 156)),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: TextButton.icon(
                                  icon: Icon(
                                    Icons.filter_list_outlined,
                                    color: iconColor,
                                  ),
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        Color.fromARGB(255, 255, 255, 255),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  label: Text(
                                    'Filter',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: ListView.builder(
                            itemCount: widget.medicalRecord.reports.length,
                            itemBuilder: (ctx, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 18, vertical: 8),
                                child: ReportCard(
                                    widget.medicalRecord.reports[index]),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // const SizedBox(height: 20),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {},
              backgroundColor: Color.fromARGB(255, 70, 188, 149),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.add,
                color: Colors.white,
                size: 50,
              ),
            ),
            floatingActionButtonLocation: _CustomFloatingActionButtonLocation(
              offsetX: 100,
              offsetY: 100,
            ),
            floatingActionButtonAnimator: _CustomFloatingActionButtonAnimator(),
          );
        }
      },
    );
  }
}
