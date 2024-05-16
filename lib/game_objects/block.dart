import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game/bounce_breaker_mania.dart';
import 'ball.dart';
import 'power_up.dart';

class GameBlocks extends RectangleComponent
    with CollisionCallbacks, HasGameRef<BounceBreaker> {
  GameBlocks({
    required this.durability,
    required Color color,
    required double size,
  }) : super(
          size: Vector2.all(size), // block size
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
        );
  int durability;
  bool hasCollided = false;
  late final TextComponent textComponent;

  static Color getBlockColor(int durability) {
    if (durability == 1) {
      return const Color.fromARGB(255, 161, 103, 238);
    } else if (durability == 2) {
      return const Color.fromARGB(255, 1, 217, 166);
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

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Ball && !hasCollided) {
      hasCollided = true;

      durability--;

      if (durability == 0) {
        final random = Random();
        final powerUpTypes = [
          PowerUpType.ballCount,
          PowerUpType.stickSize,
          PowerUpType.ballSpeed
        ];
        final selectedType = powerUpTypes[random.nextInt(powerUpTypes.length)];
        final powerUpDuration = Duration(
            seconds: random.nextInt(4) + 5); // Duração entre 5 e 14 segundos

        final powerUp = PowerUp(
          height: 20,
          width: 20,
          position: position.clone(),
          velocity: Vector2(0, 100),
          type: selectedType,
          duration: powerUpDuration,
        );
        gameRef.world.add(powerUp);
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
