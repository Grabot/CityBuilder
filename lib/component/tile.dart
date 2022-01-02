import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/input.dart';

class Tile extends SpriteComponent with HasGameRef {

  late double xPos;
  late double yPos;

  Tile(this.xPos, this.yPos)
      : super(
    size: Vector2.all(50.0)
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('grass1.png');
    position = Vector2(xPos, yPos);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    Paint paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.color = Color.fromRGBO(255, 0, 0, 1.0);
    double a = 25.0;
    var points = Float32List.fromList(
        [
          a, 0.0,
          a/2, -sqrt(3)*a/2,
          -a/2, -sqrt(3)*a/2,
          -a, 0.0,
          -a/2, sqrt(3)*a/2,
          a/2, sqrt(3)*a/2,
          a, 0.0
        ]);
    canvas.drawRawPoints(PointMode.polygon, points, paint);
  }
}