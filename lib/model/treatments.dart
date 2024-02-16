class TreatmentData {
  String title;
  String doctorUid;
  String doctorName;
  String address;
  final DateTime startDate;
  DateTime endDate;

  TreatmentData(
    this.title,
    this.doctorUid,
    this.doctorName,
    this.address,
    this.startDate,
    this.endDate,
  );
}

List<TreatmentData> treatments = [
  TreatmentData(
      'Treatment 1', '1', 'Dr. A', 'Address 1', DateTime.now(), DateTime.now()),
  TreatmentData(
      'Treatment 2', '2', 'Dr. B', 'Address 2', DateTime.now(), DateTime.now()),
  TreatmentData(
      'Treatment 3', '3', 'Dr. C', 'Address 3', DateTime.now(), DateTime.now()),
  TreatmentData(
      'Treatment 4', '4', 'Dr. D', 'Address 4', DateTime.now(), DateTime.now()),
  TreatmentData(
      'Treatment 5', '5', 'Dr. E', 'Address 5', DateTime.now(), DateTime.now()),
  TreatmentData(
      'Treatment 6', '6', 'Dr. F', 'Address 6', DateTime.now(), DateTime.now()),
  TreatmentData(
      'Treatment 7', '7', 'Dr. G', 'Address 7', DateTime.now(), DateTime.now()),
  TreatmentData(
      'Treatment 8', '8', 'Dr. H', 'Address 8', DateTime.now(), DateTime.now()),
];
