import 'dart:math';
import 'dart:ui';

import 'package:city_builder/component/tile.dart';
import 'package:flame/components.dart';

class DirtTile extends Tile {
  late Sprite spriteFlat;
  late Sprite spritePoint;
  DirtTile(int q, int r, int s)
      : super(q, r, s);

  setSpriteFlat(Sprite sprite) {
    spriteFlat = sprite;
  }

  setSpritePoint(Sprite sprite) {
    spritePoint = sprite;
  }

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