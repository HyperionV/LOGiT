// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logit/doctor/widget/treatment_list.dart';
import 'package:logit/model/treatments.dart';
import 'package:logit/doctor/widget/qr_dialog.dart';

class HealthDiary extends StatefulWidget {
  const HealthDiary({super.key});

  @override
  _HealthDiaryState createState() => _HealthDiaryState();
}

class _HealthDiaryState extends State<HealthDiary> {
  bool isCurrent = true;
  List<TreatmentData> displaying = treatments;

  @override
  void initState() {
    super.initState();
  }

  Future<void> initTreatments() async {
    treatments.clear();
    await fetchTreatmentData();
  }

  void _resetScreen() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final Color containerColor = Color.fromARGB(255, 106, 204, 171);
    final Color textColor1 = Color.fromARGB(255, 15, 145, 133);

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: containerColor,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: containerColor,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: FutureBuilder(
        future: initTreatments(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          return Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: containerColor,
                ),
                padding: const EdgeInsets.only(left: 24, top: 16, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Health Diary',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 24),
                          child: IconButton(
                            icon: const Icon(
                              Icons.qr_code_scanner_rounded,
                              size: 32,
                              color: Color.fromARGB(255, 244, 244, 244),
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return QRCodeDialog(
                                      FirebaseAuth.instance.currentUser!.uid,
                                      _resetScreen);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 250,
                              child: Text(
                                'Good afternoon, have a great working day!',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 75, 75, 75),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                          ],
                        ),
                        const Spacer(),
                        Image.asset('assets/img/image12.png'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: InkWell(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            key: ValueKey<bool>(isCurrent),
                            decoration: BoxDecoration(
                              color: isCurrent
                                  ? const Color.fromARGB(255, 240, 240, 240)
                                  : Colors.transparent,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 13),
                                Text(
                                  'Current Treatments',
                                  style: TextStyle(
                                      color: textColor1,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                if (isCurrent)
                                  Container(
                                    height: 3,
                                    width: 175,
                                    color: containerColor,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          if (!isCurrent) {
                            isCurrent = !isCurrent;

                            setState(() {
                              displaying = treatments;
                            });
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: Container(
                            key: ValueKey<bool>(!isCurrent),
                            decoration: BoxDecoration(
                              color: !isCurrent
                                  ? const Color.fromARGB(255, 240, 240, 240)
                                  : Colors.transparent,
                            ),
                            child: Column(
                              children: [
                                const SizedBox(height: 13),
                                Text(
                                  'Past Treatments',
                                  style: TextStyle(
                                      color: textColor1,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                if (!isCurrent)
                                  Container(
                                    height: 3,
                                    width: 175,
                                    color: containerColor,
                                  ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          if (isCurrent) {
                            isCurrent = !isCurrent;
                            setState(() {
                              displaying = [];
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 239, 239, 239)),
                    child: TreatmentList(displaying)),
              ),
            ],
          );
        },
      ),
    );
  }
}
