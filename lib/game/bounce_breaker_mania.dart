import 'dart:math' as math;

import 'package:bounce_breaker/game_objects/extra_ball_power.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../configuration/constants.dart';
import '../configuration/screen.dart';
import '../game_objects/ball.dart';
import '../game_objects/block.dart';
import '../game_objects/player_stick.dart';
import '../game_objects/swipe_controls.dart';

enum GameStatus { initial, playing, paused, nextLevel, gameOver }

class BounceBreaker extends FlameGame with HasCollisionDetection, DragCallbacks, TapDetector {
  BounceBreaker()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: screenWidth,
            height: screenHeight,
          ),
        );
  final ValueNotifier<int> score = ValueNotifier<int>(0);
  final rand = math.Random();
  late SpriteComponent ballCount;
  late SpriteComponent stickSize;
  late SpriteComponent ballSpeed;
  double get width => size.x;
  double get height => size.y;
  int get getDurability => rand.nextInt(2) + 1;
  double get brickSize {
    const totalPadding = (GameConstants.noBricksInRow + 1) * GameConstants.brickPadding;
    final screenMinSize = size.x < size.y ? size.x : size.y;
    return (screenMinSize - totalPadding) / GameConstants.noBricksInRow;
  } // Calculate the size of the bricks based on the screen size

  Future<void> reset() async {
    FlameAudio.bgm.stop();
    FlameAudio.bgm.play('arcade.mp3', volume: 0.5);
    await onStarGame();
  }

  //GameState handling

  late GameStatus _gameState;
  GameStatus get gameState => _gameState;
  set gameState(GameStatus status) {
    _gameState = status;
    switch (status) {
      case GameStatus.initial:
      case GameStatus.paused:
      case GameStatus.gameOver:
      case GameStatus.nextLevel:
        overlays.add(status.name);
      case GameStatus.playing:
        overlays.remove(GameStatus.paused.name);
        overlays.remove(GameStatus.gameOver.name);
        overlays.remove(GameStatus.initial.name);
        overlays.remove(GameStatus.nextLevel.name);
    }
  }

  Future<void> onStarGame() async {
    if (gameState == GameStatus.playing) return;

    world.removeAll(world.children.query<GameBlocks>());
    world.removeAll(world.children.query<Ball>());
    world.removeAll(world.children.query<PlayerStick>());
    world.removeAll(world.children.query<SwipeControlArea>());
    world.removeAll(world.children.query<ExtraBall>());

    score.value = 0;
    gameState = GameStatus.playing;

    final powerUpSprite1 = await loadSprite('ball_count.png');
    final powerUpSprite2 = await loadSprite('stick_size.png');
    final powerUpSprite3 = await loadSprite('ball_speed.png');

    ballCount = SpriteComponent(
      sprite: powerUpSprite1,
      size: Vector2.all(30),
      anchor: Anchor.center,
    );

    stickSize = SpriteComponent(
      sprite: powerUpSprite2,
      size: Vector2.all(30),
      anchor: Anchor.center,
    );

    ballSpeed = SpriteComponent(
      sprite: powerUpSprite3,
      size: Vector2.all(30),
      anchor: Anchor.center,
    );

    FlameAudio.bgm.stop();
    FlameAudio.bgm.play('arcade.mp3', volume: 0.5);
    world.add(Ball(
        difficultyModifier: difficultyModifier,
        radius: ballRadius,
        position: size / 2,
        velocity: Vector2((rand.nextDouble() - 0.5) * width, height * 0.2).normalized()..scale(height / 4)));
    world.add(PlayerStick(
        size: Vector2(playerStickWidth, playerStickHeight),
        cornerRadius: const Radius.circular(ballRadius / 2),
        position: Vector2(width / 2, height * 0.65)));

    //FIX: The SwipeControlArea not working with tap detector
    //We are using the onTap method to start the game
    //and the SwipeControlArea is not working with the onTap method
    //Maybe we can use the DragDetector to handle the swipe
    //Or add a button to start the game

    // world.add(SwipeControlArea(
    //     target: world.children.query<PlayerStick>().first,
    //     size: Vector2(screenWidth * 2, screenHeight * 0.3),
    //     cornerRadius: const Radius.circular(ballRadius / 2),
    //     position: Vector2(width / 2, height * 1.0)));

    for (var row = 0; row < 5; row++) {
      for (var col = 0; col < 10; col++) {
        int durability = getDurability;

        final gameBlock = GameBlocks(
          color: GameBlocks.getBlockColor(durability),
          durability: durability,
          size: brickSize,
        )..position = Vector2(
              col * (brickSize + GameConstants.brickPadding) + GameConstants.brickPadding,
              row * (brickSize + GameConstants.brickPadding) + GameConstants.brickPadding * 2,
            ) +
            Vector2(0, height * 0.1); // Offset of the bricks from the top
        world.add(gameBlock);
      }
    }
  }

  @override
  void onTap() {
    super.onTap();
    onStarGame();
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(Screen());
    gameState = GameStatus.initial;
  }
}
