
import 'dart:ui';

import 'package:city_builder/component/hexagon.dart';
import 'package:city_builder/component/tile2.dart';
import 'package:city_builder/util/hexagon_list.dart';
import 'package:city_builder/util/tapped_map.dart';

renderHexagons(Canvas canvas, Tile2 cameraTile, HexagonList hexagonList, Rect screen) {

  // if (cameraTile.hexagon != null) {
  //   for (int q = -3; q <= 3; q++ ) {
  //     for (int r = -3; r <= 3; r++ ) {
  //       if (hexagons[cameraTile.hexagon!.hexQArray + q][cameraTile.hexagon!
  //           .hexRArray + r] != null) {
  //         hexagons[cameraTile.hexagon!.hexQArray + q][cameraTile.hexagon!
  //             .hexRArray + r]!.renderHexagon(canvas);
  //       }
  //     }
  //   }
  // }
  // testing New draw approach. the rhombus gives too many hexes.
  // We draw from the bottom left to the right
  // and then upwards till the whole screen is filled.
  List<int> tileProperties = getTileFromPos(screen.left, screen.bottom, 0);
  int q = tileProperties[0];
  int r = tileProperties[1];
  int s = tileProperties[2];

  // print("q: $q  r: $r  s: $s");
  int qArray = q + (hexagonList.tiles.length / 2).ceil();
  int rArray = r + (hexagonList.tiles[0].length / 2).ceil();
  if (qArray >= 0 && qArray < hexagonList.tiles.length && rArray >= 0 && rArray < hexagonList.tiles[0].length) {
    Tile2? test = hexagonList.tiles[qArray][rArray];
    int hexQ = test!.hexagon!.hexQArray;
    int hexR = test.hexagon!.hexRArray;
    hexagonList.hexagons[hexQ][hexR]!.renderHexagon(canvas);

    double hexX = hexagonList.hexagons[hexQ][hexR]!.getPos(0).x;
    int q_add = 1;
    while (hexX < screen.right) {
    // while (hexX < screen.right - 400) {
      hexagonList.hexagons[hexQ+q_add][hexR]!.renderHexagon(canvas);
      hexX = hexagonList.hexagons[hexQ+q_add][hexR]!.getPos(0).x;
      q_add += 1;
    }
    double hexY = hexagonList.hexagons[hexQ][hexR]!.getPos(0).y;
    int offset = 1;
    while (hexY > screen.top) {
      if (offset == 0) {
        hexQ += 1;
        hexR -= 1;
        offset = 1;
      } else {
        offset = 0;
        hexR -= 1;
      }
      hexagonList.hexagons[hexQ][hexR]!.renderHexagon(canvas);
      hexY = hexagonList.hexagons[hexQ][hexR]!.getPos(0).y;

      q_add = 1;
      hexX = hexagonList.hexagons[hexQ][hexR]!.getPos(0).x;
      while (hexX < screen.right) {
      // while (hexX < screen.right - 400) {
        hexagonList.hexagons[hexQ+q_add][hexR]!.renderHexagon(canvas);
        hexX = hexagonList.hexagons[hexQ+q_add][hexR]!.getPos(0).x;
        q_add += 1;
      }
    }
  }
}

updateMain(int rotate, int currentVariant, Tile2 cameraTile, List<List<Hexagon?>> hexagons) {
  if (cameraTile.hexagon != null) {
    if (hexagons[cameraTile.hexagon!.hexQArray][cameraTile.hexagon!.hexRArray] != null) {
      hexagons[cameraTile.hexagon!.hexQArray][cameraTile.hexagon!.hexRArray]!.updateHexagon(rotate, currentVariant);
    }
  }
}

updateHexagons(int rotate, int currentVariant, Tile2 cameraTile, List<List<Hexagon?>> hexagons, Rect screen) {
  if (cameraTile.hexagon != null) {
    for (int q = -3; q < 3; q++) {
      for (int r = -3; r < 3; r++) {
        // We should exclude some so that we get the hexagon tiling
        if (hexagons[cameraTile.hexagon!.hexQArray + q][cameraTile.hexagon!.hexRArray + r] != null) {
          hexagons[cameraTile.hexagon!.hexQArray + q][cameraTile.hexagon!.hexRArray + r]!.updateHexagon(rotate, currentVariant);
        }
      }
    }
  }
}