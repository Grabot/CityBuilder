import 'package:city_builder/world/world.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CityBuilder extends FlameGame
    with
        MultiTouchTapDetector,
        MultiTouchDragDetector,
        ScrollDetector,
        KeyboardEvents {

  Vector2 cameraPosition = Vector2.zero();
  Vector2 cameraVelocity = Vector2.zero();

  final World _world = World();

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(_world);
    camera.followVector2(cameraPosition, relativeOffset: Anchor.topLeft);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  Vector2 dragFrom = Vector2.zero();
  Vector2 dragTo = Vector2.zero();
  @override
  void onTapUp(int pointer, TapUpInfo info) {
  }

  @override
  void onTapDown(int pointer, TapDownInfo info) {
  }

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    dragTo = Vector2(cameraPosition.x, cameraPosition.y);
    dragFrom = info.eventPosition.game;
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    dragTo.sub(info.eventPosition.game-dragFrom);
    dragFrom = info.eventPosition.game;
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
  }

  @override
  void onScroll(PointerScrollInfo info) {
    print("scrolling!");
  }

  @override
  void update(double dt) {
    super.update(dt);
    cameraPosition.add(cameraVelocity * dt * 10);

    cameraPosition.x = cameraPosition.x;
    cameraPosition.y = cameraPosition.y;

    updateMapScroll();
  }

  void updateMapScroll() {
    if ((dragTo.x - cameraPosition.x).abs() < 0.2) {
      cameraPosition.x = dragTo.x;
      cameraVelocity.x = 0;
    } else {
      cameraVelocity.x = (dragTo.x - cameraPosition.x);
    }

    if ((dragTo.y - cameraPosition.y).abs() < 0.2) {
      cameraPosition.y = dragTo.y;
      cameraVelocity.y = 0;
    } else {
      cameraVelocity.y = (dragTo.y - cameraPosition.y);
    }
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {
    final isKeyDown = event is RawKeyDownEvent;

    if (isKeyDown) {
      if (event.logicalKey == LogicalKeyboardKey.keyA) {
        dragTo.x += 40;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyD) {
        dragTo.x -= 40;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyW) {
        dragTo.y += 40;
      }
      if (event.logicalKey == LogicalKeyboardKey.keyS) {
        dragTo.y -= 40;
      }

      if (event.logicalKey == LogicalKeyboardKey.keyQ) {
        camera.zoom *= 2;
      } else if (event.logicalKey == LogicalKeyboardKey.keyE) {
        camera.zoom /= 2;
      }
    }

    return KeyEventResult.handled;
  }
}
