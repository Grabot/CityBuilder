import 'package:city_builder/component/get_texture.dart';
import 'package:city_builder/user_interface/hud_background.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/cupertino.dart';

import '../city_builder.dart';
import 'mini_map.dart';


JoystickComponent getJoystick(SpriteSheet sheet) {
  JoystickComponent joystick = JoystickComponent(
      knob: SpriteComponent(
        sprite: sheet.getSpriteById(5),
        size: Vector2.all(100),
      ),
      background: SpriteComponent(
        sprite: sheet.getSpriteById(0),
        size: Vector2.all(150),
      ),
      margin: const EdgeInsets.only(left: 20, bottom: 20)
  );
  return joystick;
}


HudButtonComponent getRotateLeft(SpriteSheet sheet, Vector2 buttonSize, CityBuilder cityBuilder) {
  HudButtonComponent rotateLeftButton = HudButtonComponent(
    button: SpriteComponent(
      sprite: sheet.getSpriteById(1),
      size: buttonSize,
    ),
    buttonDown: SpriteComponent(
      sprite: sheet.getSpriteById(2),
      size: buttonSize,
    ),
    margin: const EdgeInsets.only(left: 5, bottom: 160),
    onPressed: () {
      cityBuilder.rotateLeft();
    },
  );
  return rotateLeftButton;
}


HudButtonComponent getRotateRight(SpriteSheet sheet, Vector2 buttonSize, CityBuilder cityBuilder) {
  HudButtonComponent rotateRightButton = HudButtonComponent(
    button: SpriteComponent(
      sprite: sheet.getSpriteById(3),
      size: buttonSize,
    ),
    buttonDown: SpriteComponent(
      sprite: sheet.getSpriteById(4),
      size: buttonSize,
    ),
    margin: const EdgeInsets.only(left: 45, bottom: 180),
    onPressed: () {
      cityBuilder.rotateRight();
    },
  );
  return rotateRightButton;
}

HudButtonComponent getZoomInButton(SpriteSheet sheet, Vector2 buttonSize, CityBuilder cityBuilder) {
  HudButtonComponent zoomInButton = HudButtonComponent(
    button: SpriteComponent(
      sprite: sheet.getSpriteById(6),
      size: buttonSize,
    ),
    buttonDown: SpriteComponent(
      sprite: sheet.getSpriteById(7),
      size: buttonSize,
    ),
    margin: const EdgeInsets.only(left: 105, bottom: 180),
    onPressed: () {
      cityBuilder.zoomIn();
    },
  );
  return zoomInButton;
}

HudButtonComponent getZoomOutButton(SpriteSheet sheet, Vector2 buttonSize, CityBuilder cityBuilder) {
  HudButtonComponent zoomOutButton = HudButtonComponent(
    button: SpriteComponent(
      sprite: sheet.getSpriteById(8),
      size: buttonSize,
    ),
    buttonDown: SpriteComponent(
      sprite: sheet.getSpriteById(9),
      size: buttonSize,
    ),
    margin: const EdgeInsets.only(left: 145, bottom: 160),
    onPressed: () {
      cityBuilder.zoomOut();
    },
  );
  return zoomOutButton;
}

MiniMapComponent getMiniMap(Sprite mapSprite) {

  final knobPaint = BasicPalette.white.withAlpha(50).paint();
  Vector2 miniMapSize = Vector2(180, 90);
  MiniMapComponent miniMap = MiniMapComponent(
      focussedArea: RectangleComponent(size: miniMapSize, paint: knobPaint),
      totalArea: SpriteComponent(
        sprite: mapSprite,
        size: miniMapSize,
      ),
      rotate: 0,
      margin: const EdgeInsets.only(left: 10, top: 10)
  );
  return miniMap;
}

HudBackgroundLeft getHudBackgroundLeft() {
  HudBackgroundLeft hudBackground = HudBackgroundLeft(
      backgroundLeft: RectangleComponent(
          size: Vector2(200, 2000),
          // paint: const PaletteEntry(Color(0xFF797979)).withAlpha(100).paint()
          paint: const PaletteEntry(Color(0xFF797979)).paint()
      ),
      margin: const EdgeInsets.only(left: 10, bottom: 10)
  );
  return hudBackground;
}

HudBackgroundBottom getHudBackgroundBottom() {
  HudBackgroundBottom hudBackground = HudBackgroundBottom(
      backgroundBottom: RectangleComponent(
          size: Vector2(2000, 100),
          // paint: const PaletteEntry(Color(0xFF797979)).withAlpha(100).paint()
          paint: const PaletteEntry(Color(0xFF797979)).paint()
      ),
      margin: const EdgeInsets.only(left: 10, bottom: 10)
  );
  return hudBackground;
}

HudButtonComponent getGrassTileButton(var tileImages, CityBuilder cityBuilder) {

  Vector2 buttonSize = Vector2(64, 28);

  Vector2 tilePos1 = Vector2(flatSmallGrass1.left, flatSmallGrass1.top);
  Vector2 tileSize1 = Vector2(flatSmallGrass1.width, flatSmallGrass1.height);
  Sprite tileSprites1 = Sprite(
      tileImages,
      srcPosition: tilePos1,
      srcSize: tileSize1
  );

  Vector2 tilePos2 = Vector2(flatSmallGrass2.left, flatSmallGrass2.top);
  Vector2 tileSize2 = Vector2(flatSmallGrass2.width, flatSmallGrass2.height);
  Sprite tileSprites2 = Sprite(
      tileImages,
      srcPosition: tilePos2,
      srcSize: tileSize2
  );

  HudButtonComponent grassTileButton = HudButtonComponent(
    button: SpriteComponent(
      sprite: tileSprites1,
      size: buttonSize,
    ),
    buttonDown: SpriteComponent(
      sprite: tileSprites2,
      size: buttonSize,
    ),
    margin: const EdgeInsets.only(left: 250, bottom: 40),
    onPressed: () {
      cityBuilder.pressedGrassTile();
    },
  );
  return grassTileButton;
}

HudButtonComponent getDirtTileButton(var tileImages, CityBuilder cityBuilder) {

  Vector2 buttonSize = Vector2(64, 28);

  Vector2 tilePos1 = Vector2(flatSmallDirt1.left, flatSmallDirt1.top);
  Vector2 tileSize1 = Vector2(flatSmallDirt1.width, flatSmallDirt1.height);
  Sprite tileSprites1 = Sprite(
      tileImages,
      srcPosition: tilePos1,
      srcSize: tileSize1
  );

  Vector2 tilePos2 = Vector2(flatSmallDirt1.left, flatSmallDirt1.top);
  Vector2 tileSize2 = Vector2(flatSmallDirt1.width, flatSmallDirt1.height);
  Sprite tileSprites2 = Sprite(
      tileImages,
      srcPosition: tilePos2,
      srcSize: tileSize2
  );

  HudButtonComponent grassTileButton = HudButtonComponent(
    button: SpriteComponent(
      sprite: tileSprites1,
      size: buttonSize,
    ),
    buttonDown: SpriteComponent(
      sprite: tileSprites2,
      size: buttonSize,
    ),
    margin: const EdgeInsets.only(left: 350, bottom: 40),
    onPressed: () {
      cityBuilder.pressedDirtTile();
    },
  );
  return grassTileButton;
}

HudButtonComponent getWaterTileButton(var tileImages, CityBuilder cityBuilder) {

  Vector2 buttonSize = Vector2(64, 28);

  Vector2 tilePos1 = Vector2(flatSmallWater1.left, flatSmallWater1.top);
  Vector2 tileSize1 = Vector2(flatSmallWater1.width, flatSmallWater1.height);
  Sprite tileSprites1 = Sprite(
      tileImages,
      srcPosition: tilePos1,
      srcSize: tileSize1
  );

  Vector2 tilePos2 = Vector2(flatSmallWater2.left, flatSmallWater2.top);
  Vector2 tileSize2 = Vector2(flatSmallWater2.width, flatSmallWater2.height);
  Sprite tileSprites2 = Sprite(
      tileImages,
      srcPosition: tilePos2,
      srcSize: tileSize2
  );

  HudButtonComponent waterTileButton = HudButtonComponent(
    button: SpriteComponent(
      sprite: tileSprites1,
      size: buttonSize,
    ),
    buttonDown: SpriteComponent(
      sprite: tileSprites2,
      size: buttonSize,
    ),
    margin: const EdgeInsets.only(left: 450, bottom: 40),
    onPressed: () {
      cityBuilder.pressedWaterTile();
    },
  );
  return waterTileButton;
}

ActiveTile getActiveTileGrass(Sprite activeTileFlat) {

  Vector2 activeTileSize = Vector2(64, 32);
  ActiveTile activeTileGrass = ActiveTile(
      activeTile: SpriteComponent(
        sprite: activeTileFlat,
        size: activeTileSize,
      ),
      margin: const EdgeInsets.only(left: 250, bottom: 40),
  );
  return activeTileGrass;
}

ActiveTile getActiveTileDirt(Sprite activeTileFlat) {

  Vector2 activeTileSize = Vector2(64, 32);
  ActiveTile activeTileDirt = ActiveTile(
    activeTile: SpriteComponent(
      sprite: activeTileFlat,
      size: activeTileSize,
    ),
    margin: const EdgeInsets.only(left: 350, bottom: 40),
  );
  return activeTileDirt;
}

ActiveTile getActiveTileWater(Sprite activeTileFlat) {

  Vector2 activeTileSize = Vector2(64, 32);
  ActiveTile activeTileWater = ActiveTile(
    activeTile: SpriteComponent(
      sprite: activeTileFlat,
      size: activeTileSize,
    ),
    margin: const EdgeInsets.only(left: 450, bottom: 40),
  );
  return activeTileWater;
}

class ActiveTile extends HudMarginComponent {
  late final PositionComponent activeTile;

  ActiveTile({
    required this.activeTile,
    EdgeInsets? margin,
    Vector2? position,
    double? size,
    Anchor anchor = Anchor.center,
  })  :
        super(
        margin: margin,
        position: position,
        size: activeTile.size,
        anchor: anchor,
      );

  @override
  @mustCallSuper
  void onMount() {
    add(activeTile);
    super.onMount();
  }
}

