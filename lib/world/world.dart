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
  late Sprite grassSpriteTop;

  Paint borderPaint = Paint();

  // We will use this to help with the storing in the array
  int qSizeHalf = -1;
  int rSizeHalf = -1;
  int rotate = 0;

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
        256,
            (_) => List.filled(256, null),
        growable: false);
    qSizeHalf = (tiles.length / 2).round();
    rSizeHalf = (tiles[0].length / 2).round();
    tiles = setTilePositionsFlat(tiles, xSize, ySize, qSizeHalf, rSizeHalf);
    tiles = setTilePositionsPoint(tiles, xSize, ySize, qSizeHalf, rSizeHalf);
  }

  void loadWorld(Sprite grassFlat, Sprite grassTop) {
    grassSpriteFlat = grassFlat;
    grassSpriteTop = grassTop;
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

    if (tiles[q+qSizeHalf][r+rSizeHalf] != null) {
      selectedTile = tiles[q+qSizeHalf][r+rSizeHalf];
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
          qSizeHalf,
          rSizeHalf,
          canvas,
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
          qSizeHalf,
          rSizeHalf,
          canvas,
          grassSpriteTop,
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