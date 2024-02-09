// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:logit/model/event.dart';

class ReminderCard extends StatefulWidget {
  const ReminderCard(this.event, {Key? key}) : super(key: key);

  final ReminderEvent event;

  @override
  _ReminderCardState createState() => _ReminderCardState();
}

class _ReminderCardState extends State<ReminderCard> {
  bool isChecked = false;
  final Color _cardColor = const Color.fromARGB(255, 172, 237, 174);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isChecked = !isChecked;
        });
      },
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              isChecked
                  ? _cardColor.withOpacity(0.7)
                  : const Color.fromARGB(255, 194, 194, 194).withOpacity(0.7),
              isChecked
                  ? _cardColor.withOpacity(0.1)
                  : const Color.fromARGB(255, 194, 194, 194).withOpacity(0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 8),
              if (!isChecked)
                Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.fromBorderSide(
                      BorderSide(
                        color: Color.fromARGB(255, 169, 169, 169),
                        width: 1,
                      ),
                    ),
                  ),
                ),
              if (isChecked)
                Container(
                  width: 25,
                  height: 25,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color.fromARGB(255, 101, 206, 105)),
                  child: const Icon(Icons.check, color: Colors.white, size: 18),
                ),
              const SizedBox(width: 24),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.event.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${formatTime(widget.event.hourStart)} - ${formatTime(widget.event.hourEnd)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
