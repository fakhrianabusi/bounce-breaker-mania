import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  final game = BounceBreaker();
  runApp(GameWidget(game: game));
}

class BounceBreaker extends FlameGame
    with HasCollisionDetection, DragCallbacks {}
