import 'package:city_builder/user_interface/mini_map.dart';
import 'package:city_builder/user_interface/user_interface.dart';
import 'package:city_builder/world/world.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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

  String currentTileActive = "Grass";

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    Sprite mapSprite = await loadSprite('map_outline_regions.png');

    miniMap = getMiniMap(mapSprite);

    _world = World();
    camera.followVector2(cameraPosition, relativeOffset: Anchor.center);
    camera.zoom = 1;
    add(_world);

    final image = await images.load('ui.png');
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 10,
      rows: 1,
    );

    joystick = getJoystick(sheet);

    final tileImages = await images.load('flat_1.png');

    final buttonSize = Vector2.all(40);
    final rotateLeftButton = getRotateLeft(sheet, buttonSize, this);
    final rotateRightButton = getRotateRight(sheet, buttonSize, this);
    final zoomInButton = getZoomInButton(sheet, buttonSize, this);
    final zoomOutButton = getZoomOutButton(sheet, buttonSize, this);
    final hudBackgroundLeft = getHudBackgroundLeft();
    final hudBackgroundBottom = getHudBackgroundBottom();
    final grassTileButton = getGrassTileButton(tileImages, this);
    final dirtTileButton = getDirtTileButton(tileImages, this);
    final waterTileButton = getWaterTileButton(tileImages, this);

    Sprite activeTileFlat = await loadSprite('flat_selection.png');

    add(hudBackgroundLeft);
    add(hudBackgroundBottom);
    add(joystick);
    add(rotateLeftButton);
    add(rotateRightButton);
    add(zoomInButton);
    add(zoomOutButton);
    add(grassTileButton);
    add(dirtTileButton);
    add(waterTileButton);
    add(miniMap);
    miniMap.updateZoom(size.x, _world.getWorldWidth());
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

  zoomIn() {
    camera.zoom *= 1.1;
    if (camera.zoom >= 4) {
      camera.zoom = 4;
    }
    miniMap.updateZoom(size.x, _world.getWorldWidth());
  }

  zoomOut() {
    camera.zoom *= 0.9;
    if (camera.zoom <= 1) {
      camera.zoom = 1;
    }
    miniMap.updateZoom(size.x, _world.getWorldWidth());
  }

  pressedGrassTile() {
    if (currentTileActive != "Grass") {
      currentTileActive = "Grass";
    }
  }

  pressedDirtTile() {
    if (currentTileActive != "Dirt") {
      currentTileActive = "Dirt";
    }
  }

  pressedWaterTile() {
    if (currentTileActive != "Water") {
      currentTileActive = "Water";
    }
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
    if (camera.zoom <= 1) {
      camera.zoom = 1;
    } else if (camera.zoom >= 4) {
      camera.zoom = 4;
    }
    print("current zoom: ${camera.zoom}");
    miniMap.updateZoom(size.x, _world.getWorldWidth());
  }

  @override
  void onTapUp(int pointerId, TapUpInfo info) {
    print("on tapped up! ${info.eventPosition.global}");
    // TODO: better way to check if it pressed the minimap.
    if (info.eventPosition.global.x < 200 && info.eventPosition.global.y < 120) {
      Vector2 normalized = miniMap.tappedMap(info.eventPosition.global.x, info.eventPosition.global.y);
      setPosition(normalized);
    } else if (info.eventPosition.global.x < 200) {
      // pressed HUD
    } else if (info.eventPosition.global.y > (size.y * camera.zoom) - 100) {
      // pressed HUD
    } else {
      _world.tappedWorld(info.eventPosition.game.x, info.eventPosition.game.y, currentTileActive);
    }
    super.onTapUp(pointerId, info);
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
    } else if (info.eventPosition.global.x < 200) {
      // pressed HUD
    }
    super.onDragStart(pointerId, info);
  }

  @override
  void onDragUpdate(int pointerId, DragUpdateInfo info) {
    if (info.eventPosition.global.x < 200 && info.eventPosition.global.y < 120) {
      Vector2 normalized = miniMap.tappedMap(info.eventPosition.global.x, info.eventPosition.global.y);
      setPosition(normalized);
    } else if (info.eventPosition.global.x < 200) {
      // pressed HUD
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
  int variant = 0;
  @override
  void update(double dt) {
    super.update(dt);
    dragTo += dragAccelerateJoy;
    dragTo += dragAccelerateKey;

    // checkBounds();

    frameTimes += dt;
    frames += 1;
    // ugly way to determine animation variants. We have have 5 animation variants per seconds
    if ((frameTimes > 0 && frameTimes <= 0.5) && variant != 0) {
      variant = 0;
      _world.updateVariant(variant);
      // print("variant 0");
    } else if ((frameTimes > 0.5 && frameTimes <= 1) && variant != 1) {
      variant = 1;
      _world.updateVariant(variant);
      // print("variant 1");
    }
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

  @override
  void onGameResize(Vector2 canvasSize) {
    // This needs to be done to position the HUD margin components correctly.
    double previousZoom = camera.zoom;
    camera.zoom = 1;
    super.onGameResize(canvasSize);
    camera.zoom = previousZoom;
  }
}
