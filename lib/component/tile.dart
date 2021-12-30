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
}