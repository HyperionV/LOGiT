import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logit/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

List<String> message = [
  ' sent you a message.',
  ' confirmed your appointment request.',
  ' requested you for an appointment.',
  ' offered an appointment.',
  ' accepted your connection request.',
  ' created a new medical record.',
  ' sent you a connection request.',
];

// type of notification
// 0 - message -> redirect to the connection panel
// 1 - confirmed appointment -> redirect to calendar at the date
// 2 - appointment request -> open create reminder with the given date and time
// 3 - appointment offered -> open create reminder
// 4 - connection accepted -> open connection panel
// 5 - new medical record -> open health diary, exclusively for doctor
// 6 - connection request -> open connection confirmation panel, exclusively for doctor

// filter theo medical tag

class NotificationData {
  final String sender;
  final int type;
  bool isRead;
  final Timestamp createTime;
  final Timestamp timeAttached;

  NotificationData(
      this.sender, this.type, this.createTime, this.timeAttached, this.isRead);
}

List<NotificationData> notifications = [];

Future<void> fetchNotifications() async {
  notifications.clear();
  print('fetching notifications');
  final notificationCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notifications');
  final NotificationSnapshot = await notificationCollection.get();
  for (final noti in NotificationSnapshot.docs) {
    if (noti.exists) {
      Map<String, dynamic> notiRecord = noti.data();
      print(noti.id);
      print(notiRecord);
      notifications.add(
        NotificationData(
          notiRecord['sender'] as String,
          notiRecord['type'] as int,
          notiRecord['createTime'] as Timestamp,
          notiRecord['timeAttached'] as Timestamp,
          notiRecord['isRead'] as bool,
        ),
      );
      print(notifications.length);
    }
  }
}
