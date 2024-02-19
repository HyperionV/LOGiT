// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:logit/model/user.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logit/doctor/widget/new_treatment.dart';

class QRCodeDialog extends StatefulWidget {
  final String qrCodeContent;
  final void Function() onAccept;

  const QRCodeDialog(this.qrCodeContent, this.onAccept, {super.key});

  @override
  _QRCodeDialogState createState() => _QRCodeDialogState();
}

class _QRCodeDialogState extends State<QRCodeDialog> {
  late UserData pendingUser;
  bool isLoading = true;
  void getData(String uid) async {
    pendingUser = await fetchWithUID(uid);
    setState(() {
      isLoading = false;
    });
  }

  void clearPendingCollection() async {
    CollectionReference pendingCollection = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('pending');

    QuerySnapshot querySnapshot = await pendingCollection.get();
    for (var doc in querySnapshot.docs) {
      doc.reference.delete();
    }
  }

  @override
  void initState() {
    clearPendingCollection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> pendingStream = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('pending')
        .snapshots();

    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: pendingStream,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  String receivedData = snapshot.data!.docs.first.id;
                  getData(receivedData);
                  if (isLoading) {
                    return CircularProgressIndicator();
                  } else {
                    return Column(
                      children: [
                        const SizedBox(height: 16.0),
                        Text(
                          'Pending request',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 219, 219, 219),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Full name:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      pendingUser.fullName,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Date of birth:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(pendingUser.dob)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Address:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(pendingUser.address)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Email:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(pendingUser.email)
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Phone number:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(pendingUser.phoneNumber)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Deny',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 90, 161, 126),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(FirebaseAuth.instance.currentUser!.uid)
                                    .collection('pending')
                                    .doc(receivedData)
                                    .set({'accepted': true});
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (context) {
                                    return CreateTreatmentModal(
                                      receivedData,
                                      widget.onAccept,
                                    );
                                  },
                                ).then((value) {
                                  Navigator.pop(context);
                                });
                              },
                              child: Text(
                                'Accept',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 90, 161, 126),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  }
                } else {
                  return Column(
                    children: [
                      const Text(
                        'Connect with patient',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      QrImageView(
                        data: widget.qrCodeContent,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              widget.qrCodeContent,
                              style: const TextStyle(fontSize: 16.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.content_copy),
                            onPressed: () {
                              Clipboard.setData(
                                ClipboardData(text: widget.qrCodeContent),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Copied to clipboard'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
