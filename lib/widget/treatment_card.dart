// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:logit/model/treatments.dart';
import 'package:logit/screen/symptom_report.dart';

class TreatmentCard extends StatefulWidget {
  const TreatmentCard(this.treatment, this.onLongPress, {super.key});

  final Treatments treatment;
  final VoidCallback onLongPress;

  @override
  _TreatmentCardState createState() => _TreatmentCardState();
}

class _TreatmentCardState extends State<TreatmentCard> {
  String get _date {
    final DateTime date = widget.treatment.startDate;
    final String end = (widget.treatment.endDate.year != DateTime.now().year &&
            widget.treatment.endDate.month != DateTime.now().month &&
            widget.treatment.endDate.day != DateTime.now().day)
        ? ' - ${widget.treatment.endDate.day}/${widget.treatment.endDate.month}/${widget.treatment.endDate.year}'
        : 'Ongoing';
    return '${date.day}/${date.month}/${date.year} - $end';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: InkWell(
        onLongPress: widget.onLongPress,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SymptomReport(widget.treatment.doctorUid),
            ),
          );
        },
        child: Card(
          elevation: 4,
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                SizedBox(
                  height: double.infinity,
                  width: 125,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/img/doctor.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.treatment.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // const SizedBox(height: 5),
                    Text(
                      widget.treatment.doctorName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      widget.treatment.address,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      'Last re-examination: ',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color.fromARGB(255, 54, 169, 125),
                      ),
                    ),
                    Text(
                      _date,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
