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
            source: const Rect.fromLTWH(128, 0, 32, 14),
            offset: getPos(rotate),
            scale: scaleX
        );
      } else {
        spriteBatch.add(
          source: const Rect.fromLTWH(160, 0, 32, 14),
          offset: getPos(rotate),
          scale: scaleX
        );
      }
    } else {
      spriteBatch.add(
          source: const Rect.fromLTWH(112, 0, 28, 16),
          offset: getPos(rotate),
          scale: scaleY
      );
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
