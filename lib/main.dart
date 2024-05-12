import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/bounce_breaker_mania.dart';

void main() {
  final game = BounceBreaker();
  runApp(GameWidget(game: game));
}
