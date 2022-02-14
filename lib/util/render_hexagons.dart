
import 'dart:ui';

import 'package:city_builder/component/hexagon.dart';
import 'package:city_builder/component/tile2.dart';

renderHexagons(Canvas canvas, Tile2 cameraTile, List<List<Hexagon?>> hexagons) {

  if (cameraTile.hexagon != null) {
    for (int q = -3; q < 3; q++ ) {
      for (int r = -3; r < 3; r++ ) {
        if (hexagons[cameraTile.hexagon!.hexQArray + q][cameraTile.hexagon!
            .hexRArray + r] != null) {
          hexagons[cameraTile.hexagon!.hexQArray + q][cameraTile.hexagon!
              .hexRArray + r]!.renderHexagon(canvas);
        }
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