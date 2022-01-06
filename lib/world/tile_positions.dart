import 'dart:math';
import 'package:city_builder/component/grass_tile.dart';
import 'package:city_builder/component/water_tile.dart';
import 'package:flame/components.dart';
import '../component/dirt_tile.dart';
import '../component/tile.dart';


List<List<int>> worldDetail = [
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0],
  [0, 0, 1, 2, 2, 1, 2, 1, 1, 0, 0],
  [0, 0, 1, 1, 2, 2, 2, 2, 1, 0, 0],
  [0, 0, 1, 2, 2, 2, 2, 2, 2, 0, 0],
  [0, 0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
  [0, 0, 0, 0, 1, 2, 2, 2, 1, 0, 0],
  [0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
];

List<List<Tile?>> setTileDetails(List<List<Tile?>> tiles, Sprite grassFlat, Sprite dirtFlat, Sprite waterFlat, Sprite grassPoint, Sprite dirtPoint, Sprite waterPoint) {

  for (int q = -(tiles.length/2).ceil(); q < (tiles.length/2).floor(); q++) {
    for (int r = -(tiles[0].length/2).ceil(); r < (tiles[0].length/2).floor(); r++) {
      // Simple check to ensure the map is hexagonal. It makes the map rotations look better
      if (((q + r) >= -((tiles.length/2).ceil() + 1)) && ((q + r) < (tiles.length/2).floor() - 1)) {
        int s = (q + r) * -1;
        int qArray = q + (tiles.length / 2).ceil();
        int rArray = r + (tiles[0].length / 2).ceil();
        if (worldDetail[qArray][rArray] == 0) {
          WaterTile tile = WaterTile(q, r, s);
          tile.setSpriteFlat(waterFlat);
          tile.setSpritePoint(waterPoint);
          tiles[qArray][rArray] = tile;
        } else if (worldDetail[qArray][rArray] == 1) {
          DirtTile tile = DirtTile(q, r, s);
          tile.setSpriteFlat(dirtFlat);
          tile.setSpritePoint(dirtPoint);
          tiles[qArray][rArray] = tile;
        } else if (worldDetail[qArray][rArray] == 2) {
          GrassTile tile = GrassTile(q, r, s);
          tile.setSpriteFlat(grassFlat);
          tile.setSpritePoint(grassPoint);
          tiles[qArray][rArray] = tile;
        }
      }
    }
  }
  return tiles;
}

