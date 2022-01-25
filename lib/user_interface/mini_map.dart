import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/rendering.dart' show EdgeInsets;
import 'package:meta/meta.dart';
import 'package:flame/input.dart';


class MiniMapComponent extends HudMarginComponent {
  late final PositionComponent focussedArea;
  late final PositionComponent totalArea;

  double startX = -1;
  double startY = -1;

  int rotate;

  Vector2 normalizedPosition = Vector2.zero();

  MiniMapComponent({
    required this.focussedArea,
    required this.totalArea,
    required this.rotate,
    EdgeInsets? margin,
    Vector2? position,
    double? size,
    double? knobRadius,
    Anchor anchor = Anchor.center,
  })  :
        super(
        margin: margin,
        position: position,
        size: totalArea.size,
        anchor: anchor,
      ) {
    // We will assume, for now, that the mini map is always on the top left.
    startX = margin!.left;
    startY = margin.top;
  }

  rotate3() {
    focussedArea.angle = pi/2;
    totalArea.angle = pi/2;
    focussedArea.position = Vector2(width, 0);
    focussedArea.size = Vector2(focussedArea.size.y, focussedArea.size.x);
    totalArea.position = Vector2(width, 0);
    totalArea.size = Vector2(totalArea.size.y, totalArea.size.x);
  }

  rotate0() {
    focussedArea.angle = 0;
    totalArea.angle = 0;
    focussedArea.position = Vector2(-180, 0);
    focussedArea.size = Vector2(focussedArea.size.y, focussedArea.size.x);
    totalArea.position = Vector2(0, 0);
    totalArea.size = Vector2(totalArea.size.y, totalArea.size.x);
  }

  rotate1() {
    focussedArea.angle = pi + pi/2;
    totalArea.angle = pi + pi/2;
    focussedArea.position = Vector2(0, 90);
    focussedArea.size = Vector2(focussedArea.size.y, focussedArea.size.x);
    totalArea.position = Vector2(0, 90);
    totalArea.size = Vector2(totalArea.size.y, totalArea.size.x);
  }

  rotate2() {
    focussedArea.angle = pi;
    totalArea.angle = pi;
    focussedArea.position = Vector2(180, 90);
    focussedArea.size = Vector2(focussedArea.size.y, focussedArea.size.x);
    totalArea.position = Vector2(180, 90);
    totalArea.size = Vector2(totalArea.size.y, totalArea.size.x);
  }

  void rotateMiniMapLeft() {
    if (rotate == 0) {
      rotate = 3;
      rotate3();
    } else if (rotate == 1) {
      rotate = 0;
      rotate0();
    } else if (rotate == 2) {
      rotate = 1;
      rotate1();
    } else {
      rotate = 2;
      rotate2();
    }
  }

  void rotateMiniMapRight() {
    if (rotate == 0) {
      rotate = 1;
      rotate1();
    } else if (rotate == 1) {
      rotate = 2;
      rotate2();
    } else if (rotate == 2) {
      rotate = 3;
      rotate3();
    } else {
      rotate = 0;
      rotate0();
    }
  }

  @override
  @mustCallSuper
  void onMount() {
    focussedArea.anchor = Anchor.center;
    focussedArea.position = size/2;

    add(totalArea);
    add(focussedArea);
  }

  void updateCameraPosX(double normalizedX) {
    normalizedPosition.x = normalizedX;
  }

  void updateCameraPosY(double normalizedY) {
    normalizedPosition.y = normalizedY;
  }

  void updateZoom(double screenWidth, double worldWidth) {
    double percentage = screenWidth / worldWidth;
    focussedArea.scale = Vector2(percentage, percentage);
  }

  @override
  void update(double dt) {
    double xMap = normalizedPosition.x * (width/2) + (width/2);
    double yMap = normalizedPosition.y * (height/2) + (height/2);
    setFocussedAreaPosition(xMap, yMap);
  }

  Vector2 tappedMap(double posX, double posY) {
    double xMap = posX - startX;
    double yMap = posY - startY;
    double xMove = xMap - (width/2);
    double yMove = yMap - (height/2);
    return Vector2(xMove/(width/2), yMove/(height/2));
  }

  setFocussedAreaPosition(double xMap, double yMap) {
    if (xMap > width) {
      xMap = width;
    } else if (xMap < 0) {
      xMap = 0;
    }
    if (yMap > height) {
      yMap = height;
    } else if (yMap < 0) {
      yMap = 0;
    }
    focussedArea.position = Vector2(xMap, yMap);
  }
}
