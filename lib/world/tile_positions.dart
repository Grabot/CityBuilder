import 'dart:math';
import 'package:flame/components.dart';
import '../component/tile.dart';


List<List<int>> worldDetail = [
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0],
  [0, 0, 1, 2, 2, 1, 2, 1, 1, 0, 0],
  [0, 0, 1, 1, 2, 2, 2, 2, 1, 0, 0],
  [0, 0, 1, 2, 2, 2, 2, 2, 2, 0, 0],
  [0, 0, 0, 1, 2, 2, 2, 2, 1, 0, 0],
  [0, 0, 0, 0, 1, 2, 2, 2, 1, 0, 0],
  [0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
];

List<List<Tile?>> setTilePositionsFlat(List<List<Tile?>> tiles, double xSize, double ySize) {

  for (int q = -(tiles.length/2).ceil(); q < (tiles.length/2).floor(); q++) {
    for (int r = -(tiles[0].length/2).ceil(); r < (tiles[0].length/2).floor(); r++) {
      // Simple check to ensure the map is hexagonal. It makes the map rotations look better
      if (((q + r) >= -((tiles.length/2).ceil() + 1)) && ((q + r) < (tiles.length/2).floor() - 1)) {
        int s = (q + r) * -1;
        int qArray = q + (tiles.length / 2).ceil();
        int rArray = r + (tiles[0].length / 2).ceil();
        double xPos = xSize * 3 / 2 * q - xSize;
        double yTr1 = ySize * (sqrt(3) / 2 * q);
        yTr1 *= -1; // The y axis gets positive going down, so we flip it.
        double yTr2 = ySize * (sqrt(3) * r);
        yTr2 *= -1; // The y axis gets positive going down, so we flip it.
        double yPos = yTr1 + yTr2 - ySize;
        Vector2 position = Vector2(xPos, yPos);
        Tile tile = Tile(q, r, s, worldDetail[qArray][rArray]);
        tile.setPositionFlat(position);
        if (tiles[qArray][rArray] != null) {
          tiles[qArray][rArray]!.setPositionFlat(position);
        } else {
          tiles[qArray][rArray] = tile;
        }
      }
    }
  }
  return tiles;
}

List<List<Tile?>> setTilePositionsPoint(List<List<Tile?>> tiles, double xSize, double ySize) {

  for (int q = -(tiles.length/2).ceil(); q < (tiles.length/2).floor(); q++) {
    for (int r = -(tiles[0].length/2).ceil(); r < (tiles[0].length/2).floor(); r++) {
      // Simple check to ensure the map is hexagonal. It makes the map rotations look better
      if (((q + r) >= -((tiles.length/2).ceil() + 1)) && ((q + r) < (tiles.length/2).floor() - 1)) {
        int s = (q + r) * -1;
        int qArray = q + (tiles.length / 2).ceil();
        int rArray = r + (tiles[0].length / 2).ceil();
        double xPos = xSize * (sqrt(3) * q + sqrt(3) / 2 * r) - xSize;
        double yPos = ySize * 3 / 2 * r;
        yPos *= -1;
        yPos -= ySize;
        Vector2 position = Vector2(xPos, yPos);
        Tile tile = Tile(q, r, s, worldDetail[qArray][rArray]);
        tile.setPositionPoint(position);
        if (tiles[qArray][rArray] != null) {
          tiles[qArray][rArray]!.setPositionPoint(position);
        } else {
          tiles[qArray][rArray] = tile;
        }
      }
    }
  }
  return tiles;
}
