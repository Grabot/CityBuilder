import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:city_builder/component/tile_temp.dart';
import 'package:flame/components.dart';
import '../component/tile.dart';

class World extends Component with HasGameRef {

  final double xSize = 32;
  final double ySize = 16;

  late List<List<TileTemp?>> tiles;
  late List<List<Tile?>> tilesTest;
  Tile? selectedTile;

  World() : super();

  late Sprite grassSprite;

  Paint selectedPaint = Paint();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    selectedPaint.style = PaintingStyle.fill;
    selectedPaint.color = const Color.fromRGBO(255, 0, 0, 1.0);

    grassSprite = await gameRef.loadSprite('tile_test_3.png');

    tiles = List.generate(
        2000,
        (_) => List.filled(2000, null),
        growable: false);
    tilesTest = List.generate(
        2000,
            (_) => List.filled(2000, null),
        growable: false);

    for (int q = -16; q <= -6; q++) {
      for (int r = -16; r <= 6; r++) {
        int s = (q + r) * -1;
        // double xPos = xSize * 3/2 * q;
        // double yPos = ySize * (sqrt(3)/2 * q + sqrt(3) * r);
        TileTemp tile = TileTemp(q, r, s, xSize, ySize);

        int qArray = q + 1000;
        int rArray = r + 1000;
        tiles[qArray][rArray] = tile;
        add(tile);
      }
    }
    // TileTemp tile = TileTemp(0, 0, 0, xSize, ySize);
    // tiles[1000][1000] = tile;
    // add(tile);

    for (int q = -800; q <= 800; q++) {
      for (int r = -800; r <= 800; r++) {
        int s = (q + r) * -1;
        if (q == 0) {
          double xPos = xSize * 3 / 2 * q - xSize;
          // double yPos = 0 - ySize * (sqrt(3) / 2 * q - sqrt(3) * r) - ySize;
          double yPos = ySize * (sqrt(3) / 2 * q - sqrt(3) * r) - ySize;
          Vector2 position = Vector2(xPos, yPos);
          Tile tile = Tile(q, r, s, position);
          int qArray = q + 1000;
          int rArray = r + 1000;
          tilesTest[qArray][rArray] = tile;
        }
      }
    }
  }

  void tappedWorld(double mouseX, double mouseY) {
    double xTranslate = (2/3 * mouseX);
    double qDetailed = xTranslate / xSize;
    double yTranslate1 = (-1/3 * mouseX);
    double yTranslate2 = (sqrt(3) / 3 * mouseY);
    double rDetailed = (yTranslate1 / xSize) + (yTranslate2 / ySize);
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

    if (tiles[q+1000][r+1000] != null) {
      tiles[q+1000][r+1000]!.setSelected(true);
    }
    if (tilesTest[q+1000][r+1000] != null) {
      selectedTile = tilesTest[q+1000][r+1000];
    }
  }

  void clearSelectedTile() {
    selectedTile = null;
  }

  Vector2 pointyHexCorner(double i, Vector2 center) {
    double angleDeg = 60 * i;
    double angleRad = pi/180 * angleDeg;
    double pointX = center.x + (xSize * cos(angleRad)) + xSize;
    double pointY = center.y + (ySize * sin(angleRad)) + ySize;
    return Vector2(pointX, pointY);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    for (int q = -6; q <= 6; q++) {
      for (int r = -6; r <= 6; r++) {
        if (tilesTest[q+1000][r+1000] != null) {
          grassSprite.render(
              canvas,
              position: tilesTest[q + 1000][r + 1000]!.getPos(),
              size: Vector2(2 * xSize, (sqrt(3) * ySize))
          );
        }
      }
    }

    if (selectedTile != null) {
      Vector2 point1 = pointyHexCorner(0, selectedTile!.getPos());
      Vector2 point2 = pointyHexCorner(1, selectedTile!.getPos());
      Vector2 point3 = pointyHexCorner(2, selectedTile!.getPos());
      Vector2 point4 = pointyHexCorner(3, selectedTile!.getPos());
      Vector2 point5 = pointyHexCorner(4, selectedTile!.getPos());
      Vector2 point6 = pointyHexCorner(5, selectedTile!.getPos());
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
      canvas.drawRawPoints(
          PointMode.polygon,
          points,
          selectedPaint);
    }
  }
}