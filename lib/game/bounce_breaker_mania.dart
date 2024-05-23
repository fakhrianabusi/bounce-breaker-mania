import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flame/effects.dart' as flame_effects;
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';

import '../configuration/constants.dart';
import '../configuration/screen.dart';
import '../custom_widgets/score_manager.dart';
import '../game_objects/components.dart';
import '../game_objects/lava.dart';

enum GameStatus { initial, playing, paused, nextLevel, gameOver }

late Artboard myArtboard;
ValueNotifier<int> levelCounter = ValueNotifier<int>(0);

class BounceBreaker extends FlameGame with HasCollisionDetection, DragCallbacks, TapDetector {
  BounceBreaker()
      : super(
          camera: CameraComponent.withFixedResolution(
            width: screenWidth,
            height: screenHeight,
          ),
        );
  final scoreManager = ScoreManager();
  // final ValueNotifier<int> score = ValueNotifier<int>(0);
  final rand = math.Random();
  late SpriteComponent ballCount;
  late SpriteComponent stickSize;
  late SpriteComponent ballSpeed;

  // ...

  late final screenShake = flame_effects.MoveEffect.by(
    Vector2(0, 5),
    flame_effects.InfiniteEffectController(flame_effects.SineEffectController(period: 0.2)),
  );

  double get width => size.x;

  double get height => size.y;

  Future<void> reset() async {
    levelCounter.value = 0;
    FlameAudio.bgm.stop();
    FlameAudio.bgm.play('arcade.mp3');

    world.add(_buildBall());
    _buildPlayerStick().forEach((component) {
      world.add(component);
    });
    loadLevel(level_1, lv_1PositionX, world);
  }

  List<Component> _buildPlayerStick() {
    final stick = PlayerStick(
      size: playerStickSize,
      position: Vector2(width / 2, height * 0.65),
      cornerRadius: Radius.circular(ballRadius / 2),
    );

    final swipeControl = SwipeControlArea(
      artboards: myArtboard,
      target: stick,
      cornerRadius: const Radius.circular(20),
      size: Vector2(screenWidth * 2, screenHeight * 0.3),
      position: Vector2(width / 2, height * 1.0),
    );

    return [stick, swipeControl];
  }

  Ball _buildBall() {
    return Ball(
      difficultyModifier: difficultyModifier,
      radius: ballRadius,
      position: size / 2,
      velocity: Vector2((rand.nextDouble() - 0.5) * width, height * 0.2).normalized()..scale(height / 4),
    );
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

    scoreManager.currentScore.value = 0;
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
    FlameAudio.bgm.play('arcade.mp3');
    world.add(_buildBall());
    _buildPlayerStick().forEach((component) {
      world.add(component);
    });
    loadLevel(level_1, lv_1PositionX, world);
    final lavaHeight = size.y * 0.2; // 20% of the screen height
    final lavaComponent = LavaComponent()
      ..size = Vector2(size.x, lavaHeight)
      ..position = Vector2(0, size.y - lavaHeight)
      ..anchor = Anchor.topLeft;
    add(lavaComponent);
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    await FlameAudio.audioCache.loadAll(['game_over.ogg', 'game_over_drama.ogg', 'arcade.ogg', 'menu_music.ogg']);

    FlameAudio.bgm.initialize();

    final skillsArtboard = loadArtboard(RiveFile.asset('assets/test.riv'));
    myArtboard = await skillsArtboard;

    camera.viewfinder.anchor = Anchor.topLeft;

    await camera.viewfinder.add(screenShake);
    screenShake.pause();

    world.add(Screen());
    gameState = GameStatus.initial;
  }

  @override
  void onTap() {
    super.onTap();
    nextLevel();
  }

  @override
  void onDispose() {
    FlameAudio.bgm.stop();
    FlameAudio.bgm.dispose();
    super.onDispose();
  }

  void loadLevel(List<List<int>> level, double offsetX, World world) {
    for (int row = 0; row < level.length; row++) {
      for (int col = 0; col < level[row].length; col++) {
        int durability = level[row][col];
        if (durability == 0) continue;

        GameBlocks block = GameBlocks(
          hardness: durability,
          color: GameBlocks.getBlockColor(durability),
          durability: durability,
          size: brickSize,
        )..position = Vector2(
              col * (brickSize.x + brickPadding) + brickPadding + offsetX,
              row * (brickSize.y + brickPadding) + brickPadding * 2,
            ) +
            Vector2(0, height * 0.15); // Offset of the bricks from the top

        world.add(block);
      }
    }
  }

  void nextLevel() {
    if (gameState == GameStatus.nextLevel) {
      gameState = GameStatus.playing;
      world.removeAll(world.children.query<GameBlocks>());
      world.removeAll(world.children.query<Ball>());
      world.removeAll(world.children.query<PlayerStick>());
      world.removeAll(world.children.query<SwipeControlArea>());
      world.removeAll(world.children.query<ExtraBall>());

      world.add(_buildBall());
      _buildPlayerStick().forEach((component) {
        world.add(component);
      });

      if (levelCounter.value == 1) {
        loadLevel(level_2, lv_2PositionX, world);
      } else if (levelCounter.value == 2) {
        loadLevel(level_3, lv_3PositionX, world);
      }
    }
  }
}
