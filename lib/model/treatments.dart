import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logit/model/user.dart';
import 'package:logit/model/medical_record.dart';

class TreatmentData {
  final String uid;
  String title;
  UserData doctor;
  final Timestamp startDate;
  Timestamp endDate;

  MedicalRecordData medicalRecord;

  TreatmentData(
    this.uid,
    this.title,
    this.doctor,
    this.startDate,
    this.endDate,
    this.medicalRecord,
  );
}

List<TreatmentData> treatments = [];

Future<void> fetchTreatmentData() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    treatments.clear();

    final userId = user.uid;
    final userDoc = FirebaseFirestore.instance.collection('users').doc(userId);

    final connectionsCollection = userDoc.collection('connections');
    final connectionsSnapshot = await connectionsCollection.get();

    for (final connectionDoc in connectionsSnapshot.docs) {
      final connectionId = connectionDoc.id;
      final treatmentCollection =
          connectionsCollection.doc(connectionId).collection('treatments');
      final treatmentSnapshot = await treatmentCollection.get();
      for (final treatmentDoc in treatmentSnapshot.docs) {
        final data = treatmentDoc.data();
        final uid = treatmentDoc.id;
        final title = data['title'] as String;
        final doctor = await fetchWithUID(connectionId);
        final startDate = data['startDate'] as Timestamp;
        final endDate = data['endDate'] as Timestamp;
        final medicalRecord = await fetchMedicalRecordData(treatmentDoc.id);
        final treatmentData = TreatmentData(
            uid, title, doctor, startDate, endDate, medicalRecord);
        treatments.add(treatmentData);
      }
    }
  }
}
