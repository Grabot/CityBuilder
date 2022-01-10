import 'dart:ui';
import 'package:city_builder/component/map_quadrant.dart';
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

  late SpriteBatch spriteBatchFlatClose0;
  late SpriteBatch spriteBatchFlatClose2;
  late SpriteBatch spriteBatchPointClose1;
  late SpriteBatch spriteBatchPointClose3;

  late List<List<MapQuadrant?>> mapQuadrants;
  late Vector2 cameraPosition;
  late double zoom;
  
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
    getMapQuadrants(tiles).then((value) {
      mapQuadrants = value;
      setTilesToQuadrants(tiles, mapQuadrants);
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
        print("position selected tile: ${selectedTile!.getPos(0)}");
      }
    }
  }

  void clearSelectedTile() {
    selectedTile = null;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // We draw the border a bit further than what you're seeing, this is so the sections load before you scroll on them.
    double borderOffset = 100;
    double leftScreen = cameraPosition.x - (worldSize.x / 2) - borderOffset;
    double rightScreen = cameraPosition.x + (worldSize.x / 2) + borderOffset;
    double topScreen = cameraPosition.y - (worldSize.y / 2) - borderOffset;
    double bottomScreen = cameraPosition.y + (worldSize.y / 2) + borderOffset;
    for (int x = 0; x < mapQuadrants.length; x++) {
      for (int y = 0; y < mapQuadrants[x].length; y++) {
        if (mapQuadrants[x][y] != null) {
          if (cameraPosition.x >= mapQuadrants[x][y]!.fromX && cameraPosition.x < mapQuadrants[x][y]!.toX) {
            if (cameraPosition.y >= mapQuadrants[x][y]!.fromY && cameraPosition.y < mapQuadrants[x][y]!.toY) {
              // The quadrant that the camera is on right now.
              renderQuadrants(canvas, mapQuadrants, x, y, leftScreen, rightScreen, topScreen, bottomScreen);
            }
          }
        }
      }
    }

    if (selectedTile != null) {
      tileSelected(selectedTile!, rotate, canvas);
    }

  }

  late Vector2 worldSize;
  updateWorld(Vector2 cameraPos, double zoomLevel, Vector2 size) {
    cameraPosition = cameraPos;
    worldSize = size;
    zoom = zoomLevel;
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