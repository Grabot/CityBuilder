import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flame/components.dart';
import '../component/tile.dart';

// Don't forget to update these size if you update the sizes in the tile object.
double xSize = 16;
double ySize = 8;

Vector2 pointyHexCorner(double i, Vector2 center, int rotate) {
  double angleDeg = 60 * i;
  if (rotate == 1 || rotate == 3) {
    angleDeg = 60 * i - 30;
  }
  double angleRad = pi/180 * angleDeg;
  double pointX = center.x + (xSize * cos(angleRad)) + xSize;
  double pointY = center.y + (ySize * sin(angleRad)) + ySize;
  return Vector2(pointX, pointY);
}

tileSelected(Tile selectedTile, int rotate, Canvas canvas) {
  Vector2 point1 = pointyHexCorner(0, selectedTile.getPos(rotate), rotate);
  Vector2 point2 = pointyHexCorner(1, selectedTile.getPos(rotate), rotate);
  Vector2 point3 = pointyHexCorner(2, selectedTile.getPos(rotate), rotate);
  Vector2 point4 = pointyHexCorner(3, selectedTile.getPos(rotate), rotate);
  Vector2 point5 = pointyHexCorner(4, selectedTile.getPos(rotate), rotate);
  Vector2 point6 = pointyHexCorner(5, selectedTile.getPos(rotate), rotate);

  var points = Float32List.fromList(
      [
        point1.x, point1.y,
        point2.x, point2.y,
        point3.x, point3.y,
        point4.x, point4.y,
        point5.x, point5.y,
        point6.x, point6.y,
        point1.x, point1.y
      ]);

  Paint selectedPaint = Paint();
  selectedPaint.style = PaintingStyle.fill;
  selectedPaint.color = const Color.fromRGBO(255, 0, 0, 1.0);

  canvas.drawRawPoints(
      PointMode.polygon,
      points,
      selectedPaint);
}