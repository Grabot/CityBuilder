import 'dart:ui';
import 'package:city_builder/component/map_quadrant.dart';
import 'package:city_builder/component/mini_map.dart';
import 'package:city_builder/component/selected_tile.dart';
import 'package:city_builder/component/sprite_button.dart';
import 'package:city_builder/world/tapped_map.dart';
import 'package:city_builder/world/update_tile_data.dart';
import 'package:flame/components.dart';
import '../component/tile.dart';
import 'tile_positions.dart';

class World extends Component {

  late List<List<Tile?>> tiles;

  MiniMapComponent miniMap;
  World(this.miniMap) : super();

  Paint borderPaint = Paint();

  late int rotate;

  late List<List<List<MapQuadrant?>>> mapQuadrants;
  late Vector2 cameraPosition;
  late double zoom;

  late Vector2 worldSize;
  int updateIndex = 0;
  int currentVariant = 0;
  double leftScreen = 0;
  double rightScreen = 0;
  double topScreen = 0;
  double bottomScreen = 0;

  late List<List<double>> worldBounds;

  late SelectedTile selectedTile;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    rotate = 0;

    borderPaint.style = PaintingStyle.stroke;
    borderPaint.strokeWidth = 5;
    borderPaint.color = const Color.fromRGBO(0, 255, 255, 1.0);

    tiles = setTileDetails();
    mapQuadrants = [[], [], [], []];
    worldBounds = [[], [], [], []];
    for (int rot = 0; rot < 4; rot++) {
      print("rot $rot");
      getMapQuadrants(tiles, rot).then((mapQuad) {
        print("value $rot");
        mapQuad = setTilesToQuadrants(tiles, mapQuad, rot);
        print("set tiles $rot");
        mapQuadrants[rot] = mapQuad;
      });
      List<double> bounds = getBounds(tiles, rot);
      worldBounds[rot] = bounds;
      miniMap.setWorldWidth(rot, (bounds[0].abs() + bounds[1].abs()));
    }
    SelectedTileFlat selectedTileFlat = SelectedTileFlat();
    SelectedTilePoint selectedTilePoint = SelectedTilePoint();
    add(selectedTileFlat);
    add(selectedTilePoint);

    selectedTile = SelectedTile(selectedTileFlat, selectedTilePoint);
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
        selectedTile.setPosition(tiles[qArray][rArray]!.getPos(rotate), rotate);
        print("position selected tile: ${tiles[qArray][rArray]!.getPos(rotate)}");
      }
    }
  }

  void clearSelectedTile() {
    selectedTile.clearSelection();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    renderQuadrants(canvas, mapQuadrants[rotate], leftScreen, rightScreen, topScreen, bottomScreen);
  }

  updateWorld(Vector2 cameraPos, double zoomLevel, Vector2 size) {
    cameraPosition = cameraPos;
    worldSize = size;
    zoom = zoomLevel;

    // We draw the border a bit further than what you're seeing, this is so the sections load before you scroll on them.
    double borderOffset = 100;
    leftScreen = cameraPosition.x - (worldSize.x / 2) - borderOffset;
    rightScreen = cameraPosition.x + (worldSize.x / 2) + borderOffset;
    topScreen = cameraPosition.y - (worldSize.y / 2) - borderOffset;
    bottomScreen = cameraPosition.y + (worldSize.y / 2) + borderOffset;

    if (updateIndex == 30) {
      updateIndex = 0;
      updateQuadrants(mapQuadrants[rotate], leftScreen, rightScreen, topScreen, bottomScreen, rotate, currentVariant);
      if (currentVariant == 1) {
        currentVariant = 0;
      } else {
        currentVariant += 1;
      }
    } else {
      updateIndex += 1;
    }
  }

  rotateWorldRight() {
    selectedTile.clearSelection();
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

  rotateWorldLeft() {
    selectedTile.clearSelection();
    if (rotate == 0) {
      rotate = 3;
    } else if (rotate == 1) {
      rotate = 0;
    } else if (rotate == 2) {
      rotate = 1;
    } else {
      rotate = 2;
    }
  }

  double getBoundLeft() {
    return worldBounds[rotate][0];
  }
  double getBoundRight() {
    return worldBounds[rotate][1];
  }
  double getBoundTop() {
    return worldBounds[rotate][2];
  }
  double getBoundBottom() {
    return worldBounds[rotate][3];
  }
}