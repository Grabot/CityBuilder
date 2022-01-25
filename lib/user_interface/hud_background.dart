import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/rendering.dart' show EdgeInsets;
import 'package:meta/meta.dart';
import 'package:flame/input.dart';


class HudBackground extends HudMarginComponent {

  late final PositionComponent background;

  HudBackground({
    required this.background,
    EdgeInsets? margin,
    Vector2? position,
    double? size,
    double? knobRadius,
    Anchor anchor = Anchor.center,
  })  :
        super(
        margin: margin,
        position: position,
        size: background.size,
        anchor: anchor,
      );

  @override
  @mustCallSuper
  void onMount() {
    background.anchor = Anchor.center;
    background.position = Vector2(0, 0);

    add(background);
  }

  @override
  void update(double dt) {
  }
}