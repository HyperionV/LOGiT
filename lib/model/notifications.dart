import 'package:logit/model/user.dart';

List<String> message = [
  ' sent you a message.',
  ' confirmed your appointment request.',
  ' requested you for an appointment.',
  ' offered an appointment.',
  ' created a new medical record.',
  ' sent you a connection request.',
  ' accepted your connection request.',
];

// type of notification
// 0 - message -> redirect to the connection panel
// 1 - confirmed appointment -> redirect to calendar at the date
// 2 - appointment request -> open create reminder with the given date and time
// 3 - appointment offered -> open create reminder
// 4 - new medical record -> open health diary, exclusively for doctor
// 5 - connection request -> open connection confirmation panel, exclusively for doctor
// 6 - connection accepted -> open connection panel, exclusively for doctor

class NotificationModel {
  final UserData user;
  final int type;
  bool isRead = false;
  final DateTime time;

  NotificationModel(this.user, this.type, this.time);
}
