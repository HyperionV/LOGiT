import 'package:flutter/material.dart';
import 'package:logit/model/message.dart';
import 'package:logit/widget/message.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (ctx, index) {
          return MessageItem(messages[index]);
        },
      ),
    );
  }
}
