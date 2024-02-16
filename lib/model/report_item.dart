class ReportData {
  final String sender;
  final String receiver;
  final String content;
  final DateTime time;

  ReportData(this.sender, this.receiver, this.content, this.time);
}

List<ReportData> reports = [
  ReportData('Dr. A', 'Patient 1', 'Patient 1 has a high blood pressure',
      DateTime.now()),
  ReportData(
      'Dr. B', 'Patient 2', 'Patient 2 has a high blood sugar', DateTime.now()),
  ReportData(
      'Dr. C', 'Patient 3', 'Patient 3 has a high cholesterol', DateTime.now()),
  ReportData('Dr. D', 'Patient 4', 'Patient 4 has a high blood pressure',
      DateTime.now()),
  ReportData(
      'Dr. E', 'Patient 5', 'Patient 5 has a high blood sugar', DateTime.now()),
  ReportData(
      'Dr. F', 'Patient 6', 'Patient 6 has a high cholesterol', DateTime.now()),
  ReportData('Dr. G', 'Patient 7', 'Patient 7 has a high blood pressure',
      DateTime.now()),
  ReportData(
      'Dr. H', 'Patient 8', 'Patient 8 has a high blood sugar', DateTime.now()),
];
