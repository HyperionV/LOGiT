class UserData {
  final String uid;
  String fullName;
  String dob;
  String phoneNumber;
  String email;
  String address;
  String emergencyContact;

  UserData(
    this.uid,
    this.fullName,
    this.dob,
    this.phoneNumber,
    this.email,
    this.address,
    this.emergencyContact,
  );

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      json['uid'],
      json['fullName'],
      json['dob'],
      json['phoneNumber'],
      json['email'],
      json['address'],
      json['emergencyContact'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'fullName': fullName,
      'dob': dob,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
      'emergencyContact': emergencyContact,
    };
  }
}

List<UserData> users = [
  UserData(
    '1',
    'John Doe',
    '01/01/1970',
    '1234567890',
    'john@john.vir',
    '123 Main St, Anytown, USA',
    '0987654321',
  )
];
