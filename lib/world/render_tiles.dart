import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../component/tile.dart';


renderTilesFlat(List<List<Tile?>> tiles, double xSize, double ySize, Canvas canvas, Sprite waterSprite, Sprite dirtSprite, Sprite grassSprite, double left, double right, double top, double bottom) {

  for (int q = -(tiles.length/2).ceil(); q < (tiles.length/2).floor(); q++) {
    for (int r = -(tiles[0].length/2).ceil(); r < (tiles[0].length/2).floor(); r++) {
      int qArray = q + (tiles.length/2).ceil();
      int rArray = r + (tiles[0].length/2).ceil();
      if (tiles[qArray][rArray] != null) {
        if (tiles[qArray][rArray]!.getPosFlat().x > left &&
            tiles[qArray][rArray]!.getPosFlat().x < right) {
          if (tiles[qArray][rArray]!.getPosFlat().y > top &&
              tiles[qArray][rArray]!.getPosFlat().y < bottom) {
            if (tiles[qArray][rArray]!.getTileProperty() == 0) {
              waterSprite.render(canvas,
                  position: tiles[qArray][rArray]!.getPosFlat(),
                  size: Vector2(2 * xSize, sqrt(3) * ySize)
              );
            } else if (tiles[qArray][rArray]!.getTileProperty() == 1) {
              dirtSprite.render(canvas,
                  position: tiles[qArray][rArray]!.getPosFlat(),
                  size: Vector2(2 * xSize, sqrt(3) * ySize)
              );
            } else {
              grassSprite.render(canvas,
                  position: tiles[qArray][rArray]!.getPosFlat(),
                  size: Vector2(2 * xSize, sqrt(3) * ySize)
              );
            }
          }
        }
      }
    }
  }
}

renderTilesPoint(List<List<Tile?>> tiles, double xSize, double ySize, Canvas canvas, Sprite waterSprite, Sprite dirtSprite, Sprite grassSprite, double left, double right, double top, double bottom) {
  for (int q = -(tiles.length/2).ceil(); q < (tiles.length/2).floor(); q++) {
    for (int r = -(tiles[0].length/2).ceil(); r < (tiles[0].length/2).floor(); r++) {
      int qArray = q + (tiles.length/2).ceil();
      int rArray = r + (tiles[0].length/2).ceil();
      if (tiles[qArray][rArray] != null) {
        if (tiles[qArray][rArray]!.getPosPoint().x > left &&
            tiles[qArray][rArray]!.getPosPoint().x < right) {
          if (tiles[qArray][rArray]!.getPosPoint().y > top &&
              tiles[qArray][rArray]!.getPosPoint().y < bottom) {
            if (tiles[qArray][rArray]!.getTileProperty() == 0) {
              waterSprite.render(canvas,
                  position: tiles[qArray][rArray]!.getPosPoint(),
                  size: Vector2(sqrt(3) * xSize, 2 * ySize)
              );
            } else if (tiles[qArray][rArray]!.getTileProperty() == 1) {
              dirtSprite.render(canvas,
                  position: tiles[qArray][rArray]!.getPosPoint(),
                  size: Vector2(sqrt(3) * xSize, 2 * ySize)
              );
            } else {
              grassSprite.render(canvas,
                  position: tiles[qArray][rArray]!.getPosPoint(),
                  size: Vector2(sqrt(3) * xSize, 2 * ySize)
              );
            }
          }
        }
      }
    }
  }
}