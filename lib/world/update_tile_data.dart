

import 'package:city_builder/component/tile.dart';
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
