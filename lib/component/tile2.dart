import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/input.dart';

class Tile2 extends SpriteComponent with HasGameRef {

  late double xPos;
  late int xCoordinate;
  late double yPos;
  late int yCoordinate;

  double xSize;
  double ySize;

  Tile2(this.xCoordinate, this.yCoordinate, this.xSize, this.ySize)
      : super(
    size: Vector2(2 * xSize, (sqrt(3) * ySize))
  );


  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('grassTest3.png');

    xPos = (xCoordinate * (2 * xSize) * 3/4);
    double addedY = xCoordinate * ySize * sqrt(3) / 2;
    yPos = (yCoordinate * sqrt(3) * ySize) - addedY;

    position = Vector2(xPos, yPos);
  }

  Vector2 pointyHexCorner(double i) {
    double angleDeg = 60 * i;
    double angleRad = pi/180 * angleDeg;
    double pointX = (xSize * cos(angleRad)) + xSize;
    double pointY = (ySize * sin(angleRad)) + ((sqrt(3) * ySize) / 2);
    return Vector2(pointX, pointY);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    Paint paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.color = Color.fromRGBO(255, 0, 0, 1.0);

    Vector2 point1 = pointyHexCorner(0);
    Vector2 point2 = pointyHexCorner(1);
    Vector2 point3 = pointyHexCorner(2);
    Vector2 point4 = pointyHexCorner(3);
    Vector2 point5 = pointyHexCorner(4);
    Vector2 point6 = pointyHexCorner(5);
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
    canvas.drawRawPoints(PointMode.polygon, points, paint);
  }
}