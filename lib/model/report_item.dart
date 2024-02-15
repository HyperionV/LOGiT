class ReportItem {
  final String sender;
  final String receiver;
  final String content;
  final DateTime time;

  ReportItem(this.sender, this.receiver, this.content, this.time);
}

List<ReportItem> reports = [
  ReportItem('Dr. A', 'Patient 1', 'Patient 1 has a high blood pressure',
      DateTime.now()),
  ReportItem(
      'Dr. B', 'Patient 2', 'Patient 2 has a high blood sugar', DateTime.now()),
  ReportItem(
      'Dr. C', 'Patient 3', 'Patient 3 has a high cholesterol', DateTime.now()),
  ReportItem('Dr. D', 'Patient 4', 'Patient 4 has a high blood pressure',
      DateTime.now()),
  ReportItem(
      'Dr. E', 'Patient 5', 'Patient 5 has a high blood sugar', DateTime.now()),
  ReportItem(
      'Dr. F', 'Patient 6', 'Patient 6 has a high cholesterol', DateTime.now()),
  ReportItem('Dr. G', 'Patient 7', 'Patient 7 has a high blood pressure',
      DateTime.now()),
  ReportItem(
      'Dr. H', 'Patient 8', 'Patient 8 has a high blood sugar', DateTime.now()),
];
