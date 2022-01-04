import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flame/components.dart';


class TileTemp extends SpriteComponent with HasGameRef {

  late double xPos;
  late double yPos;
  late int q;
  late int r;
  late int s;

  double xSize;
  double ySize;

  bool selected = false;

  // We assume the condition r + s + q = 0 is true.
  TileTemp(this.q, this.r, this.s, this.xSize, this.ySize)
      : super(
      size: Vector2(2 * xSize, (sqrt(3) * ySize))
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('grassTest3.png');
    xPos = xSize * 3/2 * q;
    yPos = ySize * (sqrt(3)/2 * q + sqrt(3) * r);

    // We want to center 0, 0 in the middle of the tile. so we subtract the size
    position = Vector2(xPos - xSize, yPos - ySize);
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
    paint.color = const Color.fromRGBO(255, 0, 0, 1.0);

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
    if (selected) {
      canvas.drawRawPoints(PointMode.polygon, points, paint);
    }
  }

  void setSelected(bool selected) {
    this.selected = selected;
  }

  Vector2 getPos() {
    return Vector2(xPos, yPos);
  }

}