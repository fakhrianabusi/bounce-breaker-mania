import 'dart:math' as math;

import 'package:bounce_breaker/game_objects/player_stick.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'configuration/constants.dart';
import 'configuration/screen.dart';
import 'game_objects/ball.dart';
import 'game_objects/swipe_controlls.dart';

void main() {
  final game = BounceBreaker();
  runApp(GameWidget(game: game));
}

class BounceBreaker extends FlameGame
    with HasCollisionDetection, DragCallbacks {
  BounceBreaker()
      : super(
          camera: CameraComponent.withFixedResolution(
              width: screenWidth, height: screenHeight),
        );
  final rand = math.Random();
  double get width => size.x;
  double get height => size.y;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(Screen());
    world.add(Ball(
        difficultyModifier: difficultyModifier,
        radius: ballRadius,
        position: size / 2,
        velocity: Vector2((rand.nextDouble() - 0.5) * width, height * 0.2)
            .normalized()
          ..scale(height / 4)));
    world.add(PlayerStick(
        size: Vector2(playerStickWidth, playerStickHeight),
        cornerRadius: const Radius.circular(ballRadius / 2),
        position: Vector2(width / 2, height * 0.65)));
    world.add(SwipeControllArea(
        target: world.children.query<PlayerStick>().first,
        size: Vector2(screenWidth * 2, screenHeight * 0.3),
        cornerRadius: const Radius.circular(ballRadius / 2),
        position: Vector2(width / 2, height * 1.0)));
  }
}
