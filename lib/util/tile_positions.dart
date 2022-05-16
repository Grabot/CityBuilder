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
import '../world/map_details/map_details_medium.dart';


// quadranten (these can be fairly high, they are x, y values not tile amounts
int quadrantSizeX = 240; // 1920/8 (standard monitor width)
int quadrantSizeY = 135; // 1080/8 (standard monitor height)

Future getHexagons(List<List<Tile2?>> tiles, int rotate, HexagonList hexagonList) async {
  if (rotate == 0) {

    SpriteBatch flat_1 = await SpriteBatch.load('flat_1.png');
    SpriteBatch flat_2 = await SpriteBatch.load('flat_2.png');
    int qRot = 0;
    int rRot = 0;
    int sRot = 0;

    int hexQ = qRot + (hexagonList.hexagons.length / 2).ceil();
    int hexR = rRot + (hexagonList.hexagons[0].length / 2).ceil();

    Hexagon hexagon = createHexagon(hexQ, hexR,
        tiles, qRot, rRot, sRot, hexagonList.radius, rotate, flat_1, flat_2);
    hexagon.updateHexagon(0, 0);
    hexagonList.hexagons[hexQ][hexR] = hexagon;
    // First we get a straight line from the center up to the left
    // and from the center to the right down.
    return getAll6HexVariants(hexQ, hexR, qRot, rRot, sRot, tiles, rotate, hexagonList, flat_1, flat_2);
  } else {
    return;
  }
}

Future getHexagonsLeftDown(hexQ, hexR, qRot, rRot, sRot, List<List<Tile2?>> tiles, int rotate, HexagonList hexagonList, SpriteBatch flat_1, SpriteBatch flat_2) async {
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
      Hexagon hexagonRot5 = createHexagon(hexQ - 1, hexR + 1,
          tiles, hexRotQ5, hexRotR5, hexRotS5, hexagonList.radius, rotate,
          await SpriteBatch.load('flat_1.png'), await SpriteBatch.load('flat_2.png'));
      hexagonRot5.updateHexagon(0, 0);
      hexagonList.hexagons[hexQ - 1][hexR + 1] = hexagonRot5;

      await getAll6HexVariants(hexQ - 1, hexR + 1, hexRotQ5, hexRotR5, hexRotS5, tiles, rotate, hexagonList, flat_1, flat_2);
    }
  }
}

Future getHexagonsRightUp(hexQ, hexR, qRot, rRot, sRot, List<List<Tile2?>> tiles, int rotate, HexagonList hexagonList, SpriteBatch flat_1, SpriteBatch flat_2) async {
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
      Hexagon hexagonRot2 = createHexagon(hexQ + 1, hexR - 1,
          tiles, hexRotQ2, hexRotR2, hexRotS2, hexagonList.radius, rotate,
          await SpriteBatch.load('flat_1.png'), await SpriteBatch.load('flat_2.png'));
      hexagonRot2.updateHexagon(0, 0);
      hexagonList.hexagons[hexQ + 1][hexR - 1] = hexagonRot2;

      await getAll6HexVariants(hexQ + 1, hexR - 1, hexRotQ2, hexRotR2, hexRotS2, tiles, rotate, hexagonList, flat_1, flat_2);
    }
  }
}

Future getHexagonsLeftUp(hexQ, hexR, qRot, rRot, sRot, List<List<Tile2?>> tiles, int rotate, HexagonList hexagonList, SpriteBatch flat_1, SpriteBatch flat_2) async {
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
      Hexagon hexagonRot3 = createHexagon(hexQ, hexR - 1,
          tiles, hexRotQ3, hexRotR3, hexRotS3, hexagonList.radius, rotate,
          await SpriteBatch.load('flat_1.png'), await SpriteBatch.load('flat_2.png'));
      hexagonRot3.updateHexagon(0, 0);
      hexagonList.hexagons[hexQ][hexR - 1] = hexagonRot3;

      await getAll6HexVariants(hexQ, hexR - 1, hexRotQ3, hexRotR3, hexRotS3, tiles, rotate, hexagonList, flat_1, flat_2);
    }
  }
}

Future getHexagonsRightDown(hexQ, hexR, qRot, rRot, sRot, List<List<Tile2?>> tiles, int rotate, HexagonList hexagonList, SpriteBatch flat_1, SpriteBatch flat_2) async {
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
      Hexagon hexagonRot4 = createHexagon(hexQ, hexR + 1,
          tiles, hexRotQ4, hexRotR4, hexRotS4, hexagonList.radius, rotate,
          await SpriteBatch.load('flat_1.png'), await SpriteBatch.load('flat_2.png'));
      hexagonRot4.updateHexagon(0, 0);
      hexagonList.hexagons[hexQ][hexR + 1] = hexagonRot4;

      await getAll6HexVariants(hexQ, hexR + 1, hexRotQ4, hexRotR4, hexRotS4, tiles, rotate, hexagonList, flat_1, flat_2);
    }
  }
}

Future getHexagonsStraightRight(hexQ, hexR, qRot, rRot, sRot, List<List<Tile2?>> tiles, int rotate, HexagonList hexagonList, SpriteBatch flat_1, SpriteBatch flat_2) async {
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
      Hexagon hexagonRot1 = createHexagon(hexQ + 1, hexR,
          tiles, hexRotQ1, hexRotR1, hexRotS1, hexagonList.radius, rotate,
          await SpriteBatch.load('flat_1.png'), await SpriteBatch.load('flat_2.png'));
      hexagonRot1.updateHexagon(0, 0);
      hexagonList.hexagons[hexQ+1][hexR] = hexagonRot1;

      await getAll6HexVariants(hexQ + 1, hexR, hexRotQ1, hexRotR1, hexRotS1, tiles, rotate, hexagonList, flat_1, flat_2);
    }
  }
}

Future getHexagonsStraightLeft(hexQ, hexR, qRot, rRot, sRot, List<List<Tile2?>> tiles, int rotate, HexagonList hexagonList, SpriteBatch flat_1, SpriteBatch flat_2) async {
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
      Hexagon hexagonRot6 = createHexagon(hexQ - 1, hexR,
          tiles, hexRotQ6, hexRotR6, hexRotS6, hexagonList.radius, rotate,
          await SpriteBatch.load('flat_1.png'), await SpriteBatch.load('flat_2.png'));
      hexagonRot6.updateHexagon(0, 0);
      hexagonList.hexagons[hexQ - 1][hexR] = hexagonRot6;

      await getAll6HexVariants(hexQ - 1, hexR, hexRotQ6, hexRotR6, hexRotS6, tiles, rotate, hexagonList, flat_1, flat_2);
    }
  }
}

Future getAll6HexVariants(hexQ, hexR, qRot, rRot, sRot, List<List<Tile2?>> tiles, int rotate, HexagonList hexagonList, SpriteBatch flat_1, SpriteBatch flat_2) async {

  // a hex section with radius r is Cube(2*r+1, -r, -r-1)
  // with 6 rotations
  // [ q,  r,  s]
  // [-r, -s, -q]
  // [  s,  q,  r]
  // [-s, -q, -r]
  // [r,  s,  q]
  // [ -q, -r,  -s]

  await getHexagonsStraightLeft(hexQ, hexR, qRot, rRot, sRot, tiles, rotate, hexagonList, flat_1, flat_2);
  await getHexagonsLeftUp(hexQ, hexR, qRot, rRot, sRot, tiles, rotate, hexagonList, flat_1, flat_2);
  await getHexagonsLeftDown(hexQ, hexR, qRot, rRot, sRot, tiles, rotate, hexagonList, flat_1, flat_2);
  await getHexagonsRightDown(hexQ, hexR, qRot, rRot, sRot, tiles, rotate, hexagonList, flat_1, flat_2);
  await getHexagonsRightUp(hexQ, hexR, qRot, rRot, sRot, tiles, rotate, hexagonList, flat_1, flat_2);
  await getHexagonsStraightRight(hexQ, hexR, qRot, rRot, sRot, tiles, rotate, hexagonList, flat_1, flat_2);
}

Hexagon createHexagon(int hexQ, int hexR, List<List<Tile2?>> tiles, int q, int r, int s, int radius, int rotate, SpriteBatch batch1, SpriteBatch batch2) {
  int qArray = q + (tiles.length / 2).ceil();
  int rArray = r + (tiles[0].length / 2).ceil();
  Tile2? centerTile = tiles[qArray][rArray];
  int sArray = centerTile!.s;

  Hexagon hexagon = Hexagon(batch1, batch2, centerTile.getPos(rotate), rotate, hexQ, hexR);
  for (int qTile = -radius; qTile <= radius; qTile++) {
    for (int rTile = -radius; rTile <= radius; rTile++) {

      if (((qArray + qTile) < tiles.length && (rArray + rTile) < tiles[0].length)
          && ((qArray + qTile) >= 0 && (rArray + rTile) >= 0)) {

        Tile2? tile = tiles[qArray + qTile][rArray + rTile];

        if (tile != null) {
          if ((sArray - tile.s) >= -radius && (sArray - tile.s) <= radius) {
            hexagon.addTileToHexagon(tile);
            tile.setHexagon(hexagon);
          }
        }
      }
    }
  }
  return hexagon;
}

// List<double> getBounds(List<List<Hexagon?>> hexagons, int rotate) {
//   // We loop over all the tiles to get the boundaries.
//   // We loop over the larger hexagon tiles to improve performance.
//   double left = 0;
//   double right = 0;
//   double top = 0;
//   double bottom = 0;
//   for (int q = 0; q < hexagons.length; q++) {
//     for (int r = 0; r < hexagons[0].length; r++) {
//       if (hexagons[q][r] != null) {
//         if (hexagons[q][r]!.getPos(0).x < left) {
//           left = hexagons[q][r]!.getPos(0).x;
//         } else if (hexagons[q][r]!.getPos(0).x > right) {
//           right = hexagons[q][r]!.getPos(0).x;
//         }
//
//         if (hexagons[q][r]!.getPos(0).y < bottom) {
//           bottom = hexagons[q][r]!.getPos(0).y;
//         } else if (hexagons[q][r]!.getPos(0).y > top) {
//           top = hexagons[q][r]!.getPos(0).y;
//         }
//       }
//     }
//   }
// }
