import 'dart:ui';

import 'package:city_builder/component/grass_tile.dart';
import 'package:city_builder/component/map_quadrant.dart';
import 'package:city_builder/component/water_tile.dart';
import 'package:city_builder/world/map_details/map_details_large.dart';
import 'package:city_builder/world/map_details/map_details_normal.dart';
import 'package:city_builder/world/map_details/map_details_small.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import '../component/dirt_tile.dart';
import '../component/tile.dart';


// quadranten (these can be fairly high, they are x, y values not tile amounts
int quadrantSizeX = 960; // 1920/2 (standard monitor width)
int quadrantSizeY = 540; // 1080/2 (standard monitor height)

List<List<Tile?>> setTileDetails() {

  List<List<int>> worldDetail = worldDetailSmall;

  List<List<Tile?>> tiles = List.generate(
      worldDetail.length,
          (_) => List.filled(worldDetail[0].length, null),
      growable: false);

  for (int q = -(tiles.length/2).ceil(); q < (tiles.length/2).floor(); q++) {
    for (int r = -(tiles[0].length/2).ceil(); r < (tiles[0].length/2).floor(); r++) {
      int s = (q + r) * -1;
      int qArray = q + (tiles.length / 2).ceil();
      int rArray = r + (tiles[0].length / 2).ceil();
      if (worldDetail[qArray][rArray] == 0) {
        WaterTile tile = WaterTile(q, r, s);
        tiles[qArray][rArray] = tile;
      } else if (worldDetail[qArray][rArray] == 1) {
        DirtTile tile = DirtTile(q, r, s);
        tiles[qArray][rArray] = tile;
      } else if (worldDetail[qArray][rArray] == 2) {
        GrassTile tile = GrassTile(q, r, s);
        tiles[qArray][rArray] = tile;
      }
    }
  }
  return tiles;
}

Future<List<List<MapQuadrant?>>> getMapQuadrants(List<List<Tile?>> tiles) async {
  // flat total width
  double left = tiles[0][(tiles.length / 2).round()]!.getPos(0).x;
  double right =
      tiles[tiles.length - 1][(tiles.length / 2).floor()]!.getPos(0).x;
  double totalWidth = left.abs() + right.abs();

  // flat total height
  double top = tiles[(tiles.length / 2).round()][0]!.getPos(0).y;
  double bottom =
      tiles[(tiles.length / 2).floor()][tiles.length - 1]!.getPos(0).y;
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
      MapQuadrant mapQuadrant = MapQuadrant(
          await SpriteBatch.load('flat_sheet.png'), fromX, toX, fromY, toY, quadrantCenter);
      mapQuadrants[x][y] = mapQuadrant;
    }
  }
  return mapQuadrants;
}

renderQuadrants(Canvas canvas, List<List<MapQuadrant?>> mapQuadrants, int x, int y, Vector2 cameraPos) {

  // We render (for now) the quadrant the camera is currently and and the 8 next to it.
  mapQuadrants[x][y]!.spriteBatchFlat.render(canvas, blendMode: BlendMode.srcOver);
  // 1
  if ((x - 1) >= 0 && (y - 1) >= 0) {
    double distanceX = (cameraPos.x - mapQuadrants[x - 1][y - 1]!.center.x).abs();
    double distanceY = (cameraPos.y - mapQuadrants[x - 1][y - 1]!.center.y).abs();
    if (distanceX < quadrantSizeX && distanceY < quadrantSizeY) {
      mapQuadrants[x - 1][y - 1]!
          .spriteBatchFlat
          .render(canvas, blendMode: BlendMode.srcOver);
    }
  }
  // 2
  if ((x - 1) >= 0) {
    double distanceX = (cameraPos.x - mapQuadrants[x - 1][y]!.center.x).abs();
    double distanceY = (cameraPos.y - mapQuadrants[x - 1][y]!.center.y).abs();
    if (distanceX < quadrantSizeX && distanceY < quadrantSizeY) {
      mapQuadrants[x - 1][y]!
          .spriteBatchFlat
          .render(canvas, blendMode: BlendMode.srcOver);
    }
  }
  // 3
  if ((x - 1) >= 0 && (y + 1) < mapQuadrants[x].length) {
    double distanceX = (cameraPos.x - mapQuadrants[x - 1][y + 1]!.center.x).abs();
    double distanceY = (cameraPos.y - mapQuadrants[x - 1][y + 1]!.center.y).abs();
    if (distanceX < quadrantSizeX && distanceY < quadrantSizeY) {
      mapQuadrants[x - 1][y + 1]!
          .spriteBatchFlat
          .render(canvas, blendMode: BlendMode.srcOver);
    }
  }
  // 4
  if ((y - 1) >= 0) {
    double distanceX = (cameraPos.x - mapQuadrants[x][y - 1]!.center.x).abs();
    double distanceY = (cameraPos.y - mapQuadrants[x][y - 1]!.center.y).abs();
    if (distanceX < quadrantSizeX && distanceY < quadrantSizeY) {
      mapQuadrants[x][y - 1]!
          .spriteBatchFlat
          .render(canvas, blendMode: BlendMode.srcOver);
    }
  }
  // 5
  if ((y + 1) < mapQuadrants[x].length) {
    double distanceX = (cameraPos.x - mapQuadrants[x][y + 1]!.center.x).abs();
    double distanceY = (cameraPos.y - mapQuadrants[x][y + 1]!.center.y).abs();
    if (distanceX < quadrantSizeX && distanceY < quadrantSizeY) {
      mapQuadrants[x][y + 1]!
          .spriteBatchFlat
          .render(canvas, blendMode: BlendMode.srcOver);
    }
  }
  // 6
  if ((x + 1) < mapQuadrants.length && (y - 1) >= 0) {
    double distanceX = (cameraPos.x - mapQuadrants[x + 1][y - 1]!.center.x).abs();
    double distanceY = (cameraPos.y - mapQuadrants[x + 1][y - 1]!.center.y).abs();
    if (distanceX < quadrantSizeX && distanceY < quadrantSizeY) {
      mapQuadrants[x + 1][y - 1]!
          .spriteBatchFlat
          .render(canvas, blendMode: BlendMode.srcOver);
    }
  }
  // 7
  if ((x + 1) < mapQuadrants.length) {
    double distanceX = (cameraPos.x - mapQuadrants[x + 1][y]!.center.x).abs();
    double distanceY = (cameraPos.y - mapQuadrants[x + 1][y]!.center.y).abs();
    if (distanceX < quadrantSizeX && distanceY < quadrantSizeY) {
      mapQuadrants[x + 1][y]!
          .spriteBatchFlat
          .render(canvas, blendMode: BlendMode.srcOver);
    }
  }
  // 8
  if ((x + 1) < mapQuadrants.length && (y + 1) < mapQuadrants[x].length) {
    double distanceX = (cameraPos.x - mapQuadrants[x + 1][y + 1]!.center.x).abs();
    double distanceY = (cameraPos.y - mapQuadrants[x + 1][y + 1]!.center.y).abs();
    if (distanceX < quadrantSizeX && distanceY < quadrantSizeY) {
      mapQuadrants[x + 1][y + 1]!
          .spriteBatchFlat
          .render(canvas, blendMode: BlendMode.srcOver);
    }
  }
}