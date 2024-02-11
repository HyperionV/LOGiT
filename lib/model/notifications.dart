import 'package:logit/model/user.dart';

List<String> message = [
  ' sent you a message.',
  ' confirmed your appointment request.',
  ' sent you a connection request.',
  ' accepted your connection request.',
  ' requested you for an appointment.',
  ' offered an appointment.',
  ' created a new medical record.',
  ' '
];

class NotificationModel {
  final UserData user;
  final int type;
  bool isRead = false;
  final DateTime time;

  NotificationModel(this.user, this.type, this.time);
}
