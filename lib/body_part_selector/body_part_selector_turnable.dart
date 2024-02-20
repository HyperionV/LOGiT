import 'package:logit/body_part_selector/body_part_selector.dart';
import 'package:logit/body_part_selector/model/body_parts.dart';
import 'package:logit/body_part_selector/model/body_side.dart';
import 'package:flutter/material.dart';
import 'package:rotation_stage/rotation_stage.dart';

export 'package:rotation_stage/rotation_stage.dart';

class BodyPartSelectorTurnable extends StatelessWidget {
  const BodyPartSelectorTurnable({
    super.key,
    required this.bodyParts,
    required this.getContent,
    this.onSelectionUpdated,
    this.mirrored = false,
    this.padding = EdgeInsets.zero,
    this.labelData,
  });

  final void Function(String) getContent;

  final BodyParts bodyParts;
  final Function(BodyParts)? onSelectionUpdated;
  final bool mirrored;
  final EdgeInsets padding;
  final RotationStageLabelData? labelData;

 

  @override
  Widget build(BuildContext context) {
    return RotationStage(
      contentBuilder: (index, side, page) => Padding(
        padding: padding,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: BodyPartSelector(
            side: side.map(
              front: BodySide.front,
              left: BodySide.left,
              back: BodySide.back,
              right: BodySide.right,
            ),
            collectContent: getContent,
            bodyParts: bodyParts,
            onSelectionUpdated: onSelectionUpdated,
            mirrored: mirrored,
          ),
        ),
      ),
      labels: labelData,
    );
  }
}
