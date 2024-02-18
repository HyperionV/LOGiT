import 'package:flutter/material.dart';

class NewSymptom extends StatefulWidget {
  const NewSymptom({super.key, required this.bodyPart});

  @override
  final String bodyPart;
  _NewSymptomState createState() => _NewSymptomState();
}

class _NewSymptomState extends State<NewSymptom> {
  @override
  final _symptomDes = TextEditingController();

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 48, 16, 16),
      child: Row (
        children: [
          const Text('Detail Description'),
          Expanded(
            child: TextField(
              controller: _symptomDes,
              decoration: const InputDecoration(
                hintText: 'Enter symptom description',
              ),
            ),
          ),
          Column(
            children: [
              ElevatedButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          )
        ],
      )
    );
  }
}
