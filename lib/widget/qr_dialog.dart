// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class QRCodeDialog extends StatefulWidget {
  const QRCodeDialog({super.key});

  @override
  _QRCodeDialogState createState() => _QRCodeDialogState();
}

class _QRCodeDialogState extends State<QRCodeDialog> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanning = true;
  late TextEditingController _codeController;
  bool isWaitingForConfirmation = false;

  @override
  void dispose() {
    _codeController.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _codeController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: isWaitingForConfirmation
          ? null
          : Center(
              child: Text(
                'Scan QR or Enter Code',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
      content: isWaitingForConfirmation
          ? StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(_codeController.text)
                  .collection('pending')
                  .doc(FirebaseAuth.instance.currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                print(_codeController.text);
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  bool accepted = snapshot.data?.get('accepted') ?? false;
                  if (accepted) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        Icon(
                          Icons.check_circle,
                          color: Color.fromARGB(255, 106, 191, 151),
                          size: 75,
                        ),
                        const SizedBox(height: 10),
                        Text('Connection request accepted.'),
                      ],
                    );
                  } else {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        CircularProgressIndicator(),
                        const SizedBox(height: 10),
                        Text('Waiting for confirmation...'),
                      ],
                    );
                  }
                }
              },
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 14),
                Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: const Color.fromARGB(255, 186, 186, 186),
                      width: 2.0,
                    ),
                  ),
                  child: QRView(
                    key: qrKey,
                    onQRViewCreated: _onQRViewCreated,
                  ),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    labelText: 'Enter Code',
                  ),
                  enabled: !isScanning,
                ),
              ],
            ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Cancel'),
        ),
        if (!isWaitingForConfirmation)
          TextButton(
            onPressed: () async {
              if (isScanning) {
                controller?.pauseCamera();
                setState(() {
                  isScanning = false;
                });
              } else {
                String uid = _codeController.text;

                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(uid)
                    .collection('pending')
                    .doc(FirebaseAuth.instance.currentUser!.uid)
                    .set(
                  {
                    'accepted': false,
                  },
                );
                await Future.delayed(const Duration(milliseconds: 200));
                setState(() {
                  isWaitingForConfirmation = true;
                });
              }
            },
            child: Text(isScanning ? 'Stop Scanning' : 'Submit'),
          ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      String uid = scanData.code!;
      setState(() {
        _codeController.text = uid;
        isScanning = false;
        isWaitingForConfirmation = true;
      });
    });
  }
}
