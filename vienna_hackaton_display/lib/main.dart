import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';
import 'package:vienna_hackaton_display/ojda_world.dart';

void main() async {
  runApp(
    GameWidget(
      game: Forge2DGame(
        world: OjdaWorld(),
        zoom: 1,
      ),
    ),
  );
}
