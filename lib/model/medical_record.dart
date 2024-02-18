import 'package:logit/model/diagnosis.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logit/model/user.dart';
import 'package:logit/model/report_item.dart';

class MedicalRecordData {
  final String fullName;
  final String recordID;
  String diagnosis;
  String critical;
  String facility;
  List<DiagnosisData> diagnosisList;
  List<ReportData> reports;

  MedicalRecordData(
    this.fullName,
    this.recordID,
    this.diagnosis,
    this.critical,
    this.facility,
    this.diagnosisList,
    this.reports,
  );
}

Future<MedicalRecordData> fetchMedicalRecordData(String medicalRecordId) async {
  DocumentSnapshot medicalRecordSnapshot = await FirebaseFirestore.instance
      .collection('medical_records')
      .doc(medicalRecordId)
      .get();

  if (medicalRecordSnapshot.exists) {
    Map<String, dynamic> medicalRecordData =
        medicalRecordSnapshot.data() as Map<String, dynamic>;

    List<DiagnosisData> diagnosisList = await fetchDiagnosis(medicalRecordId);

    List<ReportData> reportList = await fetchReports(medicalRecordId);

    final fullName = await fetchWithUID(FirebaseAuth.instance.currentUser!.uid);

    return MedicalRecordData(
        fullName.fullName,
        medicalRecordData['recordID'],
        medicalRecordData['diagnosis'],
        medicalRecordData['critical'],
        medicalRecordData['facility'],
        diagnosisList,
        reportList);
  } else {
    throw Exception('Medical record not found');
  }
}
