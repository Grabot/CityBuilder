import 'dart:math';
import 'dart:ui';

import 'package:city_builder/component/tile2.dart';
import 'package:flame/components.dart';
import 'package:city_builder/component/tile.dart';

class World extends Component with HasGameRef {

  final double xSize = 50;
  // final double ySize = 50 * (3 / 4);
  final double ySize = 50;

  World()
      : super(
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    add(Tile2(0, 0, xSize, ySize));
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}