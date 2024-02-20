import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

final formatter = DateFormat.yMd();

String formatTime(double time) {
  final hour = time.toInt();
  final minute = ((time - hour) * 60).toInt();
  final period = hour < 12 ? 'AM' : 'PM';
  final formattedHour = hour % 12 == 0 ? 12 : hour % 12;
  final formattedMinute = minute.toString().padLeft(2, '0');
  return '$formattedHour:$formattedMinute $period';
}

String formatddMMyy(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}

String formatMMddYY(String dateStr) {
  final parts = dateStr.split('/');
  final day = parts[0];
  final month = parts[1];
  final year = parts[2];

  final monthNames = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  final formattedDate = '${monthNames[int.parse(month)]} $day, $year';
  return formattedDate;
}

class ReminderEvent {
  Timestamp endDate;
  String description;
  double hourStart;
  double hourEnd;
  bool isDone;

  ReminderEvent.full(
    this.endDate,
    this.description,
    this.hourStart,
    this.hourEnd,
    this.isDone,
  );

  ReminderEvent(
    this.endDate,
    this.description,
    this.hourStart,
    this.hourEnd,
  ) : isDone = false;
}

Map<String, List<ReminderEvent>> events = {
  '11/2/2024': sampleEvents,
};

List<ReminderEvent> sampleEvents = [];

Future<void> fetchEvents() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userId = user.uid;
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    final scheduleCollection = userDoc.reference.collection('schedule');
    final scheduleSnapshot = await scheduleCollection.get();

    events.clear();

    for (final doc in scheduleSnapshot.docs) {
      final data = doc.data();
      final endDate = data['endDate'] as Timestamp;
      final description = data['description'] as String;
      final hourStart = data['hourStart'] as double;
      final hourEnd = data['hourEnd'] as double;
      final isDone = data['isDone'] as bool;

      final event =
          ReminderEvent.full(endDate, description, hourStart, hourEnd, isDone);
      final dateStr = formatddMMyy(endDate.toDate());
      events[dateStr] ??= [];
      events[dateStr]!.add(event);
    }
  }
}

Future<void> addEvent(String uid, ReminderEvent event) async {
  final dateStr = formatddMMyy(event.endDate.toDate());
  events[dateStr] ??= [];
  events[dateStr]!.add(event);
  await updateSchedule();
}

Future<void> updateSchedule() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userId = user.uid;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    final scheduleCollection = userDoc.collection('schedule');

    final existingDocs = await scheduleCollection.get();
    for (final doc in existingDocs.docs) {
      await doc.reference.delete();
    }

    for (final entry in events.entries) {
      final eventList = entry.value;
      for (final event in eventList) {
        await scheduleCollection.add(
          {
            'endDate': event.endDate,
            'description': event.description,
            'hourStart': event.hourStart,
            'hourEnd': event.hourEnd,
            'isDone': event.isDone,
          },
        );
      }
    }
  }
}
