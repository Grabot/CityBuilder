import 'dart:ui';
import 'package:city_builder/component/tile.dart';
import 'package:flame/components.dart';

class WaterTile extends Tile {

  WaterTile(int q, int r, int s)
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
    if (rotate == 0 || rotate == 2) {
      spriteFlat.render(canvas,
          position: getPos(rotate),
          size: getSize(rotate)
      );
    } else {
      spritePoint.render(canvas,
          position: getPos(rotate),
          size: getSize(rotate)
      );
    }
  }

  @override
  int getTileType() {
    return 0;
  }
}
