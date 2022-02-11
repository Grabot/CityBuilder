import 'dart:ui';
import 'package:city_builder/component/empty_tile.dart';
import 'package:city_builder/component/grass_tile.dart';
import 'package:city_builder/component/hexagon.dart';
import 'package:city_builder/component/map_quadrant.dart';
import 'package:city_builder/component/tile2.dart';
import 'package:city_builder/component/water_tile.dart';
import 'package:city_builder/world/map_details/map_details_large.dart';
import 'package:city_builder/world/map_details/map_details_normal.dart';
import 'package:city_builder/world/map_details/map_details_small.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import '../component/dirt_tile.dart';
import '../component/tile.dart';
import 'map_details/map_details_medium.dart';


// quadranten (these can be fairly high, they are x, y values not tile amounts
int quadrantSizeX = 240; // 1920/8 (standard monitor width)
int quadrantSizeY = 135; // 1080/8 (standard monitor height)

Future<List<List<Tile2?>>> setTileDetails() async {

  List<List<int>> worldDetail = worldDetailMedium;

  List<List<Tile2?>> tiles = List.generate(
      worldDetail.length,
          (_) => List.filled(worldDetail[0].length, null),
      growable: false);

  for (int q = -(tiles.length/2).ceil(); q < (tiles.length/2).floor(); q++) {
    for (int r = -(tiles[0].length/2).ceil(); r < (tiles[0].length/2).floor(); r++) {
      int s = (q + r) * -1;
      int qArray = q + (tiles.length / 2).ceil();
      int rArray = r + (tiles[0].length / 2).ceil();
      if (worldDetail[qArray][rArray] != -1) {
        Tile2 tile = Tile2(q, r, s, worldDetail[qArray][rArray]);
        tiles[qArray][rArray] = tile;
      }
    }
  }
  return tiles;
}

Future<List<Hexagon>> getHexagons(List<List<Tile2?>> tiles, int rotate) async {
  int radius = 4;
  List<Hexagon> hexagons = List.empty(growable: true);

  if (rotate == 0) {
    Hexagon hexagon = createHexagon(
        tiles, 0, 0, radius, rotate, await SpriteBatch.load('flat_1.png'));
    hexagons.add(hexagon);

    // a hex section with radius r is Cube(2*r+1, -r, -r-1)
    // 6 rotations
    // [ q,  r,  s]
    // [-r, -s, -q]
    // [  s,  q,  r]
    // [-s, -q, -r]
    // [r,  s,  q]
    // [ -q, -r,  -s]
    int qRot1 = (2 * radius) + 1;
    int rRot1 = -radius;
    int sRot1 = -radius - 1;
    Hexagon hexagonRot1 = createHexagon(tiles, qRot1, rRot1, radius, rotate,
        await SpriteBatch.load('flat_1.png'));
    hexagons.add(hexagonRot1);

    int qRot2 = -rRot1;
    int rRot2 = -sRot1;
    int sRot2 = -qRot1;
    Hexagon hexagonRot2 = createHexagon(tiles, qRot2, rRot2, radius, rotate,
        await SpriteBatch.load('flat_1.png'));
    hexagons.add(hexagonRot2);

    int qRot3 = sRot1;
    int rRot3 = qRot1;
    int sRot3 = rRot1;
    Hexagon hexagonRot3 = createHexagon(tiles, qRot3, rRot3, radius, rotate,
        await SpriteBatch.load('flat_1.png'));
    hexagons.add(hexagonRot3);

    int qRot4 = -sRot1;
    int rRot4 = -qRot1;
    int sRot4 = -rRot1;
    Hexagon hexagonRot4 = createHexagon(tiles, qRot4, rRot4, radius, rotate,
        await SpriteBatch.load('flat_1.png'));
    hexagons.add(hexagonRot4);

    int qRot5 = rRot1;
    int rRot5 = sRot1;
    int sRot5 = qRot1;
    Hexagon hexagonRot5 = createHexagon(tiles, qRot5, rRot5, radius, rotate,
        await SpriteBatch.load('flat_1.png'));
    hexagons.add(hexagonRot5);

    int qRot6 = -qRot1;
    int rRot6 = -rRot1;
    int sRot6 = -sRot1;
    Hexagon hexagonRot6 = createHexagon(tiles, qRot6, rRot6, radius, rotate,
        await SpriteBatch.load('flat_1.png'));
    hexagons.add(hexagonRot6);
  }
  return hexagons;
}

Hexagon createHexagon(List<List<Tile2?>> tiles, int q, int r, int radius, int rotate, SpriteBatch batch) {
  int qArray = q + (tiles.length / 2).ceil();
  int rArray = r + (tiles[0].length / 2).ceil();
  Tile2? centerTile = tiles[qArray][rArray];
  int sArray = centerTile!.s;

  Hexagon hexagon = Hexagon(batch, centerTile.getPos(rotate), rotate);

  for (int qTile = -radius; qTile <= radius; qTile++) {
    for (int rTile = -radius; rTile <= radius; rTile++) {
      Tile2? tile = tiles[qArray + qTile][rArray + rTile];

      if (tile != null) {
        if ((sArray - tile.s) >= -radius && (sArray - tile.s) <= radius) {
          hexagon.addTileToHexagon(tile);
        }
      }
    }
  }
  return hexagon;
}

Future<List<List<MapQuadrant?>>> getMapQuadrants(List<List<Tile2?>> tiles, int rotate) async {

  List<double> bounds = getBounds(tiles, rotate);
  double left = bounds[0];
  double right = bounds[1];
  double top = bounds[2];
  double bottom = bounds[3];

  double totalWidth = left.abs() + right.abs();
  double totalHeight = top.abs() + bottom.abs();

  int quadrantsX = (totalWidth / quadrantSizeX).ceil();
  int quadrantsY = (totalHeight / quadrantSizeY).ceil();
  List<List<MapQuadrant?>> mapQuadrants = List.generate(
      quadrantsX, (_) => List.filled(quadrantsY, null),
      growable: false);
  for (int x = 0; x < quadrantsX; x++) {
    for (int y = 0; y < quadrantsY; y++) {
      double fromX = left + (x * quadrantSizeX);
      double toX = left + ((x + 1) * quadrantSizeX);
      double fromY = bottom + (y * quadrantSizeY);
      double toY = bottom + ((y + 1) * quadrantSizeY);
      Vector2 quadrantCenter = Vector2((fromX + (quadrantSizeX/2)), (fromY + (quadrantSizeY/2)));
      if (rotate == 0 || rotate == 2) {
        MapQuadrant mapQuadrant = MapQuadrant(
            await SpriteBatch.load('flat_1.png'), fromX, toX, fromY, toY,
            quadrantCenter, rotate);
        mapQuadrants[x][y] = mapQuadrant;
      } else {
        MapQuadrant mapQuadrant = MapQuadrant(
            await SpriteBatch.load('point_1.png'), fromX, toX, fromY, toY,
            quadrantCenter, rotate);
        mapQuadrants[x][y] = mapQuadrant;
      }
    }
  }
  return mapQuadrants;
}

renderHexagons(Canvas canvas, List<Hexagon> hexagons) {

  for (Hexagon hexagon in hexagons) {
    hexagon.renderHexagon(canvas);
  }

}

// renderTiles(Canvas canvas, List<List<Tile2?>> tiles, int q, int r, double leftScreen, double rightScreen, double topScreen, double bottomScreen) {
//   // first a test with drawing only 2 tiles wide
//   int qArray = q + (tiles.length / 2).ceil();
//   int rArray = r + (tiles[0].length / 2).ceil();
//   Tile2? centerTile = tiles[qArray][rArray];
//   int sArray = centerTile!.s;
//
//   int radius = 4;
//   for (int qTile = -radius; qTile <= radius; qTile++) {
//     for (int rTile = -radius; rTile <= radius; rTile++) {
//       Tile2? tile = tiles[qArray + qTile][rArray + rTile];
//       drawTile(canvas, tile, sArray, radius, leftScreen, rightScreen, topScreen, bottomScreen);
//     }
//   }
// }

// drawTile(Canvas canvas, Tile2? tile, int sArray, int radius, double leftScreen, double rightScreen, double topScreen, double bottomScreen) {
//   if (tile != null) {
//     if ((sArray - tile.s) >= -radius && (sArray - tile.s) <= radius) {
//       if (tile.getPos(0).x > leftScreen && tile.getPos(0).x < rightScreen) {
//         if (tile.getPos(0).y > topScreen && tile.getPos(0).y < bottomScreen) {
//           tile.render(canvas);
//         }
//       }
//     }
//   }
// }

List<double> getBounds(List<List<Tile2?>> tiles, int rotate) {

  double left = tiles[0][(tiles.length / 2).floor()]!.getPos(rotate).x;
  double right = tiles[tiles.length - 1][(tiles.length / 2).floor()]!.getPos(rotate).x;
  double top = tiles[(tiles.length / 2).round()][0]!.getPos(rotate).y;
  double bottom = tiles[(tiles.length / 2).floor()][tiles.length - 1]!.getPos(rotate).y;

  if (rotate == 1) {
    top = tiles[tiles.length - 1][(tiles.length / 2).floor()]!.getPos(rotate).y;
    bottom = tiles[0][(tiles.length / 2).round()]!.getPos(rotate).y;
    left = tiles[(tiles.length / 2).floor()][0]!.getPos(rotate).x;
    right = tiles[(tiles.length / 2).floor()][tiles.length - 1]!.getPos(rotate).x;
  } else if (rotate == 2) {
    right = tiles[0][(tiles.length / 2).round()]!.getPos(rotate).x;
    left = tiles[tiles.length - 1][(tiles.length / 2).floor()]!.getPos(rotate).x;
    bottom = tiles[(tiles.length / 2).floor()][0]!.getPos(rotate).y;
    top = tiles[(tiles.length / 2).floor()][tiles.length - 1]!.getPos(rotate).y;
  } else if (rotate == 3) {
    bottom = tiles[tiles.length - 1][(tiles.length / 2).floor()]!.getPos(rotate).y;
    top = tiles[0][(tiles.length / 2).round()]!.getPos(rotate).y;
    right = tiles[(tiles.length / 2).floor()][0]!.getPos(rotate).x;
    left = tiles[(tiles.length / 2).floor()][tiles.length - 1]!.getPos(rotate).x;
  }

  return [left, right, top, bottom];
}