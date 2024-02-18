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
  const ReportSymptomScreen({super.key});


  @override
  State<ReportSymptomScreen> createState() => _ReportSymptomScreen();
}

class _ReportSymptomScreen extends State<ReportSymptomScreen> {
  BodyParts _bodyParts = const BodyParts();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Symtom Report'),
      ),
      body: SafeArea(
        child: BodyPartSelectorTurnable(
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
