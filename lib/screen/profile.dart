// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:logit/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logit/main.dart';

class InfoBox extends StatelessWidget {
  const InfoBox(
    this.txt,
    this.icon,
    this.editable, {
    super.key,
  });

  final String txt;
  final Icon icon;
  final bool editable;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 252, 252, 252),
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          children: [
            icon,
            SizedBox(width: 16.0),
            Expanded(
              child: Text(
                txt,
                style: TextStyle(fontSize: 16.0),
              ),
            ),
            if (editable)
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {},
              ),
            if (!editable)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.arrow_forward_ios, size: 24),
              ),
          ],
        ),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen(this.user, {super.key});

  final UserData user;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 240, 240, 240),
        centerTitle: true,
        title: const Text('Profile'),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 240, 240, 240),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                InfoBox(widget.user.fullName, Icon(Icons.person), true),
                InfoBox(widget.user.dob, Icon(Icons.cake), true),
                InfoBox(widget.user.phoneNumber, Icon(Icons.phone), true),
                InfoBox(widget.user.email, Icon(Icons.email), true),
                InfoBox(widget.user.address, Icon(Icons.home), true),
                InfoBox(widget.user.emergencyContact, Icon(Icons.phone_in_talk),
                    true),
                const Spacer(),
                InkWell(
                  onTap: () {},
                  child: InfoBox('Settings', Icon(Icons.settings), false),
                ),
                InkWell(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => App()));
                    },
                    child: InfoBox('Logout', Icon(Icons.logout), false)),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
