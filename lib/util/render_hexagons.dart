
import 'dart:ui';

import 'package:city_builder/component/tile2.dart';
import 'package:city_builder/util/hexagon_list.dart';
import 'package:city_builder/util/tapped_map.dart';
import 'package:flame/components.dart';

renderHexagons(Canvas canvas, Vector2 camera, HexagonList hexagonList, Rect screen, int variation) {
  List<int> tileProperties = getTileFromPos(camera.x, camera.y, 0);
  int q = tileProperties[0];
  int r = tileProperties[1];
  int s = tileProperties[2];

  int qArray = q + (hexagonList.tiles.length / 2).ceil();
  int rArray = r + (hexagonList.tiles[0].length / 2).ceil();
  if (qArray >= 0 && qArray < hexagonList.tiles.length && rArray >= 0 && rArray < hexagonList.tiles[0].length) {
    Tile2? cameraTile = hexagonList.tiles[qArray][rArray];
    // We assume there will be a tile in the center of the screen
    // But it's possible the tile is not linked to a hexagon.
    // TODO: what to do if there is no hexagon? fix with boundaries and padding?
    if (cameraTile != null && cameraTile.hexagon != null) {
      drawField(hexagonList, cameraTile.hexagon!.hexQArray,
          cameraTile.hexagon!.hexRArray, screen, canvas, variation);
    }
  }
}

drawField(HexagonList hexagonList, hexQ, hexR, Rect screen, Canvas canvas, int variation) {

  if (hexQ >= 0 && hexQ < hexagonList.hexagons.length && hexR >= 0 &&
      hexR < hexagonList.hexagons[0].length) {

    // go up
    double hexX = hexagonList.hexagons[hexQ][hexR]!.getPos(0).x;
    double hexY = hexagonList.hexagons[hexQ][hexR]!.getPos(0).y;
    int offset = -1;
    if (hexX < 0) {
      // If the x is below 0 it is to the left of the screen, we want to move down the other way
      offset = 0;
    } else {
      offset = 1;
    }
    int qAdd = 0;
    int rAdd = 0;
    while (hexY > screen.top + hexagonList.halfHeightHex) {
      if (offset == 0) {
        qAdd += 1;
        offset = 1;
      } else {
        offset = 0;
      }
      rAdd -= 1;

      if ((hexQ + qAdd) >= 0 && (hexQ + qAdd) < hexagonList.hexagons.length
          && (hexR + rAdd) >= 0 && (hexR + rAdd) < hexagonList.hexagons[0].length) {

        if (hexagonList.hexagons[hexQ+ qAdd][hexR + rAdd] != null) {
          hexY = hexagonList.hexagons[hexQ + qAdd][hexR + rAdd]!.getPos(0).y;
        }

      } else {
        // There is no more hexagon so we go back one and draw from there.
        if (offset == 1) {
          qAdd -= 1;
        }
        rAdd += 1;
        break;
      }

    }
    // We are now at the top. Let's draw it from the top down now. (with left and right)
    hexQ = hexQ + qAdd;
    hexR = hexR + rAdd;

    // go down
    if (hexX < 0) {
      // If the x is below 0 it is to the left of the screen, we want to move down the other way
      offset = 1;
    } else {
      offset = 0;
    }
    qAdd = 0;
    rAdd = 0;
    // We check if the hexagon is outside of the screen and we also check if it cannot find any hexagons to draw (stuck in loop)
    // TODO: change the 'rAdd' check. This is bad for performance with huge maps
    while (hexY < screen.bottom - hexagonList.halfHeightHex && rAdd < hexagonList.hexagons.length) {
      if ((hexQ + qAdd) >= 0 && (hexQ + qAdd) < hexagonList.hexagons.length
          && (hexR + rAdd) >= 0 && (hexR + rAdd) < hexagonList.hexagons[0].length) {

        if (hexagonList.hexagons[hexQ+ qAdd][hexR + rAdd] != null) {
          hexagonList.hexagons[hexQ + qAdd][hexR + rAdd]!.renderHexagon(canvas, variation);

          hexY = hexagonList.hexagons[hexQ + qAdd][hexR + rAdd]!.getPos(0).y;
        }
        goRight(hexagonList, hexQ + qAdd, hexR + rAdd, screen, canvas, variation);
        goLeft(hexagonList, hexQ + qAdd, hexR + rAdd, screen, canvas, variation);
      }
      if (offset == 0) {
        qAdd -= 1;
        rAdd += 1;
        offset = 1;
      } else {
        offset = 0;
        rAdd += 1;
      }
    }
  }
}

goRight(HexagonList hexagonList, hexQ, hexR, Rect screen, Canvas canvas, int variation) {
  int qAdd = 1;
  // we initialize it to something that's definitely less than the screen right.
  double hexX = screen.left;
  if (hexagonList.hexagons[hexQ][hexR] != null) {
    hexX = hexagonList.hexagons[hexQ][hexR]!.getPos(0).x;
  }
  // TODO: change the 'qAdd' check. This is bad for performance with huge maps
  while (hexX < screen.right-hexagonList.halfWidthHex && qAdd < hexagonList.hexagons.length) {
    if ((hexQ + qAdd) >= 0 && (hexQ + qAdd) < hexagonList.hexagons.length && hexR >= 0 &&
        hexR < hexagonList.hexagons[0].length) {

      if (hexagonList.hexagons[hexQ + qAdd][hexR] != null) {
        hexagonList.hexagons[hexQ + qAdd][hexR]!.renderHexagon(canvas, variation);

        hexX = hexagonList.hexagons[hexQ + qAdd][hexR]!.getPos(0).x;
      }
      qAdd += 1;
    } else {
      break;
    }
  }
}

goLeft(HexagonList hexagonList, hexQ, hexR, Rect screen, Canvas canvas, int variation) {
  int qSubtract = -1;
  double hexX = screen.right;
  if (hexagonList.hexagons[hexQ][hexR] != null) {
    hexX = hexagonList.hexagons[hexQ][hexR]!.getPos(0).x;
  }
  // TODO: change the 'qSubtract' check. This is bad for performance with huge maps
  while (hexX > screen.left + hexagonList.halfWidthHex && qSubtract < hexagonList.hexagons.length) {
    if ((hexQ + qSubtract) >= 0 && (hexQ + qSubtract) < hexagonList.hexagons.length && hexR >= 0 &&
        hexR < hexagonList.hexagons[0].length) {

      if (hexagonList.hexagons[hexQ + qSubtract][hexR] != null) {
        hexagonList.hexagons[hexQ + qSubtract][hexR]!.renderHexagon(canvas, variation);

        hexX = hexagonList.hexagons[hexQ + qSubtract][hexR]!.getPos(0).x;
      }
      qSubtract -= 1;
    } else {
      break;
    }
  }
}
