
import 'dart:ui';

import 'package:city_builder/component/hexagon.dart';
import 'package:city_builder/component/tile2.dart';
import 'package:city_builder/util/hexagon_list.dart';
import 'package:city_builder/util/tapped_map.dart';
import 'package:flame/components.dart';

renderHexagons(Canvas canvas, Vector2 camera, HexagonList hexagonList, Rect screen) {
  List<int> tileProperties = getTileFromPos(camera.x, camera.y, 0);
  int q = tileProperties[0];
  int r = tileProperties[1];
  int s = tileProperties[2];

  int qArray = q + (hexagonList.tiles.length / 2).ceil();
  int rArray = r + (hexagonList.tiles[0].length / 2).ceil();
  if (qArray >= 0 && qArray < hexagonList.tiles.length && rArray >= 0 && rArray < hexagonList.tiles[0].length) {
    Tile2? cameraTile = hexagonList.tiles[qArray][rArray];
    // We assume there will be a tile in the center of the screen
    drawField(hexagonList, cameraTile!.hexagon!.hexQArray, cameraTile.hexagon!.hexRArray, screen, canvas, false, 0);
  }
}

drawField(HexagonList hexagonList, hexQ, hexR, Rect screen, Canvas? canvas, bool update, int variation) {
  // int hexQ = cameraTile!.hexagon!.hexQArray;
  // int hexR = cameraTile.hexagon!.hexRArray;
  if (hexQ >= 0 && hexQ < hexagonList.hexagons.length && hexR >= 0 &&
      hexR < hexagonList.hexagons[0].length && hexagonList.hexagons[hexQ][hexR] != null) {
    if (update) {
      hexagonList.hexagons[hexQ][hexR]!.updateHexagon(0, variation);
    } else {
      hexagonList.hexagons[hexQ][hexR]!.renderHexagon(canvas!);
    }
  }
  goRight(hexagonList, hexQ, hexR, screen, canvas, update, variation);
  goLeft(hexagonList, hexQ, hexR, screen, canvas, update, variation);

  // go up
  double hexY = hexagonList.hexagons[hexQ][hexR]!.getPos(0).y;
  int offset = 1;
  int q_add = 0;
  int r_add = 0;
  while (hexY > screen.top+hexagonList.halfHeightHex) {
    if (offset == 0) {
      q_add += 1;
      r_add -= 1;
      offset = 1;
    } else {
      offset = 0;
      r_add -= 1;
    }
    if ((hexQ + q_add) >= 0 && (hexQ + q_add) < hexagonList.hexagons.length && (hexR + r_add) >= 0 &&
        (hexR + r_add) < hexagonList.hexagons[0].length &&
        hexagonList.hexagons[hexQ+ q_add][hexR + r_add] != null) {
      if (update) {
        hexagonList.hexagons[hexQ + q_add][hexR + r_add]!.updateHexagon(0, variation);
      } else {
        hexagonList.hexagons[hexQ + q_add][hexR + r_add]!.renderHexagon(canvas!);
      }
      hexY = hexagonList.hexagons[hexQ + q_add][hexR + r_add]!.getPos(0).y;
    } else {
      break;
    }
    goRight(hexagonList, hexQ + q_add, hexR + r_add, screen, canvas, update, variation);
    goLeft(hexagonList, hexQ + q_add, hexR + r_add, screen, canvas, update, variation);

  }

  // go down
  hexY = hexagonList.hexagons[hexQ][hexR]!.getPos(0).y;
  offset = 1;
  q_add = 0;
  r_add = 0;
  while (hexY < screen.bottom-hexagonList.halfHeightHex) {
    if (offset == 0) {
      q_add -= 1;
      r_add += 1;
      offset = 1;
    } else {
      offset = 0;
      r_add += 1;
    }
    if ((hexQ + q_add) >= 0 && (hexQ + q_add) < hexagonList.hexagons.length && (hexR + r_add) >= 0 &&
        (hexR + r_add) < hexagonList.hexagons[0].length &&
        hexagonList.hexagons[hexQ+ q_add][hexR + r_add] != null) {
      if (update) {
        hexagonList.hexagons[hexQ + q_add][hexR + r_add]!.updateHexagon(0, variation);
      } else {
        hexagonList.hexagons[hexQ + q_add][hexR + r_add]!.renderHexagon(canvas!);
      }
      hexY = hexagonList.hexagons[hexQ + q_add][hexR + r_add]!.getPos(0).y;
    } else {
      break;
    }
    goRight(hexagonList, hexQ + q_add, hexR + r_add, screen, canvas, update, variation);
    goLeft(hexagonList, hexQ + q_add, hexR + r_add, screen, canvas, update, variation);

  }
}

goRight(HexagonList hexagonList, hexQ, hexR, Rect screen, Canvas? canvas, bool update, int variation) {
  int q_add = 1;
  double hexX = hexagonList.hexagons[hexQ][hexR]!.getPos(0).x;
  while (hexX < screen.right-hexagonList.halfWidthHex) {
    if ((hexQ + q_add) >= 0 && (hexQ + q_add) < hexagonList.hexagons.length && hexR >= 0 &&
        hexR < hexagonList.hexagons[0].length && hexagonList.hexagons[hexQ + q_add][hexR] != null) {
      if (update) {
        hexagonList.hexagons[hexQ + q_add][hexR]!.updateHexagon(0, variation);
      } else {
        hexagonList.hexagons[hexQ + q_add][hexR]!.renderHexagon(canvas!);
      }
      hexX = hexagonList.hexagons[hexQ + q_add][hexR]!.getPos(0).x;
      q_add += 1;
    }
  }
}

goLeft(HexagonList hexagonList, hexQ, hexR, Rect screen, Canvas? canvas, bool update, int variation) {
  int q_subtract = -1;
  double hexX = hexagonList.hexagons[hexQ][hexR]!.getPos(0).x;
  while (hexX > screen.left + hexagonList.halfWidthHex) {
    if ((hexQ + q_subtract) >= 0 && (hexQ + q_subtract) < hexagonList.hexagons.length && hexR >= 0 &&
        hexR < hexagonList.hexagons[0].length && hexagonList.hexagons[hexQ + q_subtract][hexR] != null) {
      if (update) {
        hexagonList.hexagons[hexQ + q_subtract][hexR]!.updateHexagon(0, variation);
      } else {
        hexagonList.hexagons[hexQ + q_subtract][hexR]!.renderHexagon(canvas!);
      }
      hexX = hexagonList.hexagons[hexQ + q_subtract][hexR]!.getPos(0).x;
      q_subtract -= 1;
    }
  }
}

updateMain(int rotate, int currentVariant, Tile2 cameraTile) {
  if (cameraTile.hexagon != null) {
    cameraTile.hexagon!.updateHexagon(rotate, currentVariant);
  }
}

updateHexagons(int rotate, int currentVariant, Vector2 cameraPos, HexagonList hexagonList, Rect screen) {
  List<int> tileProperties = getTileFromPos(cameraPos.x, cameraPos.y, 0);
  int q = tileProperties[0];
  int r = tileProperties[1];
  int s = tileProperties[2];

  int qArray = q + (hexagonList.tiles.length / 2).ceil();
  int rArray = r + (hexagonList.tiles[0].length / 2).ceil();
  if (qArray >= 0 && qArray < hexagonList.tiles.length && rArray >= 0 && rArray < hexagonList.tiles[0].length) {
    Tile2? cameraTile = hexagonList.tiles[qArray][rArray];
    drawField(hexagonList, cameraTile!.hexagon!.hexQArray, cameraTile.hexagon!.hexRArray, screen, null, true, currentVariant);
  }
}