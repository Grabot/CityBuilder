import 'dart:math';
import 'package:city_builder/component/map_quadrant.dart';
import 'package:city_builder/component/selected_tile_flat.dart';
import 'package:city_builder/component/selected_tile_point.dart';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flame/sprite.dart';

class SelectedTile {

  SelectedTileFlat selectedTileFlat;
  SelectedTilePoint selectedTilePoint;

  Vector2 position = Vector2.zero();

  SelectedTile(this.selectedTileFlat, this.selectedTilePoint) : super();

  setPosition(Vector2 pos, int rotate) {
    if (rotate == 0 || rotate == 2) {
      selectedTileFlat.show = true;
      selectedTilePoint.show = false;
      selectedTileFlat.setPosition(pos);
    } else {
      selectedTileFlat.show = false;
      selectedTilePoint.show = true;
      selectedTilePoint.setPosition(pos);
    }
  }

  clearSelection() {
    selectedTileFlat.show = false;
    selectedTilePoint.show = false;
  }
}