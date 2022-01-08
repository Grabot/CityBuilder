import 'dart:async';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'city_builder.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.setLandscape();

  Flame.images.loadAll(<String>[
    'flat_sheet.png',
    'point_sheet.png'
  ]);

  final game = CityBuilder();

  runApp(GameWidget(game: game));
}
