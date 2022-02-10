import 'dart:ui';
import 'package:city_builder/component/dirt_tile.dart';
import 'package:city_builder/component/grass_tile.dart';
import 'package:city_builder/component/map_quadrant.dart';
import 'package:city_builder/component/selected_tile.dart';
import 'package:city_builder/component/tile2.dart';
import 'package:city_builder/component/water_tile.dart';
import 'package:city_builder/world/tapped_map.dart';
import 'package:city_builder/world/update_tile_data.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import '../component/tile.dart';
import 'tile_positions.dart';

class World extends Component {

  late List<List<Tile2?>> tiles;

  World() : super();

  Paint borderPaint = Paint();

  late int rotate;

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

  // late SelectedTile selectedTile;

  @override
  Future<void> onLoad() async {
    super.onLoad();

    rotate = 0;

    borderPaint.style = PaintingStyle.stroke;
    borderPaint.strokeWidth = 5;
    borderPaint.color = const Color.fromRGBO(0, 255, 255, 1.0);

    // SpriteBatch batchTest = await SpriteBatch.load('flat_1.png');

    tiles = await setTileDetails();
    worldBounds = [[0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0], [0, 0, 0, 0]];
    // for (int rot = 0; rot < 4; rot++) {
    //   print("rot $rot");
    //   getMapQuadrants(tiles, rot).then((mapQuad) {
    //     print("value $rot");
    //     mapQuad = setTilesToQuadrants(tiles, mapQuad, rot);
    //     print("set tiles $rot");
    //     mapQuadrants[rot] = mapQuad;
    //   });
    //   List<double> bounds = getBounds(tiles, rot);
    //   worldBounds[rot] = bounds;
    //   // miniMap.setWorldWidth(rot, (bounds[0].abs() + bounds[1].abs()));
    // }
    // SelectedTileFlat selectedTileFlat = SelectedTileFlat();
    // SelectedTilePoint selectedTilePoint = SelectedTilePoint();
    // add(selectedTileFlat);
    // add(selectedTilePoint);
    //
    // selectedTile = SelectedTile(selectedTileFlat, selectedTilePoint);

    // test stuff
    for (int q = 0; q < tiles.length; q++) {
      for (int r = 0; r < tiles[q].length; r++) {
        Tile2? tile = tiles[q][r];
        if (tile != null) {
          tile.updateTile(rotate, 0);
        }
      }
    }
  }

  void tappedWorld(double mouseX, double mouseY, String currentTileActive) {
    List<int> tileProperties = getTileFromPos(mouseX, mouseY, rotate);
    int q = tileProperties[0];
    int r = tileProperties[1];
    int s = tileProperties[2];

    print("q: $q  r: $r  s: $s");
    int qArray = q + (tiles.length / 2).ceil();
    int rArray = r + (tiles[0].length / 2).ceil();
    if (qArray >= 0 && qArray < tiles.length && rArray >= 0 && rArray < tiles[0].length) {
      if (tiles[qArray][rArray] != null) {
        // selectedTile.setPosition(tiles[qArray][rArray]!.getPos(rotate), rotate);
        print("position selected tile: ${tiles[qArray][rArray]!.getPos(rotate)}");
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    List<int> tileProperties = getTileFromPos(cameraPosition.x, cameraPosition.y, 0);
    int q = tileProperties[0];
    int r = tileProperties[1];
    int s = tileProperties[2];

    renderTiles(
        canvas,
        tiles,
        q,
        r,
        leftScreen,
        rightScreen,
        topScreen,
        bottomScreen);
  }

  updateWorld(Vector2 cameraPos, double zoomLevel, Vector2 size) {
    cameraPosition = cameraPos;
    worldSize = size;
    zoom = zoomLevel;

    // We draw the border a bit further (about 1 tile) than what you're seeing, this is so the sections load before you scroll on them.
    double borderOffset = 32;
    double hudLeft = 200 / zoomLevel;
    double hudBottom = 100 / zoomLevel;
    leftScreen = cameraPosition.x - (worldSize.x / 2) - borderOffset + hudLeft;
    rightScreen = cameraPosition.x + (worldSize.x / 2) + borderOffset;
    topScreen = cameraPosition.y - (worldSize.y / 2) - borderOffset;
    bottomScreen = cameraPosition.y + (worldSize.y / 2) + borderOffset - hudBottom;

    // if (updateIndex == 30) {
    //   updateIndex = 0;
    //   updateQuadrants(mapQuadrants[rotate], leftScreen, rightScreen, topScreen, bottomScreen, rotate, currentVariant);
    //   if (currentVariant == 1) {
    //     currentVariant = 0;
    //   } else {
    //     currentVariant += 1;
    //   }
    // } else {
    //   updateIndex += 1;
    // }
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

  double getWorldWidth() {
    return worldBounds[rotate][0].abs() + worldBounds[rotate][1].abs();
  }
}