// ignore_for_file: library_private_types_in_public_api, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:logit/widget/treatment_card.dart';
import 'package:logit/model/treatments.dart';

class TreatmentList extends StatefulWidget {
  const TreatmentList(this.treatmentList, {super.key});

  final List<Treatments> treatmentList;

  @override
  _TreatmentListState createState() => _TreatmentListState();
}

class _TreatmentListState extends State<TreatmentList> {
  void _onLongPress() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (widget.treatmentList.isEmpty) {
      return const Center(
        child: Text('No recorded treatments.',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)),
      );
    }
    return ListView.builder(
      itemCount: widget.treatmentList.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: TreatmentCard(
            widget.treatmentList[index],
            _onLongPress,
          ),
        );
      },
    );
  }
}
