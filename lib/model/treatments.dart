import 'package:logit/model/user.dart';

class TreatmentData {
  
  final String uid;
  String title;
  UserData doctor;
  String address;
  final DateTime startDate;
  DateTime endDate;

  TreatmentData(
    this.uid,
    this.title,
    this.doctor,
    this.address,
    this.startDate,
    this.endDate,
  );
}

List<TreatmentData> treatments = [];
