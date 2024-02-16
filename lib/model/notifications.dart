import 'package:logit/model/user.dart';

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
  final UserData user;
  final int type;
  bool isRead = false;
  final DateTime time;

  NotificationData(this.user, this.type, this.time);
}
