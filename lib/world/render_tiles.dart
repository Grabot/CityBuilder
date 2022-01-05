import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../component/tile.dart';


renderTilesFlat(List<List<Tile?>> tiles, double xSize, double ySize, int qSizeHalf, int rSizeHalf, Canvas canvas, Sprite tileSprite, double left, double right, double top, double bottom) {
  for (int q = -qSizeHalf; q <= qSizeHalf - 1; q++) {
    for (int r = -rSizeHalf; r <= rSizeHalf - 1; r++) {
      if (tiles[q + qSizeHalf][r + rSizeHalf] != null) {
        if (tiles[q + qSizeHalf][r + rSizeHalf]!.getPosFlat().x > left &&
            tiles[q + qSizeHalf][r + rSizeHalf]!.getPosFlat().x < right) {
          if (tiles[q + qSizeHalf][r + rSizeHalf]!.getPosFlat().y > top &&
              tiles[q + qSizeHalf][r + rSizeHalf]!.getPosFlat().y < bottom) {
            tileSprite.render(canvas,
                position: tiles[q + qSizeHalf][r + rSizeHalf]!.getPosFlat(),
                size: Vector2(2 * xSize, sqrt(3) * ySize)
            );
          }
        }
      }
    }
  }
}

renderTilesPoint(List<List<Tile?>> tiles, double xSize, double ySize, int qSizeHalf, int rSizeHalf, Canvas canvas, Sprite tileSprite, double left, double right, double top, double bottom) {
  for (int q = -qSizeHalf; q <= qSizeHalf - 1; q++) {
    for (int r = -rSizeHalf; r <= rSizeHalf - 1; r++) {
      if (tiles[q + qSizeHalf][r + rSizeHalf] != null) {
        if (tiles[q + qSizeHalf][r + rSizeHalf]!.getPosPoint().x > left &&
            tiles[q + qSizeHalf][r + rSizeHalf]!.getPosPoint().x < right) {
          if (tiles[q + qSizeHalf][r + rSizeHalf]!.getPosPoint().y > top &&
              tiles[q + qSizeHalf][r + rSizeHalf]!.getPosPoint().y < bottom) {
            tileSprite.render(canvas,
                position: tiles[q + qSizeHalf][r + rSizeHalf]!.getPosPoint(),
                size: Vector2(sqrt(3) * xSize, 2 * ySize)
            );
          }
        }
      }
    }
  }
}