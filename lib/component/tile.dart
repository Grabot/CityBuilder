import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';

class Tile {

  late Vector2 positionFlat;
  late Vector2 positionPoint;
  late int q;
  late int r;
  late int s;

  double xSize = 16;
  double ySize = 8;

  late Sprite spriteFlat;
  late Sprite spritePoint;
  // We assume the condition r + s + q = 0 is true.
  Tile(this.q, this.r, this.s) {
    double xPosFlat = xSize * 3 / 2 * q - xSize;
    double yTr1 = ySize * (sqrt(3) / 2 * q);
    yTr1 *= -1; // The y axis gets positive going down, so we flip it.
    double yTr2 = ySize * (sqrt(3) * r);
    yTr2 *= -1; // The y axis gets positive going down, so we flip it.
    double yPosFlat = yTr1 + yTr2 - ySize;
    positionFlat = Vector2(xPosFlat, yPosFlat);

    double xPosPoint = xSize * (sqrt(3) * q + sqrt(3) / 2 * r) - xSize;
    double yPosPoint = ySize * 3 / 2 * r;
    yPosPoint *= -1;
    yPosPoint -= ySize;
    // We only have to update the sprites and position for the points.
    positionPoint = Vector2(xPosPoint, yPosPoint);
  }

  Vector2 getPos(int rotate) {
    if (rotate == 0) {
      return Vector2(positionFlat.x, positionFlat.y);
    } else if (rotate == 1) {
      return Vector2(-positionFlat.y * 2, positionFlat.x / 2);
    } else if (rotate == 2) {
      return Vector2(-positionFlat.x, -positionFlat.y);
    } else {
      return Vector2(positionFlat.y * 2, -positionFlat.x / 2);
    }
  }

  // size = 16.
  // flat
  // width = 2 * size
  // height = sqrt(3) * size / 2   divided by 2 to give the isometric view
  // point
  // width = sqrt(3) * size
  // height = 2 * size / 2   divided by 2 to give the isometric view
  Vector2 getSize(int rotate) {
    if (rotate == 0 || rotate == 2) {
      return Vector2(2 * xSize, sqrt(3) * ySize);
    } else {
      return Vector2(sqrt(3) * xSize, 2 * ySize);
    }
  }

  renderTile(Canvas canvas, int rotate) {
  }

  setSpriteFlat(Sprite sprite) {
  }

  setSpritePoint(Sprite sprite) {
  }
}