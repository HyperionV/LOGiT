import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logit/widget/header.dart';
import 'package:logit/widget/notification.dart';
import 'package:logit/model/notifications.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Future<void> fetchNoti() async {
    notifications.clear();
    await fetchNotifications();
  }

  @override
  void initState() {
    fetchNoti();
    super.initState();
  }

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
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .collection('notifications')
              .orderBy('createTime', descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
              return Expanded(
                child: SingleChildScrollView(
                  child: SizedBox(
                    height: 650,
                    width: double.infinity,
                    child: ListView.builder(
                      shrinkWrap: true,
                      // physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (ctx, index) {
                        final notiRecord = snapshot.data!.docs[index];

                        return NotificationItem(
                          NotificationData(
                            notiRecord.id,
                            notiRecord['sender'] as String,
                            notiRecord['type'] as int,
                            notiRecord['createTime'] as Timestamp,
                            notiRecord['timeAttached'] as Timestamp,
                            // notiRecord['treatmentAttached'] as String,
                            notiRecord['isRead'] as bool,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            } else {
              return Expanded(
                child: Center(
                  child: Text(
                    'No notifications at the moment.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ],
    );
  }
}
