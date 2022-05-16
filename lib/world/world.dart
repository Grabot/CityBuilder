import 'dart:ui';

import 'package:city_builder/component/hexagon.dart';
import 'package:city_builder/component/tile2.dart';
import 'package:city_builder/util/hexagon_list.dart';
import 'package:city_builder/util/render_hexagons.dart';
import 'package:city_builder/util/tapped_map.dart';
import 'package:flame/components.dart';

import '../util/tile_positions.dart';

class World extends Component {

  World() : super();

  Paint borderPaint = Paint();

  late int rotate;

  late Vector2 cameraPosition;
  late double zoom;

  late Vector2 worldSize;
  int updateIndex = 0;
  int currentVariant = 0;
  bool updateSprites = false;
  Rect screen = const Rect.fromLTRB(0, 0, 0, 0);

  late HexagonList hexagonList;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    rotate = 0;

    borderPaint.style = PaintingStyle.stroke;
    borderPaint.strokeWidth = 5;
    borderPaint.color = const Color.fromRGBO(0, 255, 255, 1.0);
    hexagonList = HexagonList();
  }

  void tappedWorld(double mouseX, double mouseY, String currentTileActive) {
    List<int> tileProperties = getTileFromPos(mouseX, mouseY, rotate);
    int q = tileProperties[0];
    int r = tileProperties[1];
    int s = tileProperties[2];

    print("q: $q  r: $r  s: $s");
    int qArray = q + (hexagonList.tiles.length / 2).ceil();
    int rArray = r + (hexagonList.tiles[0].length / 2).ceil();
    if (qArray >= 0 && qArray < hexagonList.tiles.length && rArray >= 0 && rArray < hexagonList.tiles[0].length) {
      if (hexagonList.tiles[qArray][rArray] != null) {
        // selectedTile.setPosition(tiles[qArray][rArray]!.getPos(rotate), rotate);
        print("position selected tile: ${hexagonList.tiles[qArray][rArray]!.getPos(rotate)}");
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    renderHexagons(canvas, cameraPosition, hexagonList, screen, rotate, currentVariant);
  }

  updateWorld(Vector2 cameraPos, double zoomLevel, Vector2 size) {
    cameraPosition = cameraPos;
    worldSize = size;
    zoom = zoomLevel;

    // We draw the border a bit further (about 1 tile) than what you're seeing, this is so the sections load before you scroll on them.
    double borderOffset = 32;
    double hudLeft = 200 / zoomLevel;
    double hudBottom = 100 / zoomLevel;
    double leftScreen = cameraPosition.x - (worldSize.x / 2) - borderOffset + hudLeft;
    double rightScreen = cameraPosition.x + (worldSize.x / 2) + borderOffset;
    double topScreen = cameraPosition.y - (worldSize.y / 2) - borderOffset;
    double bottomScreen = cameraPosition.y + (worldSize.y / 2) + borderOffset - hudBottom;
    screen = Rect.fromLTRB(leftScreen, topScreen, rightScreen, bottomScreen);
  }

  // For now we use the variant to determine which animation sprite has to be drawn
  updateVariant(int variant) {
    currentVariant = variant;
    updateSprites = true;
  }

  rotateWorldRight() {
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
    return hexagonList.hexagonBounds[rotate][1].x;
  }
  double getBoundRight() {
    return hexagonList.hexagonBounds[rotate][4].x;
  }
  double getBoundTop() {
    return hexagonList.hexagonBounds[rotate][3].y;
  }
  double getBoundBottom() {
    return hexagonList.hexagonBounds[rotate][0].y;
  }

  List<Vector2> getHexagonPoints() {
    return hexagonList.hexagonBounds[rotate];
  }

  double getWorldWidth() {
    return hexagonList.hexagonBounds[rotate][1].x.abs() + hexagonList.hexagonBounds[rotate][4].x.abs();
  }
}