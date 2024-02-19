// ignore_for_file: prefer_const_constructors

import 'package:logit/body_part_selector.dart';
import 'package:flutter/material.dart';

class ReportSymptomScreen extends StatefulWidget {
  final void Function(String) count;
  const ReportSymptomScreen(this.count, {super.key});

  @override
  State<ReportSymptomScreen> createState() => _ReportSymptomScreen();
}

class _ReportSymptomScreen extends State<ReportSymptomScreen> {
  BodyParts _bodyParts = const BodyParts();
  late TextEditingController controller;

  void collectContent(String bodyPart) {
    widget.count(bodyPart);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Body View'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                'Done',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: BodyPartSelectorTurnable(
          getContent: widget.count,
          bodyParts: _bodyParts,
          onSelectionUpdated: (p) => setState(() => _bodyParts = p),
          labelData: const RotationStageLabelData(
            front: 'Front',
            left: 'Left',
            right: 'Right',
            back: 'Back',
          ),
        ),
      ),
    );
  }
}
