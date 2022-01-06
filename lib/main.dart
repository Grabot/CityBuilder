import 'dart:async';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'city_builder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();

  Flame.images.loadAll(<String>[
    'tile_grass_flat.png',
    'tile_dirt_flat.png',
    'tile_water_flat.png',
    'tile_grass_point.png',
    'tile_dirt_point.png',
    'tile_water_point.png'
  ]);

  final game = CityBuilder();

  runApp(GameWidget(game: game));
}
