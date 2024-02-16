class DiagnosisData {
  String diagnosis;
  String content;
  final DateTime time;

  DiagnosisData(this.diagnosis, this.content, this.time);
}

List<DiagnosisData> diagnosisList = [
  DiagnosisData('Diagnosis 1', 'Content 1', DateTime.now()),
  DiagnosisData('Diagnosis 2', 'Content 2', DateTime.now()),
  DiagnosisData('Diagnosis 3', 'Content 3', DateTime.now()),
  DiagnosisData('Diagnosis 4', 'Content 4', DateTime.now()),
  DiagnosisData('Diagnosis 5', 'Content 5', DateTime.now()),
  DiagnosisData('Diagnosis 6', 'Content 6', DateTime.now()),
  DiagnosisData('Diagnosis 7', 'Content 7', DateTime.now()),
  DiagnosisData('Diagnosis 8', 'Content 8', DateTime.now()),
];
