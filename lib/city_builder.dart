import 'package:city_builder/world/world.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'component/mini_map.dart';


class CityBuilder extends FlameGame
    with
        HasTappables,
        HasDraggables,
        ScrollDetector,
        MouseMovementDetector,
        KeyboardEvents {

  // The camera position will always be in the center of the screen
  Vector2 cameraPosition = Vector2.zero();
  Vector2 cameraVelocity = Vector2.zero();

  Vector2 dragAccelerateJoy = Vector2.zero();
  Vector2 dragAccelerateKey = Vector2.zero();

  late final World _world;

  Vector2 dragFrom = Vector2.zero();
  Vector2 dragTo = Vector2.zero();

  late final JoystickComponent joystick;
  late final MiniMapComponent miniMap;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _world = World();
    camera.followVector2(cameraPosition, relativeOffset: Anchor.center);
    add(_world);

    final image = await images.load('joystick_rotate.png');
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 6,
      rows: 1,
    );

    Sprite mapSprite = await loadSprite('map_outline_flat_test.png');

    final knobPaint = BasicPalette.white.withAlpha(50).paint();
    Vector2 miniMapSize = Vector2(180, 90);
    miniMap = MiniMapComponent(
        focussedArea: RectangleComponent(size: Vector2(30, 20), paint: knobPaint),
        totalArea: SpriteComponent(
          sprite: mapSprite,
          size: miniMapSize,
        ),
        rotate: 0,
        margin: const EdgeInsets.only(left: 10, top: 10)
    );
    add(miniMap);

    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: sheet.getSpriteById(1),
        size: Vector2.all(50),
      ),
      background: SpriteComponent(
        sprite: sheet.getSpriteById(0),
        size: Vector2.all(80),
      ),
      margin: const EdgeInsets.only(left: 20, bottom: 20)
    );

    final buttonSize = Vector2.all(40);

    final rotateRightButton = HudButtonComponent(
      button: SpriteComponent(
        sprite: sheet.getSpriteById(2),
        size: buttonSize,
      ),
      buttonDown: SpriteComponent(
        sprite: sheet.getSpriteById(4),
        size: buttonSize,
      ),
      margin: const EdgeInsets.only(
          left: 10,
          bottom: 100
      ),
      onPressed: () {
        rotateRight();
      },
    );
    final rotateLeftButton = HudButtonComponent(
      button: SpriteComponent(
        sprite: sheet.getSpriteById(3),
        size: buttonSize,
      ),
      buttonDown: SpriteComponent(
        sprite: sheet.getSpriteById(5),
        size: buttonSize,
      ),
      margin: const EdgeInsets.only(
          left: 70,
          bottom: 100
      ),
      onPressed: () {
        rotateLeft();
      },
    );

    add(joystick);
    add(rotateLeftButton);
    add(rotateRightButton);
  }

  rotateRight() {
    _world.rotateWorldRight();
    miniMap.rotateMiniMapRight();
    dragTo = Vector2(dragTo.y * 2, -dragTo.x / 2);
  }

  rotateLeft() {
    _world.rotateWorldLeft();
    miniMap.rotateMiniMapLeft();
    dragTo = Vector2(-dragTo.y * 2, dragTo.x / 2);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
  }

  @override
  void onMouseMove(PointerHoverInfo info) {
    super.onMouseMove(info);
  }

  @override
  void onScroll(PointerScrollInfo info) {
    super.onScroll(info);
    double zoomIncrease = (info.raw.scrollDelta.dy/1000);
    camera.zoom *= (1 - zoomIncrease);
    if (camera.zoom <= 0.5) {
      camera.zoom = 0.5;
    } else if (camera.zoom >= 4) {
      camera.zoom = 4;
    }
    print("current zoom: ${camera.zoom}");
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    // TODO: better way to check if it pressed the minimap.
    if (info.eventPosition.global.x < 200 && info.eventPosition.global.y < 120) {
      // super.onTapUp(pointerId, info);
      Vector2 normalized = miniMap.tappedMap(info.eventPosition.global.x, info.eventPosition.global.y);
      setPosition(normalized);
    } else {
      _world.tappedWorld(info.eventPosition.game.x, info.eventPosition.game.y);
    }
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
    super.onTapDown(pointerId, info);
  }

  @override
  void onDragStart(int pointerId, DragStartInfo info) {
    if (info.eventPosition.global.x < 200 && info.eventPosition.global.y < 120) {
      Vector2 normalized = miniMap.tappedMap(info.eventPosition.global.x, info.eventPosition.global.y);
      setPosition(normalized);
    }
    super.onDragStart(pointerId, info);
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    if (info.eventPosition.global.x < 200 && info.eventPosition.global.y < 120) {
      Vector2 normalized = miniMap.tappedMap(info.eventPosition.global.x, info.eventPosition.global.y);
      setPosition(normalized);
    }
    super.onDragUpdate(pointerId, info);
  }

  @override
  void onDragEnd(int pointerId, DragEndInfo info) {
    super.onDragEnd(pointerId, info);
  }

  setPosition(Vector2 normalized) {
    if (normalized.x < 0) {
      dragTo.x = -normalized.x * _world.getBoundLeft();
    } else {
      dragTo.x = normalized.x * _world.getBoundRight();
    }
    if (normalized.y < 0) {
      dragTo.y = normalized.y * _world.getBoundTop();
    } else {
      dragTo.y = -normalized.y * _world.getBoundBottom();
    }
  }

  double frameTimes = 0.0;
  int frames = 0;
  @override
  void update(double dt) {
    super.update(dt);
    dragTo += dragAccelerateJoy;
    dragTo += dragAccelerateKey;

    checkBounds();

    frameTimes += dt;
    frames += 1;
    if (frameTimes > 1) {
      print("fps: $frames");
      frameTimes = 0;
      frames = 0;
    }
    _world.updateWorld(cameraPosition, camera.zoom, size);

    cameraPosition.add(cameraVelocity * dt * 10);

    updateMapScroll();

    dragAccelerateJoy.x = joystick.delta.x / 2;
    dragAccelerateJoy.y = joystick.delta.y / 2;
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

  void checkBounds() {
    if (dragTo.x < _world.getBoundLeft()) {
      dragTo.x = _world.getBoundLeft();
    } else if (dragTo.x > _world.getBoundRight()) {
      dragTo.x = _world.getBoundRight();
    }
    if (dragTo.y > _world.getBoundTop()) {
      dragTo.y = _world.getBoundTop();
    } else if (dragTo.y < _world.getBoundBottom()) {
      dragTo.y = _world.getBoundBottom();
    }
    // We normalize the camera position to a Vector where x: -1 is all the way to the left and x: 1 is all the way to the right (for the minimap)
    if (dragTo.x < 0) {
      miniMap.updateCameraPosX(-dragTo.x / _world.getBoundLeft());
    } else {
      miniMap.updateCameraPosX(dragTo.x / _world.getBoundRight());
    }
    if (dragTo.y < 0) {
      miniMap.updateCameraPosY(-dragTo.y / _world.getBoundBottom());
    } else {
      miniMap.updateCameraPosY(dragTo.y / _world.getBoundTop());
    }
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {
    final isKeyDown = event is RawKeyDownEvent;

    if (event.logicalKey == LogicalKeyboardKey.keyA) {
      dragAccelerateKey.x = isKeyDown ? -10 : 0;
    } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
      dragAccelerateKey.x = isKeyDown ? 10 : 0;
    } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
      dragAccelerateKey.y = isKeyDown ? -10 : 0;
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
      dragAccelerateKey.y = isKeyDown ? 10 : 0;
    }

    return KeyEventResult.handled;
  }
}
