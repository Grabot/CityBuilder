import 'package:city_builder/component/grass_tile.dart';
import 'package:city_builder/component/water_tile.dart';
import 'package:flame/components.dart';
import '../component/dirt_tile.dart';
import '../component/tile.dart';
import 'map_details/map_details_normal.dart';


List<List<Tile?>> setTileDetails(Sprite grassFlat, Sprite dirtFlat, Sprite waterFlat, Sprite grassPoint, Sprite dirtPoint, Sprite waterPoint) {

  List<List<int>> worldDetail = worldDetailNormal;

  List<List<Tile?>> tiles = List.generate(
      worldDetail.length,
          (_) => List.filled(worldDetail[0].length, null),
      growable: false);

  for (int q = -(tiles.length/2).ceil(); q < (tiles.length/2).floor(); q++) {
    for (int r = -(tiles[0].length/2).ceil(); r < (tiles[0].length/2).floor(); r++) {
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
  return tiles;
}

