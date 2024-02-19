import 'package:cloud_firestore/cloud_firestore.dart';

class DiagnosisData {
  String diagnosis;
  String content;
  final Timestamp time;

  DiagnosisData(this.diagnosis, this.content, this.time);

  Map<String, dynamic> toMap() {
    return {
      'diagnosis': diagnosis,
      'content': content,
      'time': time,
    };
  }
}

Future<List<DiagnosisData>> fetchDiagnosis(String medicalRecordUid) async {
  QuerySnapshot diagnosisSnapshot = await FirebaseFirestore.instance
      .collection('medical_records')
      .doc(medicalRecordUid)
      .collection('Diagnosis')
      .get();

  if (diagnosisSnapshot.docs.isEmpty) {
    return []; // Return an empty list if the collection doesn't exist
  }

  return diagnosisSnapshot.docs.map((doc) {
    Map<String, dynamic> reportData = doc.data() as Map<String, dynamic>;
    return DiagnosisData(
      reportData['diagnosis'],
      reportData['content'],
      reportData['time'],
    );
  }).toList();
}

Future<void> updateDiagnosis(
    String medicalRecordUid, DiagnosisData diagnosis) async {
  CollectionReference diagnosisCollection = FirebaseFirestore.instance
      .collection('medical_records')
      .doc(medicalRecordUid)
      .collection('Diagnosis');
  await diagnosisCollection.add(diagnosis.toMap());
}
