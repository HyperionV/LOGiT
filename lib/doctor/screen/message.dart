// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:logit/model/message.dart';
import 'package:logit/doctor/widget/message.dart';
import 'package:logit/model/user.dart';

class NewMessage extends StatefulWidget {
  final String patientUid;
  final String doctorUid;
  final void Function() onSendMessage;
  const NewMessage(this.patientUid, this.doctorUid, this.onSendMessage,
      {super.key});

  @override
  State<NewMessage> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewMessage> {
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _submitMessage() async {
    final enteredMessage = _messageController.text;

    if (enteredMessage.trim().isEmpty) {
      return;
    }

    await sendNewMessage(
      widget.patientUid,
      widget.doctorUid,
      MessageData(
        await fetchWithUID(widget.doctorUid),
        _messageController.text,
        Timestamp.now(),
      ),
    );
    widget.onSendMessage();
    FocusScope.of(context).unfocus();

    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              textCapitalization: TextCapitalization.sentences,
              autocorrect: true,
              enableSuggestions: true,
              decoration: const InputDecoration(labelText: 'Send a message...'),
            ),
          ),
          IconButton(
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(
              Icons.send,
            ),
            onPressed: _submitMessage,
          ),
        ],
      ),
    );
  }
}

class MessageScreenDoctor extends StatefulWidget {
  final String patientUid;
  final String doctorUid;

  const MessageScreenDoctor(this.patientUid, this.doctorUid, {super.key});

  @override
  _MessageScreenDoctorState createState() => _MessageScreenDoctorState();
}

class _MessageScreenDoctorState extends State<MessageScreenDoctor> {
  late Future<List<MessageData>> _messageFuture;

  @override
  void initState() {
    _messageFuture = fetchMessages(widget.patientUid, widget.doctorUid);
    super.initState();
  }

  void _onSendMessage() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.patientUid)
        .collection('notifications')
        .add({
      'sender': widget.doctorUid,
      'type': 0,
      'createTime': Timestamp.now(),
      'timeAttached': Timestamp.now(),
      'isRead': false,
    });

    setState(() {
      _messageFuture = fetchMessages(widget.patientUid, widget.doctorUid);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: FutureBuilder<List<MessageData>>(
              future: _messageFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No messages found.'));
                } else {
                  List<MessageData> messages = snapshot.data!;
                  return ListView.builder(
                    itemCount: messages.length,
                    itemBuilder: (ctx, index) {
                      return MessageItem(messages[index]);
                    },
                  );
                }
              },
            ),
          ),
          NewMessage(widget.patientUid, widget.doctorUid, _onSendMessage),
        ],
      ),
    );
  }
}
