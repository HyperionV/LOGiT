import 'package:logit/model/diagnosis.dart';

class MedicalRecordItem {
  final String fullName;
  final String recordID;
  String diagnosis;
  String critical;
  String facility;
  List<DiagnosisItem> diagnosisList;

  MedicalRecordItem(
    this.fullName,
    this.recordID,
    this.diagnosis,
    this.critical,
    this.facility,
    this.diagnosisList,
  );
}

List<MedicalRecordItem> medicalRecords = [
  MedicalRecordItem(
    '1',
    '1',
    'Diagnosis 1',
    'Critical',
    'Facility 1',
    diagnosisList,
  ),
  MedicalRecordItem(
    '2',
    '2',
    'Diagnosis 2',
    'Critical',
    'Facility 2',
    diagnosisList,
  ),
  MedicalRecordItem(
    '3',
    '3',
    'Diagnosis 3',
    'Critical',
    'Facility 3',
    diagnosisList,
  ),
  MedicalRecordItem(
    '4',
    '4',
    'Diagnosis 4',
    'Critical',
    'Facility 4',
    diagnosisList,
  ),
  MedicalRecordItem(
    '5',
    '5',
    'Diagnosis 5',
    'Critical',
    'Facility 5',
    diagnosisList,
  ),
  MedicalRecordItem(
    '6',
    '6',
    'Diagnosis 6',
    'Critical',
    'Facility 6',
    diagnosisList,
  ),
  MedicalRecordItem(
    '7',
    '7',
    'Diagnosis 7',
    'Critical',
    'Facility 7',
    diagnosisList,
  ),
  MedicalRecordItem(
    '8',
    '8',
    'Diagnosis 8',
    'Critical',
    'Facility 8',
    diagnosisList,
  ),
];
