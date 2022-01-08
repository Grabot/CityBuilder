import 'dart:ui';
import 'package:city_builder/world/selected_tile.dart';
import 'package:city_builder/world/tapped_map.dart';
import 'package:city_builder/world/update_tile_data.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import '../component/tile.dart';
import 'tile_positions.dart';

class World extends Component {

  late List<List<Tile?>> tiles;
  Tile? selectedTile;

  World() : super();

  Paint borderPaint = Paint();

  late int rotate;

  double left = 0.0;
  double right = 0.0;
  double top = 0.0;
  double bottom = 0.0;

  late List<SpriteBatch> mapSpriteBatches;

  late SpriteBatch spriteBatchFlatClose0;
  late SpriteBatch spriteBatchFlatClose2;
  late SpriteBatch spriteBatchPointClose1;
  late SpriteBatch spriteBatchPointClose3;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    spriteBatchFlatClose0 = await SpriteBatch.load('flat_sheet.png');
    spriteBatchPointClose1 = await SpriteBatch.load('point_sheet.png');
    spriteBatchFlatClose2 = await SpriteBatch.load('flat_sheet.png');
    spriteBatchPointClose3 = await SpriteBatch.load('point_sheet.png');

    rotate = 0;

    borderPaint.style = PaintingStyle.stroke;
    borderPaint.strokeWidth = 5;
    borderPaint.color = const Color.fromRGBO(0, 255, 255, 1.0);

    tiles = setTileDetails();
    mapSpriteBatches = [];
    updateTileData(tiles, 0).then((value) {
      mapSpriteBatches = value;
    });
  }

  void tappedWorld(double mouseX, double mouseY) {
    List<int> tileProperties = tappedMap(tiles, mouseX, mouseY, rotate);
    int q = tileProperties[0];
    int r = tileProperties[1];
    int s = tileProperties[2];

    print("q: $q  r: $r  s: $s");
    // This is used to make the map. So if it does not hold the user clicked out of bounds.
    int qArray = q + (tiles.length / 2).ceil();
    int rArray = r + (tiles[0].length / 2).ceil();
    if (qArray >= 0 && qArray < tiles.length && rArray >= 0 && rArray < tiles[0].length) {
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

    // for (SpriteBatch spriteBatch in mapSpriteBatches) {
    //   spriteBatch.render(
    //       canvas,
    //       blendMode: BlendMode.srcOver,
    //       cullRect: Rect.fromLTRB(left, top, right, bottom)
    //   );
    // }
    mapSpriteBatches[6].render(
        canvas,
        blendMode: BlendMode.srcOver,
        cullRect: Rect.fromLTRB(left, top, right, bottom)
    );

    if (selectedTile != null) {
      tileSelected(selectedTile!, rotate, canvas);
    }

    Rect worldRect = Rect.fromLTRB(left, top, right, bottom);
    canvas.drawRect(worldRect, borderPaint);
  }

  updateWorld(Vector2 cameraPosition, Vector2 size) {
    double borderOffset = 50;
    left = cameraPosition.x - (size.x / 2) + borderOffset;
    right = cameraPosition.x + (size.x / 2) - borderOffset;
    top = cameraPosition.y - (size.y / 2) + borderOffset;
    bottom = cameraPosition.y + (size.y / 2) - borderOffset;
  }

  rotateWorld() {
    // mapSpriteBatches = [];
    // if (rotate == 0) {
    //   spriteBatchPointClose1.clear();
    //   mapSpriteBatches = updateTileData(tiles, 1, spriteBatchPointClose1);
    //   rotate = 1;
    // } else if (rotate == 1) {
    //   spriteBatchFlatClose2.clear();
    //   mapSpriteBatches = updateTileData(tiles, 2, spriteBatchFlatClose2);
    //   rotate = 2;
    // } else if (rotate == 2) {
    //   spriteBatchPointClose3.clear();
    //   mapSpriteBatches = updateTileData(tiles, 3, spriteBatchPointClose3);
    //   rotate = 3;
    // } else {
    //   spriteBatchFlatClose0.clear();
    //   mapSpriteBatches = updateTileData(tiles, 0, spriteBatchFlatClose0);
    //   rotate = 0;
    // }
  }
}