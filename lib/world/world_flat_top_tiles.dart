import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flame/components.dart';
import '../component/tile.dart';

class WorldFlatTop extends Component {

  // size = 16.
  // width = 2 * size
  // height = sqrt(3) * size / 2   divided by 2 to give the isometric view
  final double xSize = 16 * 2;
  final double ySize = sqrt(3) * 16 / 2;

  late List<List<Tile?>> tiles;
  Tile? selectedTile;

  WorldFlatTop() : super();

  late Sprite grassSprite;

  Paint selectedPaint = Paint();
  Paint borderPaint = Paint();

  void loadWorld(Sprite grassSprite) {
    this.grassSprite = grassSprite;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    selectedPaint.style = PaintingStyle.fill;
    selectedPaint.color = const Color.fromRGBO(255, 0, 0, 1.0);

    borderPaint.style = PaintingStyle.stroke;
    borderPaint.strokeWidth = 5;
    borderPaint.color = const Color.fromRGBO(0, 255, 255, 1.0);

    tiles = List.generate(
        2000,
        (_) => List.filled(2000, null),
        growable: false);

    for (int q = -800; q <= 800; q++) {
      for (int r = -800; r <= 800; r++) {
        int s = (q + r) * -1;
        double xPos = xSize * 3 / 2 * q - xSize;
        double yTr1 = ySize * (sqrt(3) / 2 * q);
        yTr1 *= -1;  // The y axis gets positive going down, so we flip it.
        double yTr2 = ySize * (sqrt(3) * r);
        yTr2 *= -1;  // The y axis gets positive going down, so we flip it.
        double yPos = yTr1 + yTr2 - ySize;
        Vector2 position = Vector2(xPos, yPos);
        Tile tile = Tile(q, r, s, position);
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
    yTranslate2 *= -1;  // The y axis gets positive going down, so we flip it.
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
      selectedTile = tiles[q+1000][r+1000];
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

    for (int q = -32; q <= 32; q++) {
      for (int r = -32; r <= 32; r++) {
        if (tiles[q + 1000][r + 1000] != null) {
          grassSprite.render(
              canvas,
              position: tiles[q + 1000][r + 1000]!.getPos(),
              size: Vector2(2 * xSize, sqrt(3) * ySize)
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

    Rect worldRect = Rect.fromLTRB(left, top, right, bottom);
    canvas.drawRect(worldRect, borderPaint);
  }

  double left = 0.0;
  double right = 0.0;
  double top = 0.0;
  double bottom = 0.0;
  void updateWorld(Vector2 cameraPosition, Vector2 size) {
    left = cameraPosition.x - (size.x / 2) + 20;
    right = cameraPosition.x + (size.x / 2) - 20;
    top = cameraPosition.y - (size.y / 2) + 20;
    bottom = cameraPosition.y + (size.y / 2) - 20;

  }
}