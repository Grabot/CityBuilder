
import 'package:city_builder/component/tile.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class MapQuadrant {

  late double fromX;
  late double toX;
  late double fromY;
  late double toY;

  late int rotation;

  late Vector2 center;

  late SpriteBatch spriteBatch;

  List<Tile> quadrantTiles = [];

  MapQuadrant(this.spriteBatch, this.fromX, this.toX, this.fromY, this.toY, this.center, this.rotation);

  addTileToQuadrant(Tile tile) {
    quadrantTiles.add(tile);
  }

  // We sort it on the y axis, so they are drawn from the top down.
  sortTiles() {
    quadrantTiles.sort((a, b) => a.getPos(rotation).y.compareTo(b.getPos(rotation).y));
  }
}
