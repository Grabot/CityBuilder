import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:city_builder/world/render_tiles.dart';
import 'package:city_builder/world/selected_tile.dart';
import 'package:city_builder/world/tapped_map.dart';
import 'package:flame/components.dart';
import '../component/tile.dart';
import 'tile_positions.dart';

class World extends Component {

  // size = 16.
  // width = 2 * size
  // height = sqrt(3) * size / 2   divided by 2 to give the isometric view
  double xSize = 16 * 2;
  double ySize = sqrt(3) * 16 / 2;
  // double xSize = sqrt(3) * 16;
  // double ySize = 32 / 2;

  late List<List<Tile?>> tiles;
  Tile? selectedTile;

  World() : super();

  late Sprite grassSpriteFlat;
  late Sprite grassSpritePoint;
  late Sprite dirtSpriteFlat;
  late Sprite dirtSpritePoint;
  late Sprite waterSpriteFlat;
  late Sprite waterSpritePoint;

  Paint borderPaint = Paint();

  int rotate = -1;

  double left = 0.0;
  double right = 0.0;
  double top = 0.0;
  double bottom = 0.0;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    rotate = 0;

    if (rotate == 0) {
      xSize = 16 * 2;
      ySize = sqrt(3) * 16 / 2;
    } else if (rotate == 1) {
      xSize = sqrt(3) * 16;
      ySize = 32 / 2;
    }

    borderPaint.style = PaintingStyle.stroke;
    borderPaint.strokeWidth = 5;
    borderPaint.color = const Color.fromRGBO(0, 255, 255, 1.0);

    tiles = List.generate(
        11,
            (_) => List.filled(11, null),
        growable: false);

    tiles = setTilePositionsFlat(tiles, xSize, ySize);
    tiles = setTilePositionsPoint(tiles, xSize, ySize);
  }

  void loadSprites(Sprite grassFlat, Sprite grassPoint, Sprite dirtFlat, Sprite dirtPoint, Sprite waterFlat, Sprite waterPoint) {
    grassSpriteFlat = grassFlat;
    grassSpritePoint = grassPoint;
    dirtSpriteFlat = dirtFlat;
    dirtSpritePoint = dirtPoint;
    waterSpriteFlat = waterFlat;
    waterSpritePoint = waterPoint;
  }

  void tappedWorld(double mouseX, double mouseY) {
    int q = 0;
    int r = 0;
    int s = 0;
    if (rotate == 0) {
      List<int> tileProperties = tappedMapFlat(tiles, xSize, ySize, mouseX, mouseY);
      q = tileProperties[0];
      r = tileProperties[1];
      s = tileProperties[2];
    } else if (rotate == 1) {
      List<int> tileProperties = tappedMapPoint(tiles, xSize, ySize, mouseX, mouseY);
      q = tileProperties[0];
      r = tileProperties[1];
      s = tileProperties[2];
    }

    // This is used to make the map. So if it does not hold the user clicked out of bounds.
    if (((q + r) >= -((tiles.length/2).ceil() + 1)) && ((q + r) < (tiles.length/2).floor() - 1)) {
      int qArray = q + (tiles.length / 2).ceil();
      int rArray = r + (tiles[0].length / 2).ceil();
      if (tiles[qArray][rArray] != null) {
        selectedTile = tiles[qArray][rArray];
      }
    }
  }

  void clearSelectedTile() {
    selectedTile = null;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    if (rotate == 0) {
      renderTilesFlat(
          tiles,
          xSize,
          ySize,
          canvas,
          waterSpriteFlat,
          dirtSpriteFlat,
          grassSpriteFlat,
          left,
          right,
          top,
          bottom);
    } else if (rotate == 1) {
      renderTilesPoint(
          tiles,
          xSize,
          ySize,
          canvas,
          waterSpritePoint,
          dirtSpritePoint,
          grassSpritePoint,
          left,
          right,
          top,
          bottom);
    }

    if (selectedTile != null) {
      tileSelected(selectedTile!, xSize, ySize, rotate, canvas);
    }

    Rect worldRect = Rect.fromLTRB(left, top, right, bottom);
    canvas.drawRect(worldRect, borderPaint);
  }

  void updateWorld(Vector2 cameraPosition, Vector2 size) {
    double borderOffset = 50;
    left = cameraPosition.x - (size.x / 2) + borderOffset;
    right = cameraPosition.x + (size.x / 2) - borderOffset;
    top = cameraPosition.y - (size.y / 2) + borderOffset;
    bottom = cameraPosition.y + (size.y / 2) - borderOffset;
  }
}