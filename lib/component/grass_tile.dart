import 'dart:ui';
import 'package:city_builder/component/tile.dart';
import 'package:flame/sprite.dart';

class GrassTile extends Tile {

  GrassTile(int q, int r, int s)
      : super(q, r, s);

  @override
  renderTile(SpriteBatch spriteBatch, int rotate) {
    if (rotate == 0 || rotate == 2) {
      spriteBatch.add(
          source: Rect.fromLTWH(128, 0, 128, 54),
          offset: getPos(rotate),
          scale: scale
      );
    } else {
      spriteBatch.add(
          source: Rect.fromLTWH(112, 0, 112, 64),
          offset: getPos(rotate),
          scale: scale
      );
    }
  }

  @override
  int getTileType() {
    return 1;
  }
}
