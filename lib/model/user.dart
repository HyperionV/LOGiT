import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  String imageUrl;
  String fullName;
  String dob;
  String phoneNumber;
  String email;
  String address;
  String emergencyContact;

  UserData(
    this.uid,
    this.imageUrl,
    this.fullName,
    this.dob,
    this.phoneNumber,
    this.email,
    this.address,
    this.emergencyContact,
  );

  UserData.fromMap(Map<String, dynamic> data)
      : uid = data['uid'],
        imageUrl = data['imageUrl'],
        fullName = data['fullName'],
        dob = data['dob'],
        phoneNumber = data['phoneNumber'],
        email = data['email'],
        address = data['address'],
        emergencyContact = data['emergencyContact'];
}

Future<UserData> fetchWithUID(String uid) async {
  final DocumentSnapshot snapshot =
      await FirebaseFirestore.instance.collection('users').doc(uid).get();

  if (snapshot.exists) {
    final data = snapshot.data() as Map<String, dynamic>;
    return UserData(
      uid,
      data['imageUrl'],
      data['fullName'],
      data['dob'],
      data['phoneNumber'],
      data['email'],
      data['address'],
      data['emergencyContact'],
    );
  } else {
    throw Exception('User data not found');
  }
}
