import 'package:city_builder/component/map_quadrant.dart';
import 'package:city_builder/component/tile.dart';
import 'package:flame/components.dart';


List<List<MapQuadrant?>> setTilesToQuadrants(List<List<Tile?>> tiles, List<List<MapQuadrant?>> mapQuadrants, int rotate) {

  for (int q = 0; q < tiles.length; q++) {
    for (int r = 0; r < tiles[q].length; r++) {
      Tile? tile = tiles[q][r];
      if (tile != null) {
        bool tileFound = false;
        for (int x = 0; x < mapQuadrants.length; x++) {
          for (int y = 0; y < mapQuadrants[x].length; y++) {
            MapQuadrant? mapQuadrant = mapQuadrants[x][y];
            if (mapQuadrant != null) {
              Vector2 tilePos = tile.getPos(rotate);
              if (tilePos.x >= mapQuadrant.fromX && tilePos.x < mapQuadrant.toX) {
                if (tilePos.y >= mapQuadrant.fromY && tilePos.y < mapQuadrant.toY) {
                  // The tile is within this quadrant.
                  mapQuadrant.addTileToQuadrant(tile);
                  tile.setQuadrant(mapQuadrant);
                  tileFound = true;

                  tile.renderTile(mapQuadrant.spriteBatch, rotate, 0);
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
  // We will now draw the things on top of the tile (trees, houses etc.)
  for (int x = 0; x < mapQuadrants.length; x++) {
    for (int y = 0; y < mapQuadrants[x].length; y++) {
      MapQuadrant? mapQuadrant = mapQuadrants[x][y];
      if (mapQuadrant != null) {
        mapQuadrant.sortTiles();
        for (Tile tile in mapQuadrant.quadrantTiles) {
          tile.renderAttribute(mapQuadrant.spriteBatch, rotate);
        }
      }
    }
  }
  return mapQuadrants;
}