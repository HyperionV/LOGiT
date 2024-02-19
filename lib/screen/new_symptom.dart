// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:logit/body_part_selector.dart';
import 'package:flutter/material.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Body Part Selector',
//       theme: ThemeData(
//         useMaterial3: true,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
//       ),
//       home: ReportSymptomScreen(title: 'Body Part Selector\n' + DateTime.now().toString()),
//     );
//   }
// }

class ReportSymptomScreen extends StatefulWidget {
  final void Function(String) count;
  ReportSymptomScreen(this.count, {super.key});

  @override
  State<ReportSymptomScreen> createState() => _ReportSymptomScreen();
}

class _ReportSymptomScreen extends State<ReportSymptomScreen> {
  BodyParts _bodyParts = const BodyParts();
  late TextEditingController controller;

  void collectContent(String bodyPart) {
    widget.count(bodyPart);
  }

  // final Map<String, String> _symptoms = {};

  // Future openAddDialog() => showDialog(
  //   context: context,
  //   builder: (context) => AlertDialog(
  //     title: Text('Detail description'),
  //     content: TextField(
  //       decoration: const InputDecoration(
  //         hintText: 'Enter symptom description',
  //       ),
  //       controller: controller,
  //     ),
  //     actions: [
  //       Column(
  //         mainAxisSize: MainAxisSize.min,
  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //         children: [
  //           ElevatedButton(
  //             onPressed: () => Navigator.of(context).pop(),
  //             child: const Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: add,
  //             child: const Text('Add'),
  //           ),
  //         ],
  //       ),
  //     ],
  //   ),
  // );

  // void add() {
  //   Navigator.of(context).pop();
  // }

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
