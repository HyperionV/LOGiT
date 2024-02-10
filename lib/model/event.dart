import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

String formatTime(double time) {
  final hour = time.toInt();
  final minute = ((time - hour) * 60).toInt();
  final period = hour < 12 ? 'AM' : 'PM';
  final formattedHour = hour % 12 == 0 ? 12 : hour % 12;
  final formattedMinute = minute.toString().padLeft(2, '0');
  return '$formattedHour:$formattedMinute $period';
}

class ReminderEvent {
  DateTime endDate;
  String description;
  double hourStart;
  double hourEnd;
  bool isDone;

  ReminderEvent(this.endDate, this.description, this.hourStart, this.hourEnd,
      this.isDone);
}

Map<String, List<ReminderEvent>> events = {
  '11/2/2024': sampleEvents,
};

List<ReminderEvent> sampleEvents = [
  ReminderEvent(DateTime.now(), 'Meeting with John', 10, 11, false),
  ReminderEvent(DateTime.now(), 'Lunch with Jane', 12, 13, false),
  ReminderEvent(DateTime.now(), 'Dinner with Joe', 18, 19, false),
  ReminderEvent(DateTime.now(), 'Meeting with John', 10, 11, false),
  ReminderEvent(DateTime.now(), 'Lunch with Jane', 12, 13, false),
  ReminderEvent(DateTime.now(), 'Dinner with Joe', 18, 19, false),
  ReminderEvent(DateTime.now(), 'Meeting with John', 10, 11, false),
  ReminderEvent(DateTime.now(), 'Lunch with Jane', 12, 13, false),
  ReminderEvent(DateTime.now(), 'Dinner with Joe', 18, 19, false),
];
