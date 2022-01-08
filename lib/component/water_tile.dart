import 'dart:ui';
import 'package:city_builder/component/tile.dart';
import 'package:flame/sprite.dart';

class WaterTile extends Tile {

  WaterTile(int q, int r, int s)
      : super(q, r, s);

  @override
  renderTile(SpriteBatch spriteBatch, int rotate) {
    if (rotate == 0 || rotate == 2) {
      spriteBatch.add(
          source: Rect.fromLTWH(256, 0, 128, 54),
          offset: getPos(rotate),
          scale: scale
      );
    } else {
      spriteBatch.add(
          source: Rect.fromLTWH(224, 0, 112, 64),
          offset: getPos(rotate),
          scale: scale
      );
    }
  }

  @override
  int getTileType() {
    return 0;
  }
}
