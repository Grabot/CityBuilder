import 'dart:math';
import 'dart:ui';

import 'package:city_builder/component/tile.dart';
import 'package:flame/components.dart';

class GrassTile extends Tile {

  late Sprite spriteFlat;
  late Sprite spritePoint;

  GrassTile(int q, int r, int s)
      : super(q, r, s);

  @override
  setSpriteFlat(Sprite sprite) {
    spriteFlat = sprite;
  }

  @override
  setSpritePoint(Sprite sprite) {
    spritePoint = sprite;
  }

  @override
  renderTile(Canvas canvas, int rotate) {
    if (rotate == 0) {
      spriteFlat.render(canvas,
          position: getPosFlat(),
          size: Vector2(2 * xSizeFlat, sqrt(3) * ySizeFlat)
      );
    } else if (rotate == 1) {
      spritePoint.render(canvas,
          position: getPosPoint(),
          size: Vector2(2 * xSizePoint, sqrt(3) * ySizePoint)
      );
    }
  }
}
