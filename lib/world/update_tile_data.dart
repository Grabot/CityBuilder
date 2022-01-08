

import 'package:city_builder/component/tile.dart';
import 'package:flame/sprite.dart';

updateTileData(List<List<Tile?>> tiles, int rotate, SpriteBatch spriteBatch) {

  List<SpriteBatch> spriteBatches;
  for (int q = -(tiles.length/2).ceil(); q < (tiles.length/2).floor(); q++) {
    for (int r = -(tiles[0].length/2).ceil(); r < (tiles[0].length/2).floor(); r++) {
      int qArray = q + (tiles.length/2).ceil();
      int rArray = r + (tiles[0].length/2).ceil();
      if (tiles[qArray][rArray] != null) {
        // This seems to give much better performance.
        // The idea would be to divide the map in quadrants that the sprite batches will draw
        // If the user is playing on a certain part of the map, the other parts don't have to be drawn
        // If the user zooms out we will draw them all, if the user zooms in we will stop drawing certain quadrants.
        // The batches are only for the tiles, which will not change position or main type.
        if (tiles[qArray][rArray]!.getPos(rotate).x > -1000 &&
            tiles[qArray][rArray]!.getPos(rotate).x < 1000) {
          if (tiles[qArray][rArray]!.getPos(rotate).y > -500 &&
              tiles[qArray][rArray]!.getPos(rotate).y < 500) {
            tiles[qArray][rArray]!.renderTile(spriteBatch, rotate);
          }
        }
      }
    }
  }
  return spriteBatch;
}