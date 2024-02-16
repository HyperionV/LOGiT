class DiagnosisItem {
  String diagnosis;
  String content;
  final DateTime time;

  DiagnosisItem(this.diagnosis, this.content, this.time);
}

List<DiagnosisItem> diagnosisList = [
  DiagnosisItem('Diagnosis 1', 'Content 1', DateTime.now()),
  DiagnosisItem('Diagnosis 2', 'Content 2', DateTime.now()),
  DiagnosisItem('Diagnosis 3', 'Content 3', DateTime.now()),
  DiagnosisItem('Diagnosis 4', 'Content 4', DateTime.now()),
  DiagnosisItem('Diagnosis 5', 'Content 5', DateTime.now()),
  DiagnosisItem('Diagnosis 6', 'Content 6', DateTime.now()),
  DiagnosisItem('Diagnosis 7', 'Content 7', DateTime.now()),
  DiagnosisItem('Diagnosis 8', 'Content 8', DateTime.now()),
];
