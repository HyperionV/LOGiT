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

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      json['uid'],
      json['imageUrl'],
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
    'https://imageio.forbes.com/specials-images/imageserve/645a7e33044f4b35a044914e/Freddie-Highmore-as--The-Good-Doctor---Dr--Sean-Murphy-/960x0.jpg?format=jpg&width=1440',
    'John Doe',
    '01/01/1970',
    '1234567890',
    'john@john.vir',
    '123 Main St, Anytown, USA',
    '0987654321',
  )
];
