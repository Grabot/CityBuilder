import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flame/components.dart';
import '../component/tile.dart';

class World extends Component with HasGameRef {

  final double xSize = 32;
  final double ySize = 16;

  late List<List<Tile?>> tiles;
  Tile? selectedTile;

  World() : super();

  late Sprite grassSprite;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    grassSprite = await gameRef.loadSprite('tile_test_3.png');

    tiles = List.generate(
        2000,
        (_) => List.filled(2000, null),
        growable: false);

    for (int q = -639; q <= 640; q++) {
      for (int r = -639; r <= 640; r++) {
        int s = (q + r) * -1;
        double xPos = xSize * 3/2 * q;
        double yPos = ySize * (sqrt(3)/2 * q + sqrt(3) * r);
        Tile tile = Tile(q, r, s, Vector2(xPos, yPos));

        int qArray = q + 1000;
        int rArray = r + 1000;
        tiles[qArray][rArray] = tile;
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

    if (tiles[q+100][r+100] != null) {
      selectedTile = tiles[q+100][r+100];
    }
  }

  void clearSelectedTile() {
    selectedTile = null;
  }

  Vector2 pointyHexCorner(double i) {
    double angleDeg = 60 * i;
    double angleRad = pi/180 * angleDeg;
    double pointX = (xSize * cos(angleRad)) + xSize;
    double pointY = (ySize * sin(angleRad)) + ((sqrt(3) * ySize) / 2);
    return Vector2(pointX, pointY);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    for (int q = -16; q <= 16; q++) {
      for (int r = -16; r <= 16; r++) {
        int qArray = q + 1000;
        int rArray = r + 1000;
        grassSprite.render(
          canvas,
          position: tiles[qArray][rArray]!.position,
          size: Vector2(2 * xSize, (sqrt(3) * ySize))
        );
      }
    }


    Paint paint = Paint();
    paint.style = PaintingStyle.fill;
    paint.color = Color.fromRGBO(255, 0, 0, 1.0);

    Vector2 point1 = pointyHexCorner(0);
    Vector2 point2 = pointyHexCorner(1);
    Vector2 point3 = pointyHexCorner(2);
    Vector2 point4 = pointyHexCorner(3);
    Vector2 point5 = pointyHexCorner(4);
    Vector2 point6 = pointyHexCorner(5);
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
    canvas.drawRawPoints(PointMode.polygon, points, paint);

  }
}