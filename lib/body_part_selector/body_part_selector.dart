import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logit/body_part_selector/model/body_parts.dart';
import 'package:logit/body_part_selector/model/body_side.dart';
import 'package:logit/body_part_selector/service/svg_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:touchable/touchable.dart';
//update
class BodyPartSelector extends StatelessWidget {
  const BodyPartSelector({
    super.key,
    required this.side,
    required this.bodyParts,
    required this.onSelectionUpdated,
    required this.collectContent,
    required this.getBodyPartSymptom,
    this.mirrored = false,
    this.selectedColor,
    this.unselectedColor,
    this.selectedOutlineColor,
    this.unselectedOutlineColor,
  });

  final BodySide side;
  final BodyParts bodyParts;
  final void Function(BodyParts bodyParts)? onSelectionUpdated;
  final String Function(String bodyPart) getBodyPartSymptom;  
  final bool mirrored;

  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedOutlineColor;
  final Color? unselectedOutlineColor;

  final void Function(String, String) collectContent;



  @override
  Widget build(BuildContext context) {
    final notifier = SvgService.instance.getSide(side);
    return ValueListenableBuilder<DrawableRoot?>(
        valueListenable: notifier,
        builder: (context, value, _) {
          if (value == null) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else {
            return _buildBody(context, value);
          }
        });
  }

  void getSymptomDescription(String bodyPart, BuildContext context) {
    final pickedBodyPart = bodyParts.toJson();
    if(pickedBodyPart.containsKey(bodyPart) && pickedBodyPart[bodyPart] == true){
      showDialog(context: context, builder: (context) {
        final TextEditingController controller  = TextEditingController();
        return AlertDialog(
          title: const Text('Symptom description', style: TextStyle(fontSize: 15)),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'Enter symptom description',
            ),
            controller: controller,
          ),
          actions: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 60),
                ElevatedButton(
                  onPressed: () {
                    collectContent(bodyPart, controller.text);
                    onSelectionUpdated?.call(
                    bodyParts.withToggledId(bodyPart, mirror: mirrored));
                    Navigator.of(context).pop();
                },
                  child: const Text('Done'),
                ),
              ],
            ),
          ],
        );
      });
    }
    else {
      showDialog(context: context, builder: (context) {
        late TextEditingController controller  = TextEditingController(text: getBodyPartSymptom(bodyPart));
        return AlertDialog(
          title: const Text('Symptom description', style: TextStyle(fontSize: 15)),
          content: TextField(
            decoration: const InputDecoration(
              hintText: 'Enter symptom description',
            ),
            controller: controller,
          ),
          actions: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    collectContent(bodyPart, controller.text);
                    Navigator.of(context).pop();
                  },
                  child: const Text('Modify'),
                ),
                const SizedBox(width: 60),
                ElevatedButton(
                  onPressed: () {
                    collectContent(bodyPart, '@REMOVED@');
                    onSelectionUpdated?.call(
                    bodyParts.withToggledId(bodyPart, mirror: mirrored));
                    Navigator.of(context).pop();
                  },
                  child: const Text('Remove'),
                ),
              ],
            ),
          ],
        );
      });
    }
  }

  Widget _buildBody(BuildContext context, DrawableRoot drawable) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedSwitcher(
      duration: kThemeAnimationDuration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeOutCubic,
      child: SizedBox.expand(
        key: ValueKey(bodyParts),
        child: CanvasTouchDetector(
          gesturesToOverride: const [GestureType.onTapDown],
          builder: (context) => CustomPaint(
            painter: _BodyPainter(
              root: drawable,
              bodyParts: bodyParts,
              onTap: (s) {
                getSymptomDescription(s, context);
              },
              context: context,
              selectedColor: selectedColor ?? colorScheme.inversePrimary,
              unselectedColor: unselectedColor ?? colorScheme.inverseSurface,
              selectedOutlineColor: selectedOutlineColor ?? colorScheme.primary,
              unselectedOutlineColor:
                  unselectedOutlineColor ?? colorScheme.onInverseSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _BodyPainter extends CustomPainter {
  _BodyPainter({
    required this.root,
    required this.bodyParts,
    required this.onTap,
    required this.context,
    required this.selectedColor,
    required this.unselectedColor,
    required this.unselectedOutlineColor,
    required this.selectedOutlineColor,
  });

  final DrawableRoot root;
  final BuildContext context;
  final void Function(String) onTap;
  final BodyParts bodyParts;
  final Color selectedColor;
  final Color unselectedColor;
  final Color unselectedOutlineColor;

  final Color selectedOutlineColor;

  bool isSelected(String key) {
    final selections = bodyParts.toJson();
    if (selections.containsKey(key) && selections[key]!) {
      return true;
    }
    return false;
  }

  void drawBodyParts({
    required TouchyCanvas touchyCanvas,
    required Canvas plainCanvas,
    required Size size,
    required Iterable<Drawable> drawables,
    required Matrix4 fittingMatrix,
  }) {
    for (final element in drawables) {
      final id = element.id;
      if (id == null) {
        debugPrint("Found a drawable element without an ID. Skipping $element");
        continue;
      }
      touchyCanvas.drawPath(
        (element as DrawableShape).path.transform(fittingMatrix.storage),
        Paint()
          ..color = isSelected(id) ? selectedColor : unselectedColor
          ..style = PaintingStyle.fill,
        onTapDown: (_) => onTap(id),
      );
      plainCanvas.drawPath(
        element.path.transform(fittingMatrix.storage),
        Paint()
          ..color =
              isSelected(id) ? selectedOutlineColor : unselectedOutlineColor
          ..strokeWidth = 2
          ..style = PaintingStyle.stroke,
      );
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (size != root.viewport.viewBoxRect.size) {
      final double scale = min(
        size.width / root.viewport.viewBoxRect.width,
        size.height / root.viewport.viewBoxRect.height,
      );
      final Size scaledHalfViewBoxSize =
          root.viewport.viewBoxRect.size * scale / 2.0;
      final Size halfDesiredSize = size / 2.0;
      final Offset shift = Offset(
        halfDesiredSize.width - scaledHalfViewBoxSize.width,
        halfDesiredSize.height - scaledHalfViewBoxSize.height,
      );

      final bodyPartsCanvas = TouchyCanvas(context, canvas);

      final Matrix4 fittingMatrix = Matrix4.identity()
        ..translate(shift.dx, shift.dy)
        ..scale(scale);

      final drawables =
          root.children.where((element) => element.hasDrawableContent);

      drawBodyParts(
        touchyCanvas: bodyPartsCanvas,
        plainCanvas: canvas,
        size: size,
        drawables: drawables,
        fittingMatrix: fittingMatrix,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
