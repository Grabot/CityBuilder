import 'dart:math';
import 'dart:ui';

import 'package:city_builder/component/tile2.dart';
import 'package:flame/components.dart';
import 'package:city_builder/component/tile.dart';

class World extends Component with HasGameRef {

  final double xSize = 50;
  final double ySize = 50 * (3 / 4);
  // final double ySize = 50;

  World()
      : super(
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(Tile2(-3, 3, 0, xSize, ySize));
    add(Tile2(-2, 2, 0, xSize, ySize));
    add(Tile2(-1, 1, 0, xSize, ySize));
    add(Tile2(0, 0, 0, xSize, ySize));
    add(Tile2(1, -1, 0, xSize, ySize));
    add(Tile2(2, -2, 0, xSize, ySize));
    add(Tile2(3, -3, 0, xSize, ySize));
    add(Tile2(0, -3, 3, xSize, ySize));
    add(Tile2(0, -2, 2, xSize, ySize));
    add(Tile2(0, -1, 1, xSize, ySize));
    add(Tile2(0, 1, -1, xSize, ySize));
    add(Tile2(0, 2, -2, xSize, ySize));
    add(Tile2(0, 3, -3, xSize, ySize));
    add(Tile2(-3, 0, 3, xSize, ySize));
    add(Tile2(-2, 0, 2, xSize, ySize));
    add(Tile2(-1, 0, 1, xSize, ySize));
    add(Tile2(1, 0, -1, xSize, ySize));
    add(Tile2(2, 0, -2, xSize, ySize));
    add(Tile2(3, 0, -3, xSize, ySize));

    add(Tile2(-2, -1, 3, xSize, ySize));
    add(Tile2(-1, -2, 3, xSize, ySize));
    add(Tile2(-1, -1, 2, xSize, ySize));

    add(Tile2(-3, 1, 2, xSize, ySize));
    add(Tile2(-3, 2, 1, xSize, ySize));
    add(Tile2(-2, 1, 1, xSize, ySize));

    add(Tile2(-1, 3, -2, xSize, ySize));
    add(Tile2(-2, 3, -1, xSize, ySize));
    add(Tile2(-1, 2, -1, xSize, ySize));

    add(Tile2(1, 2, -3, xSize, ySize));
    add(Tile2(2, 1, -3, xSize, ySize));
    add(Tile2(1, 1, -2, xSize, ySize));

    add(Tile2(3, -2, -1, xSize, ySize));
    add(Tile2(3, -1, -2, xSize, ySize));
    add(Tile2(2, -1, -1, xSize, ySize));

    add(Tile2(2, -3, 1, xSize, ySize));
    add(Tile2(1, -3, 2, xSize, ySize));
    add(Tile2(1, -2, -1, xSize, ySize));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}