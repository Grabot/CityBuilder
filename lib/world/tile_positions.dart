import 'dart:math';
import 'package:flame/components.dart';
import '../component/tile.dart';


List<List<Tile?>> setTilePositionsFlat(List<List<Tile?>> tiles, double xSize, double ySize, int qSizeHalf, int rSizeHalf) {

  for (int q = -qSizeHalf; q <= qSizeHalf-1; q++) {
    for (int r = -rSizeHalf; r <= rSizeHalf-1; r++) {
      int s = (q + r) * -1;
      double xPos = xSize * 3 / 2 * q - xSize;
      double yTr1 = ySize * (sqrt(3) / 2 * q);
      yTr1 *= -1;  // The y axis gets positive going down, so we flip it.
      double yTr2 = ySize * (sqrt(3) * r);
      yTr2 *= -1;  // The y axis gets positive going down, so we flip it.
      double yPos = yTr1 + yTr2 - ySize;
      Vector2 position = Vector2(xPos, yPos);
      Tile tile = Tile(q, r, s);
      tile.setPositionFlat(position);
      int qArray = q + qSizeHalf;
      int rArray = r + rSizeHalf;
      if (tiles[qArray][rArray] != null) {
        tiles[qArray][rArray]!.setPositionFlat(position);
      } else {
        tiles[qArray][rArray] = tile;
      }
    }
  }
  return tiles;
}

List<List<Tile?>> setTilePositionsPoint(List<List<Tile?>> tiles, double xSize, double ySize, int qSizeHalf, int rSizeHalf) {

  for (int q = -qSizeHalf; q <= qSizeHalf-1; q++) {
    for (int r = -rSizeHalf; r <= rSizeHalf-1; r++) {
      int s = (q + r) * -1;
      double xPos = xSize * (sqrt(3) * q + sqrt(3) / 2 * r) - xSize;
      double yPos = ySize * 3 / 2 * r;
      yPos *= -1;
      yPos -= ySize;
      Vector2 position = Vector2(xPos, yPos);
      Tile tile = Tile(q, r, s);
      tile.setPositionPoint(position);
      int qArray = q + qSizeHalf;
      int rArray = r + rSizeHalf;
      if (tiles[qArray][rArray] != null) {
        tiles[qArray][rArray]!.setPositionPoint(position);
      } else {
        tiles[qArray][rArray] = tile;
      }
    }
  }
  return tiles;
}
