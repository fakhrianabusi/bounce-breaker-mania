import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../configuration/constants.dart';
import '../configuration/screen.dart';
import '../game_objects/ball.dart';
import '../game_objects/block.dart';
import '../game_objects/player_stick.dart';
import '../game_objects/swipe_controls.dart';

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

  double get brickSize {
    const totalPadding =
        (GameConstants.noBricksInRow + 1) * GameConstants.brickPadding;
    final screenMinSize = size.x < size.y ? size.x : size.y;
    return (screenMinSize - totalPadding) / GameConstants.noBricksInRow;
  } // Calculate the size of the bricks based on the screen size

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
    world.add(SwipeControlArea(
        target: world.children.query<PlayerStick>().first,
        size: Vector2(screenWidth * 2, screenHeight * 0.3),
        cornerRadius: const Radius.circular(ballRadius / 2),
        position: Vector2(width / 2, height * 1.0)));

    world.addAll([
      for (var row = 0; row < 5; row++)
        for (var col = 0; col < 10; col++)
          GameBlocks(
            color: Colors.white,
            durability: rand.nextInt(3) + 1,
            size: brickSize,
          )..position = Vector2(
                col * (brickSize + GameConstants.brickPadding) +
                    GameConstants.brickPadding,
                row * (brickSize + GameConstants.brickPadding) +
                    GameConstants.brickPadding * 2,
              ) +
              Vector2(0, height * 0.1) // Offset of the bricks from the top
    ]);
  }
}
