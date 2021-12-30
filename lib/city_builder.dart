import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'component/tile.dart';

class CityBuilder extends FlameGame
    with
        MultiTouchTapDetector,
        MultiTouchDragDetector,
        ScrollDetector,
        KeyboardEvents {

  Vector2 cameraPosition = Vector2.zero();
  Vector2 cameraVelocity = Vector2.zero();

  final Tile _tile1 = Tile(0.0, 0.0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(_tile1);
    camera.followVector2(cameraPosition, relativeOffset: Anchor.topLeft);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void onTapUp(int pointer, TapUpInfo info) {
  }

  @override
  void onTapDown(int pointer, TapDownInfo info) {
  }

  Vector2 dragStart = Vector2.zero();
  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    print("Drag start");
    dragStart = info.eventPosition.game;
    print("x: ${info.eventPosition.game.x} y: ${info.eventPosition.game.y}");
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    double distX = dragStart.x - info.eventPosition.game.x;
    double distY = dragStart.y - info.eventPosition.game.y;
    cameraVelocity.x += distX;
    cameraVelocity.y += distY;
    dragStart = info.eventPosition.game;
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    cameraVelocity.x = 0.0;
    cameraVelocity.y = 0.0;
  }

  @override
  void onScroll(PointerScrollInfo info) {
  }

  @override
  void update(double dt) {
    super.update(dt);
    cameraPosition.add(cameraVelocity * dt * 10);

    cameraPosition.x = cameraPosition.x;
    cameraPosition.y = cameraPosition.y;
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {
    final isKeyDown = event is RawKeyDownEvent;

    if (event.logicalKey == LogicalKeyboardKey.keyA) {
      cameraVelocity.x = isKeyDown ? -1 : 0;
    } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
      cameraVelocity.x = isKeyDown ? 1 : 0;
    } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
      cameraVelocity.y = isKeyDown ? -1 : 0;
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
      cameraVelocity.y = isKeyDown ? 1 : 0;
    } else if (isKeyDown) {
      if (event.logicalKey == LogicalKeyboardKey.keyQ) {
        camera.zoom *= 2;
      } else if (event.logicalKey == LogicalKeyboardKey.keyE) {
        camera.zoom /= 2;
      }
    }

    return KeyEventResult.handled;
  }
}
