import 'dart:ui';
import 'package:city_builder/component/empty_tile.dart';
import 'package:city_builder/component/grass_tile.dart';
import 'package:city_builder/component/map_quadrant.dart';
import 'package:city_builder/component/tile2.dart';
import 'package:city_builder/component/water_tile.dart';
import 'package:city_builder/world/map_details/map_details_large.dart';
import 'package:city_builder/world/map_details/map_details_normal.dart';
import 'package:city_builder/world/map_details/map_details_small.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import '../component/dirt_tile.dart';
import '../component/tile.dart';
import 'map_details/map_details_medium.dart';
import 'map_details/map_details_tiny.dart';
import 'package:trotter/trotter.dart';


// quadranten (these can be fairly high, they are x, y values not tile amounts
int quadrantSizeX = 240; // 1920/8 (standard monitor width)
int quadrantSizeY = 135; // 1080/8 (standard monitor height)

Future<List<List<Tile2?>>> setTileDetails() async {

  List<List<int>> worldDetail = worldDetailMedium;

  List<List<Tile2?>> tiles = List.generate(
      worldDetail.length,
          (_) => List.filled(worldDetail[0].length, null),
      growable: false);

  for (int q = -(tiles.length/2).ceil(); q < (tiles.length/2).floor(); q++) {
    for (int r = -(tiles[0].length/2).ceil(); r < (tiles[0].length/2).floor(); r++) {
      int s = (q + r) * -1;
      int qArray = q + (tiles.length / 2).ceil();
      int rArray = r + (tiles[0].length / 2).ceil();
      if (worldDetail[qArray][rArray] != -1) {
        Tile2 tile = Tile2(q, r, s, worldDetail[qArray][rArray], await SpriteBatch.load('flat_1.png'));
        tiles[qArray][rArray] = tile;
      }
    }
  }
  return tiles;
}

Future test() async {

}

Future<List<List<MapQuadrant?>>> getMapQuadrants(List<List<Tile?>> tiles, int rotate) async {

  List<double> bounds = getBounds(tiles, rotate);
  double left = bounds[0];
  double right = bounds[1];
  double top = bounds[2];
  double bottom = bounds[3];

  double totalWidth = left.abs() + right.abs();
  double totalHeight = top.abs() + bottom.abs();

  int quadrantsX = (totalWidth / quadrantSizeX).ceil();
  int quadrantsY = (totalHeight / quadrantSizeY).ceil();
  List<List<MapQuadrant?>> mapQuadrants = List.generate(
      quadrantsX, (_) => List.filled(quadrantsY, null),
      growable: false);
  for (int x = 0; x < quadrantsX; x++) {
    for (int y = 0; y < quadrantsY; y++) {
      double fromX = left + (x * quadrantSizeX);
      double toX = left + ((x + 1) * quadrantSizeX);
      double fromY = bottom + (y * quadrantSizeY);
      double toY = bottom + ((y + 1) * quadrantSizeY);
      Vector2 quadrantCenter = Vector2((fromX + (quadrantSizeX/2)), (fromY + (quadrantSizeY/2)));
      if (rotate == 0 || rotate == 2) {
        MapQuadrant mapQuadrant = MapQuadrant(
            await SpriteBatch.load('flat_1.png'), fromX, toX, fromY, toY,
            quadrantCenter, rotate);
        mapQuadrants[x][y] = mapQuadrant;
      } else {
        MapQuadrant mapQuadrant = MapQuadrant(
            await SpriteBatch.load('point_1.png'), fromX, toX, fromY, toY,
            quadrantCenter, rotate);
        mapQuadrants[x][y] = mapQuadrant;
      }
    }
  }
  return mapQuadrants;
}

renderTiles(Canvas canvas, List<List<Tile2?>> tiles, int q, int r, double leftScreen, double rightScreen, double topScreen, double bottomScreen) {
  // first a test with drawing only 1 tiles wide
  int qArray = q + (tiles.length / 2).ceil();
  int rArray = r + (tiles[0].length / 2).ceil();
  Tile2? centerTile = tiles[qArray][rArray];
  int sArray = centerTile!.s;

  int radius = 4;
  final bagOfItems = characters('012345678'), perms = Amalgams(2, bagOfItems);
  for (final perm in perms()) {
    int qTile = int.parse(perm[0]) - radius;
    int rTile = int.parse(perm[1]) - radius;
    Tile2? tile = tiles[qArray + qTile][rArray + rTile];
    drawTile(canvas, tile, sArray, radius);
  }
}

drawTile(Canvas canvas, Tile2? tile, int sArray, int radius) {
  if (tile != null) {
    if ((sArray - tile.s) >= -radius && (sArray - tile.s) <= radius) {
      tile.render(canvas);
    }
  }
}

renderQuadrants(Canvas canvas, List<List<MapQuadrant?>> mapQuadrants, double leftScreen, double rightScreen, double topScreen, double bottomScreen) {
  for (int x = 0; x < mapQuadrants.length; x++) {
    for (int y = 0; y < mapQuadrants[x].length; y++) {
      // If the quadrant is within the screen, draw it.
      if (mapQuadrants[x][y]!.toX > leftScreen && mapQuadrants[x][y]!.fromX < rightScreen) {
        if (mapQuadrants[x][y]!.toY > topScreen && mapQuadrants[x][y]!.fromY < bottomScreen) {
          mapQuadrants[x][y]!.spriteBatch.render(canvas, blendMode: BlendMode.srcOver);
        }
      }
    }
  }
}

updateQuadrants(List<List<MapQuadrant?>> mapQuadrants, double leftScreen, double rightScreen, double topScreen, double bottomScreen, int rotate, int currentVariant) {
  for (int x = 0; x < mapQuadrants.length; x++) {
    for (int y = 0; y < mapQuadrants[x].length; y++) {
      // If the quadrant is within the screen, draw it.
      MapQuadrant? mapQuadrant = mapQuadrants[x][y];
      if (mapQuadrant != null) {
        if (mapQuadrant.toX > leftScreen && mapQuadrant.fromX < rightScreen) {
          if (mapQuadrant.toY > topScreen && mapQuadrant.fromY < bottomScreen) {
            mapQuadrant.spriteBatch.clear();
            for (Tile tile in mapQuadrant.quadrantTiles) {
              tile.renderTile(mapQuadrant.spriteBatch, rotate, currentVariant);
            }
          }
        }
      }
    }
  }
}

updateQuadrant(MapQuadrant mapQuadrant, int rotate) {
  mapQuadrant.spriteBatch.clear();
  for (Tile tile in mapQuadrant.quadrantTiles) {
    tile.renderTile(mapQuadrant.spriteBatch, rotate, 0);
  }
}

List<double> getBounds(List<List<Tile?>> tiles, int rotate) {

  double left = tiles[0][(tiles.length / 2).floor()]!.getPos(rotate).x;
  double right = tiles[tiles.length - 1][(tiles.length / 2).floor()]!.getPos(rotate).x;
  double top = tiles[(tiles.length / 2).round()][0]!.getPos(rotate).y;
  double bottom = tiles[(tiles.length / 2).floor()][tiles.length - 1]!.getPos(rotate).y;

  if (rotate == 1) {
    top = tiles[tiles.length - 1][(tiles.length / 2).floor()]!.getPos(rotate).y;
    bottom = tiles[0][(tiles.length / 2).round()]!.getPos(rotate).y;
    left = tiles[(tiles.length / 2).floor()][0]!.getPos(rotate).x;
    right = tiles[(tiles.length / 2).floor()][tiles.length - 1]!.getPos(rotate).x;
  } else if (rotate == 2) {
    right = tiles[0][(tiles.length / 2).round()]!.getPos(rotate).x;
    left = tiles[tiles.length - 1][(tiles.length / 2).floor()]!.getPos(rotate).x;
    bottom = tiles[(tiles.length / 2).floor()][0]!.getPos(rotate).y;
    top = tiles[(tiles.length / 2).floor()][tiles.length - 1]!.getPos(rotate).y;
  } else if (rotate == 3) {
    bottom = tiles[tiles.length - 1][(tiles.length / 2).floor()]!.getPos(rotate).y;
    top = tiles[0][(tiles.length / 2).round()]!.getPos(rotate).y;
    right = tiles[(tiles.length / 2).floor()][0]!.getPos(rotate).x;
    left = tiles[(tiles.length / 2).floor()][tiles.length - 1]!.getPos(rotate).x;
  }

  return [left, right, top, bottom];
}