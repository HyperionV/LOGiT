// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:logit/model/treatments.dart';
import 'package:logit/model/user.dart';
import 'package:logit/widget/report_card.dart';
import 'package:logit/doctor/screen/medical_record.dart';
import 'package:logit/doctor/screen/message.dart';

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

class SymptomReportDoctor extends StatefulWidget {
  final TreatmentData treatment;
  const SymptomReportDoctor(this.treatment, {super.key});

  @override
  _SymptomReportDoctorState createState() => _SymptomReportDoctorState();
}

class _SymptomReportDoctorState extends State<SymptomReportDoctor> {
  final Color iconColor = Color.fromARGB(255, 15, 145, 133);
  String selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: fetchWithUID(widget.treatment.doctor.uid),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
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
                        builder: (context) =>
                            MedicalRecord(widget.treatment.medicalRecord),
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
                        widget.treatment.medicalRecord.reports.isEmpty
                            ? Center(
                                child: Text(
                                  'No reports available',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : Expanded(
                                child: ListView.builder(
                                  itemCount: widget
                                      .treatment.medicalRecord.reports.length,
                                  itemBuilder: (ctx, index) {
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 18, vertical: 8),
                                      child: ReportCard(widget.treatment
                                          .medicalRecord.reports[index]),
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
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessageScreenDoctor(
                        widget.treatment.patient.uid,
                        widget.treatment.doctor.uid),
                  ),
                );
              },
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
