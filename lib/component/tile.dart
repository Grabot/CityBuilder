import 'package:flame/components.dart';
import 'package:flame/input.dart';

class Tile {

  late Vector2 positionFlat;
  late Vector2 positionPoint;
  late int q;
  late int r;
  late int s;

  late int tileProperty;

  // We assume the condition r + s + q = 0 is true.
  Tile(this.q, this.r, this.s, this.tileProperty);

  setPositionFlat(Vector2 flat) {
    positionFlat = flat;
  }

  setPositionPoint(Vector2 point) {
    positionPoint = point;
  }

  Vector2 getPosFlat() {
    return positionFlat;
  }

  Vector2 getPosPoint() {
    return positionPoint;
  }

  int getTileProperty() {
    return tileProperty;
  }

}