import 'package:cloud_firestore/cloud_firestore.dart';

class ReportData {
  final String content;
  final Timestamp time;

  ReportData(this.content, this.time);
}

Future<List<ReportData>> fetchReports(String medicalRecordUid) async {
  QuerySnapshot reportSnapshot = await FirebaseFirestore.instance
      .collection('medical_records')
      .doc(medicalRecordUid)
      .collection('Reports')
      .get();

  return reportSnapshot.docs.map((doc) {
    Map<String, dynamic> reportData = doc.data() as Map<String, dynamic>;
    return ReportData(
      reportData['content'],
      reportData['time'],
    );
  }).toList();
}

Future<void> updateReport(String medicalRecordUid, ReportData report) async {
  CollectionReference reportCollection = FirebaseFirestore.instance
      .collection('medical_records')
      .doc(medicalRecordUid)
      .collection('Reports');
  await reportCollection.add(
    {
      'content': report.content,
      'time': report.time,
    },
  );
}
