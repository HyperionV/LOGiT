import 'package:logit/model/diagnosis.dart';

class MedicalRecordData {
  final String fullName;
  final String recordID;
  String diagnosis;
  String critical;
  String facility;
  List<DiagnosisData> diagnosisList;

  MedicalRecordData(
    this.fullName,
    this.recordID,
    this.diagnosis,
    this.critical,
    this.facility,
    this.diagnosisList,
  );
}

List<MedicalRecordData> medicalRecords = [
  MedicalRecordData(
    '1',
    '1',
    'Diagnosis 1',
    'Critical',
    'Facility 1',
    diagnosisList,
  ),
  MedicalRecordData(
    '2',
    '2',
    'Diagnosis 2',
    'Critical',
    'Facility 2',
    diagnosisList,
  ),
  MedicalRecordData(
    '3',
    '3',
    'Diagnosis 3',
    'Critical',
    'Facility 3',
    diagnosisList,
  ),
  MedicalRecordData(
    '4',
    '4',
    'Diagnosis 4',
    'Critical',
    'Facility 4',
    diagnosisList,
  ),
  MedicalRecordData(
    '5',
    '5',
    'Diagnosis 5',
    'Critical',
    'Facility 5',
    diagnosisList,
  ),
  MedicalRecordData(
    '6',
    '6',
    'Diagnosis 6',
    'Critical',
    'Facility 6',
    diagnosisList,
  ),
  MedicalRecordData(
    '7',
    '7',
    'Diagnosis 7',
    'Critical',
    'Facility 7',
    diagnosisList,
  ),
  MedicalRecordData(
    '8',
    '8',
    'Diagnosis 8',
    'Critical',
    'Facility 8',
    diagnosisList,
  ),
];
