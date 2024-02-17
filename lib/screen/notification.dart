// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logit/model/user.dart';
import 'package:logit/widget/header.dart';
import 'package:logit/widget/notification.dart';
import 'package:logit/model/notifications.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ScreenHeader('Notification'),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.grey,
              width: 1,
            ),
          ),
          child: const Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(Icons.search),
              ),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search for sender, message, etc.',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
        // Expanded(
        //   child: ListView.builder(
        //     itemCount: 5,
        //     itemBuilder: (ctx, index) {
        //       return NotificationItem(NotificationData(
        //         users[0],
        //         3,
        //         Timestamp.now(),
        //         Timestamp.now(),
        //       ));
        //     },
        //   ),
        // ),
      ],
    );
  }
}
