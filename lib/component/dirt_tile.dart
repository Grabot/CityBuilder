import 'dart:ui';
import 'package:city_builder/component/tile.dart';
import 'package:flame/sprite.dart';

import 'get_texture.dart';

class DirtTile extends Tile {

  DirtTile(int q, int r, int s)
      : super(q, r, s);

  @override
  renderTile(SpriteBatch spriteBatch, int rotate, int variant) {
    if (rotate == 0 || rotate == 2) {
      spriteBatch.add(
          source: flatSmallDirt1,
          offset: getPos(rotate),
          scale: scaleX
      );
    } else {
      spriteBatch.add(
          source: pointSmallDirt1,
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
    return 2;
  }
}
