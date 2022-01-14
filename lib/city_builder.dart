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
        MultiTouchTapDetector,
        MultiTouchDragDetector,
        ScrollDetector,
        MouseMovementDetector,
        KeyboardEvents {

  // The camera position will always be in the center of the screen
  Vector2 cameraPosition = Vector2.zero();
  Vector2 cameraVelocity = Vector2.zero();

  late final World _world;

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

  Vector2 multiTouch1 = Vector2.zero();
  Vector2 multiTouch2 = Vector2.zero();

  late final JoystickComponent joystick;
  late final TextComponent speedText;
  late final TextComponent directionText;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _world = World();
    camera.followVector2(cameraPosition, relativeOffset: Anchor.center);
    add(_world);

    final image = await images.load('joystick.png');
    final sheet = SpriteSheet.fromColumnsAndRows(
      image: image,
      columns: 6,
      rows: 1,
    );
    joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: sheet.getSpriteById(1),
        size: Vector2.all(100),
      ),
      background: SpriteComponent(
        sprite: sheet.getSpriteById(0),
        size: Vector2.all(150),
      ),
      margin: const EdgeInsets.only(left: 40, bottom: 40),
    );

    final buttonSize = Vector2.all(80);
    // A button with margin from the edge of the viewport that flips the
    // rendering of the player on the X-axis.
    final flipButton = HudButtonComponent(
      button: SpriteComponent(
        sprite: sheet.getSpriteById(2),
        size: buttonSize,
      ),
      buttonDown: SpriteComponent(
        sprite: sheet.getSpriteById(4),
        size: buttonSize,
      ),
      margin: const EdgeInsets.only(
        right: 80,
        bottom: 60,
      ),
      onPressed: () {
        print("pressed something");
      },
    );

    // A button with margin from the edge of the viewport that flips the
    // rendering of the player on the Y-axis.
    final flopButton = HudButtonComponent(
      button: SpriteComponent(
        sprite: sheet.getSpriteById(3),
        size: buttonSize,
      ),
      buttonDown: SpriteComponent(
        sprite: sheet.getSpriteById(5),
        size: buttonSize,
      ),
      margin: const EdgeInsets.only(
        right: 160,
        bottom: 60,
      ),
      onPressed: () {
        print("pressed another thing");
      },
    );

    // A button, created from a shape, that adds a rotation effect to the player
    // when it is pressed.
    final shapeButton = HudButtonComponent(
      button: CircleComponent(radius: 35),
      buttonDown: RectangleComponent(
        size: buttonSize,
        paint: BasicPalette.blue.paint(),
      ),
      margin: const EdgeInsets.only(
        right: 85,
        bottom: 150,
      ),
      onPressed: () {
        print("pressed yet another thing");
      },
    );

    final _regular = TextPaint(
      style: TextStyle(color: BasicPalette.white.color),
    );
    speedText = TextComponent(
      text: 'Speed: 0',
      textRenderer: _regular,
    )..positionType = PositionType.viewport;
    directionText = TextComponent(
      text: 'Direction: idle',
      textRenderer: _regular,
    )..positionType = PositionType.viewport;

    add(joystick);
    add(flipButton);
    add(flopButton);
    add(shapeButton);
  }

  static final _text = TextPaint(
    style: TextStyle(color: BasicPalette.red.color, fontSize: 12),
  );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    Paint buttonPaint = Paint();
    buttonPaint.style = PaintingStyle.fill;
    buttonPaint.color = const Color.fromRGBO(126, 0, 255, 1.0);

    Rect worldRect = Rect.fromLTRB(0, 0, 50, 50);
    canvas.drawRect(worldRect, buttonPaint);
    _text.render(
      canvas,
      "rotate",
      Vector2(25, 25),
      anchor: Anchor.center
    );

  }

  @override
  void onMouseMove(PointerHoverInfo info) {
  }

  @override
  void onScroll(PointerScrollInfo info) {
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
    if (info.eventPosition.global.x < 50 && info.eventPosition.global.y < 50) {
      print("pressed ugly button thing");
      _world.rotateWorld();
    } else {
      _world.tappedWorld(info.eventPosition.game.x, info.eventPosition.game.y);
    }
  }

  @override
  void onTapDown(int pointerId, TapDownInfo info) {
  }

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
    _world.clearSelectedTile();
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
    if (camera.zoom <= 0.5) {
      camera.zoom = 0.5;
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
    // if (dragTo.x < -1000) {
    //   dragTo.x = -1000;
    // } else if (dragTo.x > 1000) {
    //   dragTo.x = 1000;
    // }
    //
    // if (dragTo.y < -1000) {
    //   dragTo.y = -1000;
    // } else if (dragTo.y > 1000) {
    //   dragTo.y = 1000;
    // }
  }

  double frameTimes = 0.0;
  int frames = 0;
  @override
  void update(double dt) {
    super.update(dt);
    dragTo.x += dragAccelerate.x;
    dragTo.y += dragAccelerate.y;

    frameTimes += dt;
    frames += 1;
    if (frameTimes > 1) {
      print("fps: $frames");
      frameTimes = 0;
      frames = 0;
    }
    _world.updateWorld(cameraPosition, camera.zoom, size);

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

  Vector2 dragAccelerate = Vector2.zero();
  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event,
      Set<LogicalKeyboardKey> keysPressed,
      ) {
    final isKeyDown = event is RawKeyDownEvent;

    if (event.logicalKey == LogicalKeyboardKey.keyA) {
      dragAccelerate.x = isKeyDown ? -10 : 0;
    } else if (event.logicalKey == LogicalKeyboardKey.keyD) {
      dragAccelerate.x = isKeyDown ? 10 : 0;
    } else if (event.logicalKey == LogicalKeyboardKey.keyW) {
      dragAccelerate.y = isKeyDown ? -10 : 0;
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
      dragAccelerate.y = isKeyDown ? 10 : 0;
    }

    return KeyEventResult.handled;
  }
}
