// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:logit/model/notifications.dart';
import 'package:logit/model/event.dart';
import 'package:logit/widget/create_reminder.dart';
import 'package:logit/screen/home.dart';

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

  final NotificationModel notification;
  final VoidCallback updateFunction;

  static void _defaultUpdateFunction() {}

  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 24,
          backgroundColor: Color.fromARGB(255, 201, 201, 201),
        ),
        title: DisplayMessage(
            '${widget.notification.user.fullName}${message[widget.notification.type]}',
            widget.notification.user.fullName),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            '${formatTime(widget.notification.time.hour + widget.notification.time.minute / 60)}, ${formatter.format(widget.notification.time)}',
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
            ? Color.fromARGB(255, 214, 247, 216)
            : Color.fromARGB(255, 240, 240, 240),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        onTap: () {
          switch (widget.notification.type) {
            case 0:
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) =>
              //         ReminderScreen.openAt(widget.notification.time),
              //   ),
              // );
              print('open in connection');
              break;
            case 1:
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MainScreen.openReminderAt(
                    initialPage: 3,
                    selectedDate: widget.notification.time,
                  ),
                ),
              );
              break;
            case 2:
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (BuildContext context) {
                  return AddReminderModal(
                    widget.notification.time,
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
                    DateTime.now(),
                    widget.updateFunction,
                    ReminderEvent(
                      DateTime.now(),
                      'Appointment with ${widget.notification.user.fullName}',
                      0,
                      0,
                    ),
                  );
                },
              );

              break;
            case 4:
              print('open in health diary');
              break;
            case 5:
              print('open in health diary');
              break;
            case 6:
              print('open in health diary');
              break;
          }
          setState(() {
            widget.notification.isRead = true;
          });
        },
      ),
    );
  }
}
