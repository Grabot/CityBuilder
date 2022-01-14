import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/extensions.dart';


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

class SelectedTileFlat extends SpriteComponent with HasGameRef {

  bool show = true;

  SelectedTileFlat()
      : super(
      size: Vector2(2 * 16, sqrt(3) * 8)
  );

  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('flat_selection.png');
    position = Vector2(-17, -8);
  }

  setPosition(Vector2 tilePos) {
    position = tilePos;
  }

  @override
  void render(Canvas canvas) {
    if (show) {
      super.render(canvas);
    }
  }
}

class SelectedTilePoint extends SpriteComponent with HasGameRef {

  bool show = false;

  SelectedTilePoint()
      : super(
      size: Vector2(sqrt(3) * 17, 2 * 8)
  );


  @override
  Future<void> onLoad() async {
    super.onLoad();
    sprite = await gameRef.loadSprite('point_selection.png');
    position = Vector2(-17, -8);
  }

  setPosition(Vector2 tilePos) {
    position = tilePos;
  }

  @override
  void render(Canvas canvas) {
    if (show) {
      super.render(canvas);
    }
  }
}