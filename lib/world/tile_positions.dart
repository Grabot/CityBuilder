import 'dart:ui';
import 'package:city_builder/component/empty_tile.dart';
import 'package:city_builder/component/grass_tile.dart';
import 'package:city_builder/component/hexagon.dart';
import 'package:city_builder/component/map_quadrant.dart';
import 'package:city_builder/component/tile2.dart';
import 'package:city_builder/component/water_tile.dart';
import 'package:city_builder/util/hexagon_list.dart';
import 'package:city_builder/world/map_details/map_details_large.dart';
import 'package:city_builder/world/map_details/map_details_normal.dart';
import 'package:city_builder/world/map_details/map_details_small.dart';
import 'package:city_builder/world/map_details/map_details_tiny.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import '../component/dirt_tile.dart';
import '../component/tile.dart';
import 'map_details/map_details_medium.dart';


// quadranten (these can be fairly high, they are x, y values not tile amounts
int quadrantSizeX = 240; // 1920/8 (standard monitor width)
int quadrantSizeY = 135; // 1080/8 (standard monitor height)

Future getHexagons(List<List<Tile2?>> tiles, int rotate, HexagonList hexagonList) async {
  if (rotate == 0) {

    int qRot = 0;
    int rRot = 0;
    int sRot = 0;

    int hexQ = qRot + (hexagonList.hexagons.length / 2).ceil();
    int hexR = rRot + (hexagonList.hexagons[0].length / 2).ceil();

    Hexagon hexagon = createHexagon(
        tiles, qRot, rRot, sRot, hexagonList.radius, rotate, await SpriteBatch.load('flat_1.png'));
    hexagon.updateHexagon();
    hexagonList.hexagons[hexQ][hexR] = hexagon;
    // First we get a straight line from the center up to the left
    // and from the center to the right down.
    await getAll6HexVariants(hexQ, hexR, qRot, rRot, sRot, tiles, rotate, hexagonList);
  }
}

Future getHexagonsLeftDown(hexQ, hexR, qRot, rRot, sRot, List<List<Tile2?>> tiles, int rotate, HexagonList hexagonList) async {
  int qRot1 = (2 * hexagonList.radius) + 1;
  int rRot1 = -hexagonList.radius;
  int sRot1 = -hexagonList.radius - 1;

  if ((hexR + 1) < hexagonList.hexagons[0].length.ceil()
      && (hexQ - 1) >= 0
      && hexagonList.hexagons[hexQ - 1][hexR + 1] == null) {
    int qRot5 = rRot1;
    int rRot5 = sRot1;
    int sRot5 = qRot1;

    int hexRotQ5 = qRot + qRot5;
    int hexRotR5 = rRot + rRot5;
    int hexRotS5 = sRot + sRot5;

    int qArray = hexRotQ5 + (tiles.length / 2).ceil();
    int rArray = hexRotR5 + (tiles[0].length / 2).ceil();

    if (qArray < tiles.length
        && qArray >= 0
        && rArray < tiles[0].length
        && rArray >= 0) {
      Hexagon hexagonRot5 = createHexagon(
          tiles, hexRotQ5, hexRotR5, hexRotS5, hexagonList.radius, rotate,
          await SpriteBatch.load('flat_1.png'));
      hexagonRot5.updateHexagon();
      hexagonList.hexagons[hexQ - 1][hexR + 1] = hexagonRot5;

      await getAll6HexVariants(hexQ - 1, hexR + 1, hexRotQ5, hexRotR5, hexRotS5, tiles, rotate, hexagonList);
    }
  }
}

Future getHexagonsRightUp(hexQ, hexR, qRot, rRot, sRot, List<List<Tile2?>> tiles, int rotate, HexagonList hexagonList) async {
  int qRot1 = (2 * hexagonList.radius) + 1;
  int rRot1 = -hexagonList.radius;
  int sRot1 = -hexagonList.radius - 1;

  if ((hexQ + 1) < hexagonList.hexagons.length.ceil()
      && (hexR - 1) >= 0
      && hexagonList.hexagons[hexQ + 1][hexR - 1] == null) {
    int qRot2 = -rRot1;
    int rRot2 = -sRot1;
    int sRot2 = -qRot1;

    int hexRotQ2 = qRot + qRot2;
    int hexRotR2 = rRot + rRot2;
    int hexRotS2 = sRot + sRot2;

    int qArray = hexRotQ2 + (tiles.length / 2).ceil();
    int rArray = hexRotR2 + (tiles[0].length / 2).ceil();
    if (qArray < tiles.length && rArray < tiles[0].length) {
      Hexagon hexagonRot2 = createHexagon(
          tiles, hexRotQ2, hexRotR2, hexRotS2, hexagonList.radius, rotate,
          await SpriteBatch.load('flat_1.png'));
      hexagonRot2.updateHexagon();
      hexagonList.hexagons[hexQ + 1][hexR - 1] = hexagonRot2;

      await getAll6HexVariants(hexQ + 1, hexR - 1, hexRotQ2, hexRotR2, hexRotS2, tiles, rotate, hexagonList);
    }
  }
}

Future getHexagonsLeftUp(hexQ, hexR, qRot, rRot, sRot, List<List<Tile2?>> tiles, int rotate, HexagonList hexagonList) async {
  int qRot1 = (2 * hexagonList.radius) + 1;
  int rRot1 = -hexagonList.radius;
  int sRot1 = -hexagonList.radius - 1;

  if ((hexR - 1) >= 0
      && hexagonList.hexagons[hexQ][hexR - 1] == null) {
    int qRot3 = sRot1;
    int rRot3 = qRot1;
    int sRot3 = rRot1;

    int hexRotQ3 = qRot + qRot3;
    int hexRotR3 = rRot + rRot3;
    int hexRotS3 = sRot + sRot3;
    int qArray = hexRotQ3 + (tiles.length / 2).ceil();
    int rArray = hexRotR3 + (tiles[0].length / 2).ceil();
    if (qArray < tiles.length
        && qArray >= 0
        && rArray < tiles[0].length
        && rArray >= 0) {
      Hexagon hexagonRot3 = createHexagon(
          tiles, hexRotQ3, hexRotR3, hexRotS3, hexagonList.radius, rotate,
          await SpriteBatch.load('flat_1.png'));
      hexagonRot3.updateHexagon();
      hexagonList.hexagons[hexQ][hexR - 1] = hexagonRot3;

      await getAll6HexVariants(hexQ, hexR - 1, hexRotQ3, hexRotR3, hexRotS3, tiles, rotate, hexagonList);
    }
  }
}

Future getHexagonsRightDown(hexQ, hexR, qRot, rRot, sRot, List<List<Tile2?>> tiles, int rotate, HexagonList hexagonList) async {
  int qRot1 = (2 * hexagonList.radius) + 1;
  int rRot1 = -hexagonList.radius;
  int sRot1 = -hexagonList.radius - 1;

  if ((hexR + 1) < hexagonList.hexagons[0].length.ceil()
      && hexagonList.hexagons[hexQ][hexR + 1] == null) {
    int qRot4 = -sRot1;
    int rRot4 = -qRot1;
    int sRot4 = -rRot1;

    int hexRotQ4 = qRot + qRot4;
    int hexRotR4 = rRot + rRot4;
    int hexRotS4 = sRot + sRot4;

    int qArray = hexRotQ4 + (tiles.length / 2).ceil();
    int rArray = hexRotR4 + (tiles[0].length / 2).ceil();

    if (qArray < tiles.length
        && qArray >= 0
        && rArray < tiles[0].length
        && rArray >= 0) {
      Hexagon hexagonRot4 = createHexagon(
          tiles, hexRotQ4, hexRotR4, hexRotS4, hexagonList.radius, rotate,
          await SpriteBatch.load('flat_1.png'));
      hexagonRot4.updateHexagon();
      hexagonList.hexagons[hexQ][hexR + 1] = hexagonRot4;

      await getAll6HexVariants(hexQ, hexR + 1, hexRotQ4, hexRotR4, hexRotS4, tiles, rotate, hexagonList);
    }
  }
}

Future getHexagonsStraightRight(hexQ, hexR, qRot, rRot, sRot, List<List<Tile2?>> tiles, int rotate, HexagonList hexagonList) async {
  int qRot1 = (2 * hexagonList.radius) + 1;
  int rRot1 = -hexagonList.radius;
  int sRot1 = -hexagonList.radius - 1;

  if ((hexQ+1) < hexagonList.hexagons.length.ceil()
      && hexagonList.hexagons[hexQ+1][hexR] == null) {

    int hexRotQ1 = qRot + qRot1;
    int hexRotR1 = rRot + rRot1;
    int hexRotS1 = sRot + sRot1;

    int qArray = hexRotQ1 + (tiles.length / 2).ceil();
    int rArray = hexRotR1 + (tiles[0].length / 2).ceil();
    if (qArray < tiles.length
        && qArray >= 0
        && rArray < tiles[0].length
        && rArray >= 0) {
      Hexagon hexagonRot1 = createHexagon(
          tiles, hexRotQ1, hexRotR1, hexRotS1, hexagonList.radius, rotate,
          await SpriteBatch.load('flat_1.png'));
      hexagonRot1.updateHexagon();
      hexagonList.hexagons[hexQ+1][hexR] = hexagonRot1;

      await getAll6HexVariants(hexQ + 1, hexR, hexRotQ1, hexRotR1, hexRotS1, tiles, rotate, hexagonList);
    }
  }
}

Future getHexagonsStraightLeft(hexQ, hexR, qRot, rRot, sRot, List<List<Tile2?>> tiles, int rotate, HexagonList hexagonList) async {
  int qRot1 = (2 * hexagonList.radius) + 1;
  int rRot1 = -hexagonList.radius;
  int sRot1 = -hexagonList.radius - 1;

  if ((hexQ - 1) >= 0
      && hexagonList.hexagons[hexQ - 1][hexR] == null) {
    int qRot6 = -qRot1;
    int rRot6 = -rRot1;
    int sRot6 = -sRot1;

    int hexRotQ6 = qRot + qRot6;
    int hexRotR6 = rRot + rRot6;
    int hexRotS6 = sRot + sRot6;

    int qArray = hexRotQ6 + (tiles.length / 2).ceil();
    int rArray = hexRotR6 + (tiles[0].length / 2).ceil();

    if (qArray < tiles.length
        && qArray >= 0
        && rArray < tiles[0].length
        && rArray >= 0) {
      Hexagon hexagonRot6 = createHexagon(
          tiles, hexRotQ6, hexRotR6, hexRotS6, hexagonList.radius, rotate,
          await SpriteBatch.load('flat_1.png'));
      hexagonRot6.updateHexagon();
      hexagonList.hexagons[hexQ - 1][hexR] = hexagonRot6;

      await getAll6HexVariants(hexQ - 1, hexR, hexRotQ6, hexRotR6, hexRotS6, tiles, rotate, hexagonList);
    }
  }
}

Future getAll6HexVariants(hexQ, hexR, qRot, rRot, sRot, List<List<Tile2?>> tiles, int rotate, HexagonList hexagonList) async {

  // a hex section with radius r is Cube(2*r+1, -r, -r-1)
  // with 6 rotations
  // [ q,  r,  s]
  // [-r, -s, -q]
  // [  s,  q,  r]
  // [-s, -q, -r]
  // [r,  s,  q]
  // [ -q, -r,  -s]

  await getHexagonsStraightLeft(hexQ, hexR, qRot, rRot, sRot, tiles, rotate, hexagonList);
  await getHexagonsLeftUp(hexQ, hexR, qRot, rRot, sRot, tiles, rotate, hexagonList);
  await getHexagonsLeftDown(hexQ, hexR, qRot, rRot, sRot, tiles, rotate, hexagonList);
  await getHexagonsRightDown(hexQ, hexR, qRot, rRot, sRot, tiles, rotate, hexagonList);
  await getHexagonsRightUp(hexQ, hexR, qRot, rRot, sRot, tiles, rotate, hexagonList);
  await getHexagonsStraightRight(hexQ, hexR, qRot, rRot, sRot, tiles, rotate, hexagonList);
}

Hexagon createHexagon(List<List<Tile2?>> tiles, int q, int r, int s, int radius, int rotate, SpriteBatch batch) {
  int qArray = q + (tiles.length / 2).ceil();
  int rArray = r + (tiles[0].length / 2).ceil();
  Tile2? centerTile = tiles[qArray][rArray];
  int sArray = centerTile!.s;

  Hexagon hexagon = Hexagon(batch, centerTile.getPos(rotate), rotate, q ,r ,s);
  for (int qTile = -radius; qTile <= radius; qTile++) {
    for (int rTile = -radius; rTile <= radius; rTile++) {

      if (((qArray + qTile) < tiles.length && (rArray + rTile) < tiles[0].length)
          && ((qArray + qTile) >= 0 && (rArray + rTile) >= 0)) {

        Tile2? tile = tiles[qArray + qTile][rArray + rTile];

        if (tile != null) {
          if ((sArray - tile.s) >= -radius && (sArray - tile.s) <= radius) {
            hexagon.addTileToHexagon(tile);
          }
        }
      }
    }
  }
  return hexagon;
}

// Future<List<List<MapQuadrant?>>> getMapQuadrants(List<List<Tile2?>> tiles, int rotate) async {
//
//   List<double> bounds = getBounds(tiles, rotate);
//   double left = bounds[0];
//   double right = bounds[1];
//   double top = bounds[2];
//   double bottom = bounds[3];
//
//   double totalWidth = left.abs() + right.abs();
//   double totalHeight = top.abs() + bottom.abs();
//
//   int quadrantsX = (totalWidth / quadrantSizeX).ceil();
//   int quadrantsY = (totalHeight / quadrantSizeY).ceil();
//   List<List<MapQuadrant?>> mapQuadrants = List.generate(
//       quadrantsX, (_) => List.filled(quadrantsY, null),
//       growable: false);
//   for (int x = 0; x < quadrantsX; x++) {
//     for (int y = 0; y < quadrantsY; y++) {
//       double fromX = left + (x * quadrantSizeX);
//       double toX = left + ((x + 1) * quadrantSizeX);
//       double fromY = bottom + (y * quadrantSizeY);
//       double toY = bottom + ((y + 1) * quadrantSizeY);
//       Vector2 quadrantCenter = Vector2((fromX + (quadrantSizeX/2)), (fromY + (quadrantSizeY/2)));
//       if (rotate == 0 || rotate == 2) {
//         MapQuadrant mapQuadrant = MapQuadrant(
//             await SpriteBatch.load('flat_1.png'), fromX, toX, fromY, toY,
//             quadrantCenter, rotate);
//         mapQuadrants[x][y] = mapQuadrant;
//       } else {
//         MapQuadrant mapQuadrant = MapQuadrant(
//             await SpriteBatch.load('point_1.png'), fromX, toX, fromY, toY,
//             quadrantCenter, rotate);
//         mapQuadrants[x][y] = mapQuadrant;
//       }
//     }
//   }
//   return mapQuadrants;
// }

renderHexagons(Canvas canvas, List<List<Hexagon?>> hexagons) {

  for (int q = 0; q < hexagons.length; q++) {
    for (int r = 0; r < hexagons[q].length; r++) {
      if (hexagons[q][r] != null) {
        hexagons[q][r]!.renderHexagon(canvas);
      }
    }
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