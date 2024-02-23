// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logit/model/message.dart';

class MessageItem extends StatelessWidget {
  const MessageItem(this.message, {Key? key}) : super(key: key);

  final MessageData message;

  @override
  Widget build(BuildContext context) {
    final formattedDateTime =
        DateFormat('hh:mm a, dd/MM/yyyy').format(message.createAt.toDate());

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            child: Text(
              formattedDateTime,
              style: TextStyle(fontSize: 12),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 210, 209, 209),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SizedBox(
                  width: 290,
                  child: Text(
                    message.body,
                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(message.sender.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
