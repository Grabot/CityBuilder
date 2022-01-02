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

  Vector2 dragFrom = Vector2.zero();
  Vector2 dragTo = Vector2.zero();
  bool singleTap = false;
  bool multiTap = false;
  int multiPointer1Id = -1;
  int multiPointer2Id = -1;
  Vector2 multiPointer1 = Vector2.zero();
  Vector2 multiPointer2 = Vector2.zero();
  double multiPointerDist = 0.0;
  int movementBlock = 0;

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

  @override
  void onScroll(PointerScrollInfo info) {
    double zoomIncrease = (info.raw.scrollDelta.dy/1000);
    camera.zoom *= (1 - zoomIncrease);
    if (camera.zoom <= 0.25) {
      camera.zoom = 0.25;
    } else if (camera.zoom >= 4) {
      camera.zoom = 4;
    }
  }

  @override
  void onTapUp(int pointer, TapUpInfo info) {
  }

  @override
  void onTapDown(int pointer, TapDownInfo info) {
    // Move camera point (0, 0) (top left) to the clicked position
    // dragFrom = info.eventPosition.game;
    // dragTo = Vector2(cameraPosition.x, cameraPosition.y);
    // dragTo.sub(dragFrom);
  }

  Vector2 multiTouch1 = Vector2.zero();
  Vector2 multiTouch2 = Vector2.zero();

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    if (singleTap) {
      multiTap = true;
      multiPointer2Id = pointerId;
    } else {
      singleTap = true;
      multiPointer1Id = pointerId;
    }
    dragTo = Vector2(cameraPosition.x, cameraPosition.y);
    dragFrom = info.eventPosition.game;
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {

    if (multiTap) {
      if (pointerId == multiPointer1Id) {
        multiPointer1 = info.eventPosition.game;
      } else if (pointerId == multiPointer2Id) {
        multiPointer2 = info.eventPosition.game;
      } else {
        // A third finger is touching the screen?
      }
      if ((multiPointer1.x != 0 && multiPointer1.y != 0) && (multiPointer2.x != 0 && multiPointer2.y != 0))  {
        handlePinchZoom();
      }
    } else {
      // The user is zooming, so not moving around
      if (movementBlock <= 0) {
        dragTo.sub(info.eventPosition.game - dragFrom);
        dragFrom = info.eventPosition.game;
      }
    }
  }

  void handlePinchZoom() {
    double currentDistance = multiPointer1.distanceTo(multiPointer2);
    double zoomIncrease = (currentDistance - multiPointerDist);
    print("zoom increase: $zoomIncrease");
    double cameraZoom = 1;
    if (zoomIncrease > -50 && zoomIncrease <= -1) {
      cameraZoom += (zoomIncrease / 400);
    } else if (zoomIncrease < 50 && zoomIncrease >= 1) {
      cameraZoom += (zoomIncrease / 400);
    }
    camera.zoom *= cameraZoom;
    if (camera.zoom <= 0.25) {
      camera.zoom = 0.25;
    } else if (camera.zoom >= 4) {
      camera.zoom = 4;
    }
    multiPointerDist = currentDistance;
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    singleTap = false;
    if (multiTap) {
      multiTap = false;
      movementBlock = 20;
    }
    multiPointer1Id = -1;
    multiPointer2Id = -1;
    multiPointer1 = Vector2.zero();
    multiPointer2 = Vector2.zero();
    multiPointerDist = 0.0;
    // Check if it crossed the game boundaries and put it back if that is the case.
    // TODO: Improve boundaries with zoom added.
    if (dragTo.x < -1000) {
      dragTo.x = -1000;
    } else if (dragTo.x > 1000) {
      dragTo.x = 1000;
    }

    if (dragTo.y < -1000) {
      dragTo.y = -1000;
    } else if (dragTo.y > 1000) {
      dragTo.y = 1000;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    cameraPosition.add(cameraVelocity * dt * 10);

    cameraPosition.x = cameraPosition.x;
    cameraPosition.y = cameraPosition.y;
    updateMapScroll();

    if (movementBlock > 0) {
      movementBlock -= 1;
    } else {
      movementBlock = 0;
    }
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
      if (camera.zoom <= 0.25) {
        camera.zoom = 0.25;
      } else if (camera.zoom >= 4) {
        camera.zoom = 4;
      }
    }

    return KeyEventResult.handled;
  }
}
