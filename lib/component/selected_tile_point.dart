import 'dart:math';
import 'package:city_builder/component/map_quadrant.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

class SelectedTilePoint extends SpriteComponent with HasGameRef {

  bool show = false;

  SelectedTilePoint()
      : super(
      size: Vector2(sqrt(3) * 17, 2 * 8)
  );


  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('point_selection.png');
    position = Vector2(-17, -8);
  }

  setPosition(Vector2 tilePos) {
    position = tilePos;
  }

  @override
  void render(Canvas canvas) {
    if (show) {
      super.render(canvas);
    }
  }
}