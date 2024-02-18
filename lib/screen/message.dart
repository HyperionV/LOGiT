import 'package:flutter/material.dart';
import 'package:logit/model/message.dart';
import 'package:logit/widget/message.dart';

class MessageScreen extends StatelessWidget {
  final String userUid;
  final String otherUserUid;

  const MessageScreen(
    this.userUid,
    this.otherUserUid, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: FutureBuilder<List<MessageData>>(
        future: fetchMessages(userUid, otherUserUid),
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
    );
  }
}
