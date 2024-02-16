import 'package:logit/model/user.dart';

class MessageData {
  final UserData sender;
  final String body;
  final DateTime date;

  MessageData(this.sender, this.body, this.date);
}

List<MessageData> messages = [
  MessageData(
    users[0],
    'Hello, how are you?',
    DateTime.now(),
  ),
  MessageData(
    users[0],
    'Hi! Please let me know if you need any help',
    DateTime.now(),
  ),
];
