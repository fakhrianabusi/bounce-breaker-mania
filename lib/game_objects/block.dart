import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../configuration/constants.dart';
import '../game/bounce_breaker_mania.dart';
import 'ball.dart';

class GameBlocks extends RectangleComponent
    with CollisionCallbacks, HasGameReference<BounceBreaker> {
  GameBlocks(
      {required Vector2 position,
      required Color color,
      this.durability = 5,
      required this.durabilityText})
      : super(
          size: Vector2(brickWidth, brickHeight), // Tamanho do bloco
          anchor: Anchor.center,
          position: position,
          paint: Paint()
            ..color = color
            ..style = PaintingStyle.fill,
          children: [
            RectangleHitbox(),
            TextComponent(
              text: durabilityText,
              textRenderer: TextPaint(
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
            )..center
          ],
        );
  int durability;
  String? durabilityText;

  @override
  void update(double dt) {
    super.update(dt);
    durabilityText = durability.toString(); // Atualiza o texto da durabilidade
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Ball) {
      durability--;
      if (durability <= 0) {
        removeFromParent();
      }
    }
  }
}
