import 'dart:math';
import 'dart:ui';

import 'package:city_builder/component/tile.dart';
import 'package:flame/components.dart';

class World extends Component with HasGameRef {

  final double xSize = 40;
  final double ySize = 40;

  late List<List<Tile?>> tiles;

  World() : super();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    tiles = List.generate(
        200,
        (_) => List.filled(200, null),
        growable: false);

    for (int q = -5; q <= 5; q++) {
      for (int r = -5; r <= 5; r++) {
        int s = (q + r) * -1;
        Tile tile = Tile(q, r, s, xSize, ySize);
        int qArray = q + 100;
        int rArray = r + 100;
        tiles[qArray][rArray] = tile;
      }
    }
    // tiles[97][97] = null;
    // tiles[98][97] = null;
    // tiles[97][98] = null;
    // tiles[99][97] = null;
    // tiles[98][98] = null;
    // tiles[97][99] = null;
    //
    // tiles[103][103] = null;
    // tiles[102][103] = null;
    // tiles[103][102] = null;
    // tiles[101][103] = null;
    // tiles[102][102] = null;
    // tiles[103][101] = null;

    for(int q = 0; q < tiles.length; q++) {
      for(int r = 0; r < tiles[q].length; r++) {
        if (tiles[q][r] != null) {
          add(tiles[q][r]!);
        }
      }
    }
  }

  void tappedWorld(double mouseX, double mouseY) {
    for (int q = -5; q <= 5; q++) {
      for (int r = -5; r <= 5; r++) {
        int qArray = q + 100;
        int rArray = r + 100;
        if (tiles[qArray][rArray] != null) {
          tiles[qArray][rArray]!.setSelected(false);
        }
      }
    }
    double xTranslate = (2/3 * mouseX);
    double qDetailed = xTranslate / xSize;
    double yTranslate = (-1/3 * mouseX) + (sqrt(3) / 3 * mouseY);
    double rDetailed = yTranslate / ySize;
    double sDetailed = (qDetailed + rDetailed) * -1;

    int q = qDetailed.round();
    int r = rDetailed.round();
    int s = sDetailed.round();

    var qDiff = (q - qDetailed).abs();
    var rDiff = (r - rDetailed).abs();
    var sDiff = (s - sDetailed).abs();

    if (qDiff > rDiff && qDiff > sDiff) {
      q = -r - s;
    } else if (rDiff > sDiff) {
      r = -q - s;
    } else {
      s = -q - r;
    }

    tiles[q+100][r+100]!.setSelected(true);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }
}