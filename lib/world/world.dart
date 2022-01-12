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

  late List<List<List<MapQuadrant?>>> mapQuadrants;
  late Vector2 cameraPosition;
  late double zoom;
  
  @override
  Future<void> onLoad() async {
    super.onLoad();

    rotate = 1;

    borderPaint.style = PaintingStyle.stroke;
    borderPaint.strokeWidth = 5;
    borderPaint.color = const Color.fromRGBO(0, 255, 255, 1.0);

    tiles = setTileDetails();
    mapQuadrants = [];
    mapQuadrants.add([]);
    mapQuadrants.add([]);
    mapQuadrants.add([]);
    mapQuadrants.add([]);
    for (int rot = 0; rot < 4; rot++) {
      print("rot $rot");
      getMapQuadrants(tiles, rot).then((mapQuad) {
        print("value $rot");
        mapQuad = setTilesToQuadrants(tiles, mapQuad, rot);
        print("set tiles $rot");
        mapQuadrants[rot] = mapQuad;
      });
    }
  }

  void tappedWorld(double mouseX, double mouseY) {
    List<int> tileProperties = tappedMap(tiles, mouseX, mouseY, rotate);
    int q = tileProperties[0];
    int r = tileProperties[1];
    int s = tileProperties[2];

    print("q: $q  r: $r  s: $s");
    int qArray = q + (tiles.length / 2).ceil();
    int rArray = r + (tiles[0].length / 2).ceil();
    if (qArray >= 0 && qArray < tiles.length && rArray >= 0 && rArray < tiles[0].length) {
      if (tiles[qArray][rArray] != null) {
        selectedTile = tiles[qArray][rArray];
        print("position selected tile: ${selectedTile!.getPos(rotate)}");
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
    renderQuadrants(canvas, mapQuadrants[rotate], leftScreen, rightScreen, topScreen, bottomScreen);

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
    if (rotate == 0) {
      rotate = 1;
    } else if (rotate == 1) {
      rotate = 2;
    } else if (rotate == 2) {
      rotate = 3;
    } else {
      rotate = 0;
    }
  }
}