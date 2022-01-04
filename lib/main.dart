import 'dart:async';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'city_builder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();

  Flame.images.loadAll(<String>[
    'tile_test_2.png',
    'tile_test_3.png',
  ]);

  final game = CityBuilder();

  runApp(GameWidget(game: game));
}
