import 'dart:ui';

import 'package:flame/components.dart';
import 'package:city_builder/component/tile.dart';

class World extends Component with HasGameRef {

  final Tile _tile1 = Tile(0.0, 0.0);
  final Tile _tile2 = Tile(50.0, 0.0);
  final Tile _tile3 = Tile(100.0, 0.0);
  final Tile _tile4 = Tile(0.0, 50.0);
  final Tile _tile5 = Tile(50.0, 50.0);
  final Tile _tile6 = Tile(100.0, 50.0);
  final Tile _tile7 = Tile(0.0, 100.0);
  final Tile _tile8 = Tile(50.0, 100.0);
  final Tile _tile9 = Tile(100.0, 100.0);
  final Tile _tile10 = Tile(1000.0, 0.0);
  final Tile _tile11 = Tile(1000.0, 1000.0);
  final Tile _tile12 = Tile(0.0, 1000.0);

  World()
      : super(
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(_tile1);
    add(_tile2);
    add(_tile3);
    add(_tile4);
    add(_tile5);
    add(_tile6);
    add(_tile7);
    add(_tile8);
    add(_tile9);
    add(_tile10);
    add(_tile11);
    add(_tile12);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}