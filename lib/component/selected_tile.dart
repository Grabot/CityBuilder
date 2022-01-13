import 'dart:math';
import 'package:city_builder/component/map_quadrant.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

class SelectedTile extends SpriteComponent with HasGameRef {

  SelectedTile()
      : super(
      size: Vector2.all(50.0)
  );


  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('flat_selection.png');
    position = Vector2(0, 0);
  }

  setPosition(Vector2 tilePos) {
    position = tilePos;
  }
}