import 'package:flame/components.dart';
import 'package:flutter/rendering.dart' show EdgeInsets;
import 'package:meta/meta.dart';
import 'package:flame/input.dart';


class MiniMapComponent extends HudMarginComponent {
  late final PositionComponent focussedArea;
  late final PositionComponent totalArea;

  double startX = -1;
  double startY = -1;

  Vector2 normalizedPosition = Vector2.zero();

  MiniMapComponent({
    required this.focussedArea,
    required this.totalArea,
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

  @override
  void update(double dt) {
    double xMap = normalizedPosition.x * (width/2) + (width/2);
    double yMap = normalizedPosition.y * (height/2) + (height/2);
    setFocussedAreaPosition(xMap, yMap);
  }

  // @override
  // bool onDragStart(int pointerId, DragStartInfo info) {
  //   return false;
  // }
  //
  // @override
  // bool onDragUpdate(int pointerId, DragUpdateInfo info) {
  //   double xMap = info.eventPosition.global.x - startX;
  //   double yMap = info.eventPosition.global.y - startY;
  //   // setFocussedAreaPosition(xMap, yMap);
  //   return false;
  // }
  //
  // @override
  // bool onDragEnd(int pointerId, DragEndInfo info) {
  //   return false;
  // }

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
