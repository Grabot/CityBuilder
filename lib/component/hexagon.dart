import 'dart:ui';

import 'package:city_builder/component/tile2.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Hexagon {

  late int rotation;

  late Vector2 center;

  late SpriteBatch spriteBatch;

  List<Tile2> hexagonTiles = [];

  Hexagon(this.spriteBatch, this.center, this.rotation);

  addTileToHexagon(Tile2 tile) {
    hexagonTiles.add(tile);
  }

  // We sort it on the y axis, so they are drawn from the top down.
  sortTiles() {
    hexagonTiles.sort((a, b) => a.getPos(rotation).y.compareTo(b.getPos(rotation).y));
  }

  updateHexagon() {
    spriteBatch.clear();
    for (Tile2 tile in hexagonTiles) {
      tile.updateTile(spriteBatch, 0, 0);
    }
  }

  renderHexagon(Canvas canvas) {
    spriteBatch.render(canvas, blendMode: BlendMode.srcOver);
  }
}