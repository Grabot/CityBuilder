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

  // We will use this to help with the storing in the array
  int qSizeHalf = -1;
  int rSizeHalf = -1;
  @override
  Future<void> onLoad() async {
    super.onLoad();

    selectedPaint.style = PaintingStyle.fill;
    selectedPaint.color = const Color.fromRGBO(255, 0, 0, 1.0);

    borderPaint.style = PaintingStyle.stroke;
    borderPaint.strokeWidth = 5;
    borderPaint.color = const Color.fromRGBO(0, 255, 255, 1.0);

    tiles = List.generate(
        256,
        (_) => List.filled(256, null),
        growable: false);
    qSizeHalf = (tiles.length / 2).round();
    rSizeHalf = (tiles[0].length / 2).round();

    for (int q = -qSizeHalf; q <= qSizeHalf-1; q++) {
      for (int r = -rSizeHalf; r <= rSizeHalf-1; r++) {
        int s = (q + r) * -1;
        double xPos = xSize * 3 / 2 * q - xSize;
        double yTr1 = ySize * (sqrt(3) / 2 * q);
        yTr1 *= -1;  // The y axis gets positive going down, so we flip it.
        double yTr2 = ySize * (sqrt(3) * r);
        yTr2 *= -1;  // The y axis gets positive going down, so we flip it.
        double yPos = yTr1 + yTr2 - ySize;
        Vector2 position = Vector2(xPos, yPos);
        Tile tile = Tile(q, r, s);
        tile.setPositionPoint(position);
        int qArray = q + qSizeHalf;
        int rArray = r + rSizeHalf;
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

    if (tiles[q+qSizeHalf][r+rSizeHalf] != null) {
      selectedTile = tiles[q+qSizeHalf][r+rSizeHalf];
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

    for (int q = -qSizeHalf; q <= qSizeHalf - 1; q++) {
      for (int r = -rSizeHalf; r <= rSizeHalf - 1; r++) {
        if (tiles[q + qSizeHalf][r + rSizeHalf] != null) {
          if (tiles[q + qSizeHalf][r + rSizeHalf]!.getPosFlat().x > left &&
              tiles[q + qSizeHalf][r + rSizeHalf]!.getPosFlat().x < right) {
            if (tiles[q + qSizeHalf][r + rSizeHalf]!.getPosFlat().y > top &&
                tiles[q + qSizeHalf][r + rSizeHalf]!.getPosFlat().y < bottom) {
              grassSprite.render(canvas,
                  position: tiles[q + qSizeHalf][r + rSizeHalf]!.getPosFlat(),
                  size: Vector2(2 * xSize, sqrt(3) * ySize)
              );
            }
          }
        }
      }
    }

    if (selectedTile != null) {
      Vector2 point1 = pointyHexCorner(0, selectedTile!.getPosFlat());
      Vector2 point2 = pointyHexCorner(1, selectedTile!.getPosFlat());
      Vector2 point3 = pointyHexCorner(2, selectedTile!.getPosFlat());
      Vector2 point4 = pointyHexCorner(3, selectedTile!.getPosFlat());
      Vector2 point5 = pointyHexCorner(4, selectedTile!.getPosFlat());
      Vector2 point6 = pointyHexCorner(5, selectedTile!.getPosFlat());
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
    double borderOffset = 50;
    left = cameraPosition.x - (size.x / 2) + borderOffset;
    right = cameraPosition.x + (size.x / 2) - borderOffset;
    top = cameraPosition.y - (size.y / 2) + borderOffset;
    bottom = cameraPosition.y + (size.y / 2) - borderOffset;

  }
}