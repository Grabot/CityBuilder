
import 'package:city_builder/component/tile.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

class MapQuadrant {

  late double fromX;
  late double toX;
  late double fromY;
  late double toY;

  late Vector2 center;

  late SpriteBatch spriteBatchFlat;

  List<Tile> quadrantTiles = [];

  MapQuadrant(this.spriteBatchFlat, this.fromX, this.toX, this.fromY, this.toY, this.center);

  addTileToQuadrant(Tile tile) {
    quadrantTiles.add(tile);
  }
}
