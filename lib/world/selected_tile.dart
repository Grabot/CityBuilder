import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flame/components.dart';
import '../component/tile.dart';



Vector2 pointyHexCornerFlat(double i, Vector2 center, double xSize, double ySize) {
  double angleDeg = 60 * i;
  double angleRad = pi/180 * angleDeg;
  double pointX = center.x + (xSize * cos(angleRad)) + xSize;
  double pointY = center.y + (ySize * sin(angleRad)) + ySize;
  return Vector2(pointX, pointY);
}

Vector2 pointyHexCornerTop(double i, Vector2 center, double xSize, double ySize) {
  double angleDeg = 60 * i - 30;
  double angleRad = pi/180 * angleDeg;
  double pointX = center.x + (xSize * cos(angleRad)) + xSize;
  double pointY = center.y + (ySize * sin(angleRad)) + ySize;
  return Vector2(pointX, pointY);
}

tileSelected(Tile selectedTile, double xSize, double ySize, int rotate, Canvas canvas) {
  Vector2 point1 = Vector2.zero();
  Vector2 point2 = Vector2.zero();
  Vector2 point3 = Vector2.zero();
  Vector2 point4 = Vector2.zero();
  Vector2 point5 = Vector2.zero();
  Vector2 point6 = Vector2.zero();
  if (rotate == 0) {
    point1 = pointyHexCornerFlat(0, selectedTile.getPosFlat(), xSize, ySize);
    point2 = pointyHexCornerFlat(1, selectedTile.getPosFlat(), xSize, ySize);
    point3 = pointyHexCornerFlat(2, selectedTile.getPosFlat(), xSize, ySize);
    point4 = pointyHexCornerFlat(3, selectedTile.getPosFlat(), xSize, ySize);
    point5 = pointyHexCornerFlat(4, selectedTile.getPosFlat(), xSize, ySize);
    point6 = pointyHexCornerFlat(5, selectedTile.getPosFlat(), xSize, ySize);
  } else if (rotate == 1) {
    point1 = pointyHexCornerTop(0, selectedTile.getPosPoint(), xSize, ySize);
    point2 = pointyHexCornerTop(1, selectedTile.getPosPoint(), xSize, ySize);
    point3 = pointyHexCornerTop(2, selectedTile.getPosPoint(), xSize, ySize);
    point4 = pointyHexCornerTop(3, selectedTile.getPosPoint(), xSize, ySize);
    point5 = pointyHexCornerTop(4, selectedTile.getPosPoint(), xSize, ySize);
    point6 = pointyHexCornerTop(5, selectedTile.getPosPoint(), xSize, ySize);
  }
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