import 'dart:async';

import 'package:logit/body_part_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgService {
  SvgService._() {
    _init();
  }

  static final SvgService _instance = SvgService._();

  static SvgService get instance => _instance;

  final ValueNotifier<DrawableRoot?> _front = ValueNotifier(null);
  final ValueNotifier<DrawableRoot?> _left = ValueNotifier(null);
  final ValueNotifier<DrawableRoot?> _back = ValueNotifier(null);
  final ValueNotifier<DrawableRoot?> _right = ValueNotifier(null);

  ValueNotifier<DrawableRoot?> getSide(BodySide side) => side.map(
        front: _front,
        left: _left,
        back: _back,
        right: _right,
      );

  Future<void> _init() async {
    await Future.wait([
      for (final side in BodySide.values) _loadDrawable(side, getSide(side)),
    ]);
  }

  Future<void> _loadDrawable(
      BodySide side, ValueNotifier<Drawable?> notifier) async {
    final svgBytes = await rootBundle.load(
      side.map(
        front: "assets/body/m_front.svg",
        left: "assets/body/m_left.svg",
        back: "assets/body/m_back.svg",
        right: "assets/body/m_right.svg",
      ),
    );
    notifier.value =
        await svg.fromSvgBytes(svgBytes.buffer.asUint8List(), "svg");
  }
}