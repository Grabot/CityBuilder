import 'dart:ui';

import 'package:city_builder/component/tile2.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class Hexagon {

  late int rotation;

  late Vector2 center;

  late SpriteBatch spriteBatch;

  List<Tile2> hexagonTiles = [];

  late int hexQArray;
  late int hexRArray;

  Hexagon(this.spriteBatch, this.center, this.rotation, this.hexQArray, this.hexRArray);

  addTileToHexagon(Tile2 tile) {
    hexagonTiles.add(tile);
  }

  // We sort it on the y axis, so they are drawn from the top down.
  sortTiles() {
    hexagonTiles.sort((a, b) => a.getPos(rotation).y.compareTo(b.getPos(rotation).y));
  }

  updateHexagon(int rotate, int variation) {
    spriteBatch.clear();
    for (Tile2 tile in hexagonTiles) {
      tile.updateTile(spriteBatch, rotate, variation);
    }
  }

  getPos(int rotate) {
    return center;
  }

  renderHexagon(Canvas canvas) {
    spriteBatch.render(canvas, blendMode: BlendMode.srcOver);
  }

  String toString() {
    return "hex q: $hexQArray r: $hexRArray on pos: $center}";
  }
}