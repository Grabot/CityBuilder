import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/input.dart';

class Tile {

  late Vector2 positionFlat;
  late Vector2 positionPoint;
  late int q;
  late int r;
  late int s;

  // size = 16.
  // flat
  // width = 2 * size
  // height = sqrt(3) * size / 2   divided by 2 to give the isometric view
  // point
  // width = sqrt(3) * size
  // height = 2 * size / 2   divided by 2 to give the isometric view
  double xSizeFlat = 32;
  double ySizeFlat = sqrt(3) * 16 / 2;
  double xSizePoint = sqrt(3) * 16;
  double ySizePoint = 16;

  // We assume the condition r + s + q = 0 is true.
  Tile(this.q, this.r, this.s) {
    double xPosFlat = xSizeFlat * 3 / 2 * q - xSizeFlat;
    double yTr1 = ySizeFlat * (sqrt(3) / 2 * q);
    yTr1 *= -1; // The y axis gets positive going down, so we flip it.
    double yTr2 = ySizeFlat * (sqrt(3) * r);
    yTr2 *= -1; // The y axis gets positive going down, so we flip it.
    double yPosFlat = yTr1 + yTr2 - ySizeFlat;
    positionFlat = Vector2(xPosFlat, yPosFlat);

    double xPosPoint = xSizePoint * (sqrt(3) * q + sqrt(3) / 2 * r) - xSizePoint;
    double yPosPoint = ySizePoint * 3 / 2 * r;
    yPosPoint *= -1;
    yPosPoint -= ySizePoint;
    // We only have to update the sprites and position for the points.
    positionPoint = Vector2(xPosPoint, yPosPoint);
  }

  Vector2 getPos(int rotate) {
    if (rotate == 0) {
      return positionFlat;
    } else if (rotate == 1) {
      return positionPoint;
    } else if (rotate == 2) {
      return Vector2(-positionFlat.x, -positionFlat.y);
    } else {
      return Vector2(-positionPoint.x, -positionPoint.y);
    }
  }

  double getXSize(int rotate) {
    if (rotate == 0 || rotate == 2) {
      return xSizeFlat;
    } else {
      return xSizePoint;
    }
  }

  double getYSize(int rotate) {
    if (rotate == 0 || rotate == 2) {
      return ySizeFlat;
    } else {
      return ySizePoint;
    }
  }

  renderTile(Canvas canvas, int rotate) {
  }

  setSpriteFlat(Sprite sprite) {
  }

  setSpritePoint(Sprite sprite) {
  }
}