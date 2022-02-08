import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/rendering.dart' show EdgeInsets;
import 'package:meta/meta.dart';
import 'package:flame/input.dart';


class HudBackgroundLeft extends HudMarginComponent {

  late final PositionComponent backgroundLeft;

  HudBackgroundLeft({
    required this.backgroundLeft,
    EdgeInsets? margin,
    Vector2? position,
    double? size,
    double? knobRadius,
    Anchor anchor = Anchor.center,
  })  :
        super(
        margin: margin,
        position: position,
        size: backgroundLeft.size,
        anchor: anchor,
      );

  @override
  @mustCallSuper
  void onMount() {
    backgroundLeft.position.sub(Vector2(10, -10));
    add(backgroundLeft);
  }

  @override
  void update(double dt) {
  }
}

class HudBackgroundBottom extends HudMarginComponent {

  late final PositionComponent backgroundBottom;

  HudBackgroundBottom({
    required this.backgroundBottom,
    EdgeInsets? margin,
    Vector2? position,
    double? size,
    double? knobRadius,
    Anchor anchor = Anchor.center,
  })  :
        super(
        margin: margin,
        position: position,
        size: backgroundBottom.size,
        anchor: anchor,
      );

  @override
  @mustCallSuper
  void onMount() {
    backgroundBottom.position.sub(Vector2(10, -10));
    add(backgroundBottom);
  }

  @override
  void update(double dt) {
  }
}