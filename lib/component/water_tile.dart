import 'dart:ui';
import 'package:city_builder/component/tile.dart';
import 'package:flame/sprite.dart';

class WaterTile extends Tile {

  WaterTile(int q, int r, int s)
      : super(q, r, s);

  @override
  renderTile(SpriteBatch spriteBatch, int rotate, int variant) {
    if (rotate == 0 || rotate == 2) {
      if (variant == 0) {
        spriteBatch.add(
            source: const Rect.fromLTWH(137, 1, 32, 14),
            offset: getPos(rotate),
            scale: scaleX
        );
      } else {
        spriteBatch.add(
          source: const Rect.fromLTWH(171, 1, 32, 14),
          offset: getPos(rotate),
          scale: scaleX
        );
      }
    } else {
      if (variant == 0) {
        spriteBatch.add(
            source: const Rect.fromLTWH(1, 73, 28, 16),
            offset: getPos(rotate),
            scale: scaleY
        );
      } else {
        spriteBatch.add(
            source: const Rect.fromLTWH(1, 91, 28, 16),
            offset: getPos(rotate),
            scale: scaleY
        );
      }
    }
  }

  @override
  renderAttribute(SpriteBatch spriteBatch, int rotate) {
  }

  @override
  int getTileType() {
    return 0;
  }
}
