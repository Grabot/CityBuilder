import 'dart:async';
import 'package:city_builder/component/tile.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';


class CityBuilder extends FlameGame with HasCollidables {
  @override
  Future<void> onLoad() async {
    unawaited(add(Tile(position: size / 2, size: Vector2.all(20))));

    return super.onLoad();
  }
}