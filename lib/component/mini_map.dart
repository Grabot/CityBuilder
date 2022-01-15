import 'package:flame/components.dart';
import 'package:flutter/rendering.dart' show EdgeInsets;
import 'package:meta/meta.dart';
import 'package:flame/input.dart';


class MiniMapComponent extends HudMarginComponent with Draggable, Tappable {
  late final PositionComponent focussedArea;
  late final PositionComponent totalArea;

  double startX = -1;
  double startY = -1;

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
    print("initialized mini map");
    // We will assume that the map is always on the top left.
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

  @override
  void update(double dt) {
  }

  @override
  bool onDragStart(int pointerId, DragStartInfo info) {
    return false;
  }

  @override
  bool onDragUpdate(int pointerId, DragUpdateInfo info) {
    double xMap = info.eventPosition.global.x - startX;
    double yMap = info.eventPosition.global.y - startY;
    if (xMap > (width + startX)) {
      xMap = (width + startX);
    } else if (xMap < startX) {
      xMap = startX;
    }
    if (yMap > (height + startY)) {
      yMap = (height + startY);
    } else if (yMap < startY) {
      yMap = startY;
    }
    focussedArea.position = Vector2(xMap, yMap);
    return false;
  }

  @override
  bool onDragEnd(int pointerId, DragEndInfo info) {
    return false;
  }

  @override
  @mustCallSuper
  bool onTapUp(TapUpInfo info) {
    print("tapped x: ${info.eventPosition.global.x} y: ${info.eventPosition.global.y}");
    return true;
  }
}
