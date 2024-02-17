// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:logit/screen/profile.dart';
import 'package:logit/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScreenHeader extends StatelessWidget {
  final String title;
  const ScreenHeader(this.title, {super.key});

  @override
  Widget build(context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.account_circle_rounded,
              size: 45,
            ),
            onPressed: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                final userDataSnapshot = await FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .get();
                if (userDataSnapshot.exists) {
                  final userData = userDataSnapshot.data();
                  final currentUser = UserData(
                    user.uid,
                    userData!['imageUrl'],
                    userData['fullName'],
                    userData['dob'],
                    userData['phoneNumber'],
                    userData['email'],
                    userData['address'],
                    userData['emergencyContact'],
                  );
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfileScreen(currentUser);
                  }));
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
