

import 'package:city_builder/component/map_quadrant.dart';
import 'package:city_builder/component/tile.dart';
import 'package:flame/components.dart';
import 'package:flame/sprite.dart';

Future<List<SpriteBatch>> updateTileData(List<List<Tile?>> tiles, int rotate) async {

  int quadrantSize = 64;
  List<SpriteBatch> spriteBatches = [];
  for (int quadrantX = 0; (quadrantX * quadrantSize) < tiles.length; quadrantX ++) {
    for (int quadrantY = 0; (quadrantY * quadrantSize) <
        tiles[0].length; quadrantY ++) {
      print("quadrantX $quadrantX   quadrantY: $quadrantY");
      SpriteBatch spriteBatchFlat = await SpriteBatch.load('flat_sheet.png');
      for (
      int q = -(tiles.length / 2).ceil();
      q < -(tiles.length / 2).ceil() + quadrantSize;
      q++
      ) {
        for (
        int r = -(tiles[0].length / 2).ceil();
        r < -(tiles[0].length / 2).ceil() + quadrantSize;
        r++
        ) {
          int qArray = q + (tiles.length / 2).ceil();
          qArray += (quadrantX * quadrantSize);
          int rArray = r + (tiles[0].length / 2).ceil();
          rArray += (quadrantY * quadrantSize);
          if (qArray < tiles.length && rArray < tiles[0].length) {
            if (tiles[qArray][rArray] != null) {
              tiles[qArray][rArray]!.renderTile(spriteBatchFlat, rotate);
            }
          }
        }
      }
      spriteBatches.add(spriteBatchFlat);
    }
  }
  return spriteBatches;
}

setTilesToQuadrants(List<List<Tile?>> tiles, List<List<MapQuadrant?>> mapQuadrants) {

  for (int q = 0; q < tiles.length; q++) {
    for (int r = 0; r < tiles[q].length; r++) {
      Tile? tile = tiles[q][r];
      if (tile != null) {
        bool tileFound = false;
        for (int x = 0; x < mapQuadrants.length; x++) {
          for (int y = 0; y < mapQuadrants[x].length; y++) {
            MapQuadrant? mapQuadrant = mapQuadrants[x][y];
            if (mapQuadrant != null) {
              Vector2 tilePos = tile.getPos(0);
              if (tilePos.x >= mapQuadrant.fromX && tilePos.x < mapQuadrant.toX) {
                if (tilePos.y >= mapQuadrant.fromY && tilePos.y < mapQuadrant.toY) {
                  // The tile is within this quadrant.
                  mapQuadrant.addTileToQuadrant(tile);
                  tile.setQuadrant(mapQuadrant);
                  tileFound = true;

                  tile.renderTile(mapQuadrant.spriteBatchFlat, 0);
                  break;
                }
              }
            }
          }
          if (tileFound) {
            break;
          }
        }
      }
    }
  }
}