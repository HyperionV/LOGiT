// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logit/widget/treatment_list.dart';
import 'package:logit/model/treatments.dart';

class HealthDiary extends StatefulWidget {
  const HealthDiary({super.key});

  @override
  _HealthDiaryState createState() => _HealthDiaryState();
}

class _HealthDiaryState extends State<HealthDiary> {
  bool isCurrent = true;
  List<Treatments> displaying = treatments;
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
      child: Column(
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
                        onPressed: () {},
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
                        Text(
                          'Good afternoon, have a great day!',
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    foregroundColor: Colors.black,
                                    backgroundColor:
                                        Color.fromARGB(255, 245, 245, 245),
                                    disabledForegroundColor:
                                        Colors.grey.withOpacity(0.38),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                      vertical: 4,
                                    ),
                                    child: Text(
                                      'SYMPTOMS REPORT',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                InkWell(
                                  child: Text(
                                    'Same as yesterday',
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
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
                              'Current Logs',
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
      ),
    );
  }
}
