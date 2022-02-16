import 'package:city_builder/component/hexagon.dart';
import 'package:city_builder/component/tile2.dart';
import 'package:city_builder/world/map_details/map_details_large.dart';
import 'package:city_builder/world/map_details/map_details_medium.dart';
import 'package:city_builder/world/map_details/map_details_normal.dart';
import 'package:city_builder/world/map_details/map_details_small.dart';
import 'package:city_builder/world/map_details/map_details_tiny.dart';
import 'package:city_builder/util/tile_positions.dart';

class HexagonList {
  static final HexagonList _instance = HexagonList._internal();

  late List<List<double>> worldBounds;
  late List<List<Tile2?>> tiles;
  late List<List<Hexagon?>> hexagons;
  int radius = 4;

  double halfWidthHex = 100;
  double halfHeightHex = 0;

  HexagonList._internal() {
    worldBounds = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]];

    List<List<int>> worldDetail = worldDetailLarge;
    tiles = List.generate(
        worldDetail.length,
            (_) => List.filled(worldDetail[0].length, null),
        growable: false);

    hexagons = List.generate(
        tiles.length~/radius,
            (_) => List.filled(tiles[0].length~/radius, null),
        growable: false);
    List<double> bounds = getTileDetails(worldDetail);
    worldBounds[0] = bounds;
    for (int rot = 0; rot < 4; rot++) {
      getHexagons(tiles, rot, this);
      // List<double> bounds = getBounds(hexagons, rot);
      // worldBounds[rot] = bounds;
    }
  }

  factory HexagonList() {
    return _instance;
  }

  // TODO: rotation?
  List<double> getTileDetails(List<List<int>> worldDetail) {

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
    // We add a bit to every boundary, this is because the hexagons are tiled and don't have the same boundaries
    return [left+100, right-100, top-200, bottom+200];
  }

}