import 'dart:async';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'city_builder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();

  Flame.images.loadAll(<String>[
    'flat_grass_1.png',
    'flat_dirt_1.png',
    'flat_water_1.png',
    'point_grass_1.png',
    'point_dirt_1.png',
    'point_water_1.png',
    'flat_sheet.png'
  ]);

  final game = CityBuilder();

  runApp(GameWidget(game: game));
}
