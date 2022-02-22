import 'package:city_builder/component/hexagon.dart';
import 'package:city_builder/component/tile2.dart';
import 'package:city_builder/world/map_details/map_details_large.dart';
import 'package:city_builder/world/map_details/map_details_medium.dart';
import 'package:city_builder/world/map_details/map_details_normal.dart';
import 'package:city_builder/world/map_details/map_details_small.dart';
import 'package:city_builder/world/map_details/map_details_tiny.dart';
import 'package:city_builder/util/tile_positions.dart';
import 'package:flame/components.dart';

class HexagonList {
  static final HexagonList _instance = HexagonList._internal();

  // For every rotation we keep track of 6 hexagon points
  late List<List<Vector2>> hexagonBounds;
  late List<List<Tile2?>> tiles;
  late List<List<Hexagon?>> hexagons;
  int radius = 4;

  double halfWidthHex = 100;
  double halfHeightHex = 0;

  HexagonList._internal() {
    // We initialize the bounds with 0, 0
    Vector2 z = Vector2(0, 0);
    hexagonBounds = [[z, z, z, z, z, z], [z, z, z, z, z, z], [z, z, z, z, z, z], [z, z, z, z, z, z]];

    List<List<int>> worldDetail = worldDetailLarge;
    tiles = List.generate(
        worldDetail.length,
            (_) => List.filled(worldDetail[0].length, null),
        growable: false);

    hexagons = List.generate(
        tiles.length~/radius,
            (_) => List.filled(tiles[0].length~/radius, null),
        growable: false);
    getTileDetails(worldDetail);
    for (int rot = 0; rot < 4; rot++) {
      getHexagons(tiles, rot, this);
    }
  }

  factory HexagonList() {
    return _instance;
  }

  // TODO: rotation?
  getTileDetails(List<List<int>> worldDetail) {

    double left = 0;
    double right = 0;
    double top = 0;
    double bottom = 0;

    for (int q = -(tiles.length/2).ceil(); q < (tiles.length/2).floor(); q++) {
      for (int r = -(tiles[0].length/2).ceil(); r < (tiles[0].length/2).floor(); r++) {
        int s = (q + r) * -1;
        int qArray = q + (tiles.length / 2).ceil();
        int rArray = r + (tiles[0].length / 2).ceil();
        Tile2 tile = Tile2(q, r, s, worldDetail[qArray][rArray]);
        tiles[qArray][rArray] = tile;

        if (worldDetail[qArray][rArray] != -1) {
          if (tile.getPos(0).x < left) {
            left = tile.getPos(0).x;
          } else if (tile.getPos(0).x > right) {
            right = tile.getPos(0).x;
          }

          if (tile.getPos(0).y < bottom) {
            bottom = tile.getPos(0).y;
          } else if (tile.getPos(0).y > top) {
            top = tile.getPos(0).y;
          }
        }
      }
    }
    // Also get all 6 hexagon points from the bottom rotating to the left
    Vector2 pBottom = Vector2(0, bottom);
    Vector2 pLeftBottom = Vector2(left, bottom/2);
    Vector2 pLeftUp = Vector2(left, top/2);
    Vector2 pTop = Vector2(0, top);
    Vector2 pRightTop = Vector2(right, top/2);
    Vector2 pRightBottom = Vector2(right, bottom/2);
    hexagonBounds[0] = [pBottom, pLeftBottom, pLeftUp, pTop, pRightTop, pRightBottom];
  }

}