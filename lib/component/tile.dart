import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/input.dart';

class Tile {

  late Vector2 position;
  late int q;
  late int r;
  late int s;

  // We assume the condition r + s + q = 0 is true.
  Tile(this.q, this.r, this.s, this.position);

  Vector2 getPos() {
    return position;
  }

}