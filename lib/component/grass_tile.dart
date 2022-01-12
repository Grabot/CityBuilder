import 'dart:ui';
import 'package:city_builder/component/tile.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class GrassTile extends Tile {

  GrassTile(int q, int r, int s)
      : super(q, r, s);

  @override
  renderTile(SpriteBatch spriteBatch, int rotate) {
    if (rotate == 0 || rotate == 2) {
      spriteBatch.add(
          source: Rect.fromLTWH(0, 56, 128, 56),
          offset: getPos(rotate),
          scale: scaleX
      );
    } else {
      spriteBatch.add(
          source: Rect.fromLTWH(0, 64, 112, 64),
          offset: getPos(rotate),
          scale: scaleY
      );
    }
  }

  @override
  renderAttribute(SpriteBatch spriteBatch, int rotate) {
    if (rotate == 0 || rotate == 2) {
      spriteBatch.add(
          source: const Rect.fromLTWH(0, 112, 321, 349),
          offset: getPos(rotate) + Vector2(8, -12),
          scale: 0.06
      );
    } else {
      spriteBatch.add(
          source: const Rect.fromLTWH(0, 128, 321, 349),
          offset: getPos(rotate) + Vector2(5, -8),
          scale: 0.06
      );
    }
  }

  @override
  int getTileType() {
    return 1;
  }
}
