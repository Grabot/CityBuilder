import 'dart:ui';
import 'package:city_builder/component/tile.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

import 'get_texture.dart';

class EmptyTile extends Tile {

  bool empty = true;
  EmptyTile(int q, int r, int s)
      : super(q, r, s);

  @override
  renderTile(SpriteBatch spriteBatch, int rotate, int variant) {
    if (!empty) {
      print("added a sprite");
      spriteBatch.add(
          source: flatSmallGrass1,
          offset: getPos(rotate),
          scale: scaleX
      );
    } else {
      spriteBatch.add(
          source: flatSmallWater1,
          offset: getPos(rotate),
          scale: scaleX
      );
    }
  }

  @override
  renderAttribute(SpriteBatch spriteBatch, int rotate) {
  }

  @override
  int getTileType() {
    print("placeholder to change the empty tile!");
    empty = false;
    return 5;
  }
}
