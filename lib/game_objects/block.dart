import 'dart:math';

import 'package:bounce_breaker/game_objects/extra_ball_power.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game/bounce_breaker_mania.dart';
import 'ball.dart';
import 'power_up.dart';

class GameBlocks extends RectangleComponent with CollisionCallbacks, HasGameRef<BounceBreaker> {
  GameBlocks({
    required this.durability,
    required this.hardness,
    required Color color,
    required Vector2 size,
  }) : super(
          size: size, // block size
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
        );
  int durability;
  int hardness;
  bool hasCollided = false;
  late final TextComponent textComponent;

  static Color getBlockColor(int durability) {
    if (durability == 1) {
      return const Color.fromARGB(255, 161, 103, 238);
    } else if (durability == 2) {
      return const Color.fromARGB(255, 1, 217, 166);
    } else if (durability == 3) {
      return const Color.fromARGB(255, 0, 123, 255);
    } else {
      throw Exception('Cor indefinida para durabilidade $durability');
    }
  }

  @override
  Future<void> onLoad() async {
    if (durability <= 0) {
      removeFromParent();
      return;
    }

    textComponent = TextComponent(
      text: '$durability',
      textRenderer: TextPaint(
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
    )..center = size / 2;

    await add(textComponent);

    await add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    if (hasCollided) {
      textComponent.text = '$durability';
    }
  }

  Sprite selecSpritebyPowerUpType(PowerUpType type) {
    switch (type) {
      case PowerUpType.ballCount:
        return gameRef.ballCount.sprite!;
      case PowerUpType.stickSize:
        return gameRef.stickSize.sprite!;
      case PowerUpType.ballSpeed:
        return gameRef.ballSpeed.sprite!;
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Ball || other is ExtraBall && !hasCollided) {
      hasCollided = true;

      durability--;

      if (durability == 0) {
        game.scoreManager.currentScore.value += 10;
        game.scoreManager.updateHighScore();
        debugPrint(game.scoreManager.currentScore.toString());
        final random = Random();
        final powerUpTypes = [PowerUpType.ballCount, PowerUpType.stickSize, PowerUpType.ballSpeed];
        final selectedType = powerUpTypes[random.nextInt(powerUpTypes.length)];
        final powerUpDuration = Duration(seconds: random.nextInt(10) + 7); // 7 a 16 segundos de duração

        final powerUp = PowerUp(
          sprite: selecSpritebyPowerUpType(selectedType),
          height: 60,
          width: 60,
          position: position.clone(),
          velocity: Vector2(0, 100),
          type: selectedType,
          duration: powerUpDuration,
        );

        // if hardness is 3, add power up
        if (durability == 0 && hardness == 3) {
          gameRef.world.add(powerUp);
        }
        removeFromParent();
        return;
      }

      // atualizar cor ao colidir
      paint = Paint()
        ..color = getBlockColor(durability)
        ..style = PaintingStyle.fill;
    }
    super.onCollisionStart(intersectionPoints, other);
  }

  @override
  void onCollisionEnd(PositionComponent other) {
    if (hasCollided) {
      hasCollided = false;
    }
    super.onCollisionEnd(other);
  }
}
