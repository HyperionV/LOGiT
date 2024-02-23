// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logit/model/notifications.dart';
import 'package:logit/model/event.dart';
import 'package:logit/widget/create_reminder.dart';
import 'package:logit/patient/home.dart';
import 'package:logit/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logit/doctor/screen/message.dart';
import 'package:logit/doctor/screen/home.dart';
import 'package:logit/patient/message.dart';

class DisplayMessage extends StatelessWidget {
  final String string;
  final String userName;

  const DisplayMessage(this.string, this.userName, {super.key});

  @override
  Widget build(BuildContext context) {
    final regex = RegExp(userName);
    const placeholder = '{@}';
    final target = regex.stringMatch(userName)!;
    final updatedString = string.replaceAll(regex, placeholder);
    final tokens = updatedString.split(RegExp(' '));
    final spans = tokens
        .map(
          (e) => e == placeholder
              ? TextSpan(
                  text: '$target ',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                )
              : TextSpan(
                  text: '$e ',
                  style: const TextStyle(fontSize: 14),
                ),
        )
        .toList();

    return Text.rich(
      TextSpan(children: spans),
    );
  }
}

class NotificationItem extends StatefulWidget {
  const NotificationItem(this.notification, {super.key})
      : updateFunction = _defaultUpdateFunction;

  const NotificationItem.withUpdateFunction(
      this.notification, this.updateFunction,
      {super.key});

  final NotificationData notification;
  final VoidCallback updateFunction;

  static void _defaultUpdateFunction() {}

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  late Future<UserData> _userDataFuture;
  // late TreatmentData? _treatmentDataFuture;

  // void initTreatmentData() async {
  //   if (widget.notification.treatmentAttached.isNotEmpty) {
  //     _treatmentDataFuture =
  //         await fetchTreatmentWithUid(widget.notification.treatmentAttached);
  //   } else {
  //     _treatmentDataFuture = null;
  //   }
  // }

  void initState() {
    _userDataFuture = fetchWithUID(widget.notification.sender);
    // initTreatmentData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserData>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          final sender = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: ListTile(
              leading: CircleAvatar(
                radius: 24,
                backgroundColor: Color.fromARGB(255, 201, 201, 201),
                backgroundImage: NetworkImage(sender.imageUrl),
              ),
              title: DisplayMessage(
                '${sender.fullName}${message[widget.notification.type]}',
                sender.fullName,
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${formatddMMyy(widget.notification.createTime.toDate())} at ${formatTime(widget.notification.createTime.toDate().hour + widget.notification.createTime.toDate().minute / 60)}',
                  style: TextStyle(
                    fontSize: 13,
                  ),
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16,
              ),
              tileColor: widget.notification.isRead
                  ? Color.fromARGB(255, 240, 240, 240)
                  : Color.fromARGB(255, 214, 247, 216),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              onTap: () async {
                switch (widget.notification.type) {
                  case 0:
                    final userSnapshot = await FirebaseFirestore.instance
                        .collection('users')
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .get();
                    final isDoctor = userSnapshot.data()?['isDoctor'] ?? false;
                    if (isDoctor) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessageScreenDoctor(
                            widget.notification.sender,
                            FirebaseAuth.instance.currentUser!.uid,
                          ),
                        ),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MessageScreen(
                            FirebaseAuth.instance.currentUser!.uid,
                            widget.notification.sender,
                          ),
                        ),
                      );
                    }
                    break;
                  case 1:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) {
                        ReminderEvent event = ReminderEvent(
                          widget.notification.timeAttached,
                          'Appointment with ${sender.fullName}',
                          widget.notification.timeAttached.toDate().hour * 1.0,
                          widget.notification.timeAttached.toDate().hour * 1.0,
                        );
                        if (!events.containsValue(event))
                          addEvent(
                              FirebaseAuth.instance.currentUser!.uid, event);
                        return MainScreen.openReminderAt(
                          initialPage: 3,
                          selectedDate:
                              widget.notification.timeAttached.toDate(),
                        );
                      }),
                    );
                    break;
                  case 2:
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return AddReminderModal(
                          widget.notification.createTime,
                          widget.updateFunction,
                        );
                      },
                    );

                    break;
                  case 3:
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return AddReminderModal.createWith(
                          Timestamp.now(),
                          widget.updateFunction,
                          ReminderEvent(
                            widget.notification.timeAttached,
                            'Appointment with ${sender.fullName}',
                            widget.notification.timeAttached.toDate().hour *
                                1.0,
                            widget.notification.timeAttached.toDate().minute /
                                60,
                          ),
                        );
                      },
                    );

                    break;
                  case 4:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreen.openAt(1),
                      ),
                    );
                    break;
                  case 5:
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainScreenDoctor.openAt(1),
                      ),
                    );
                    break;
                }

                setState(() async {
                  widget.notification.isRead = true;
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .collection('notifications')
                      .doc(widget.notification.uid)
                      .update({'isRead': true});
                });
              },
            ),
          );
        } else {
          return Text('No user data found');
        }
      },
    );
  }
}
