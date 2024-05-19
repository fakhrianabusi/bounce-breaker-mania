import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../game/bounce_breaker_mania.dart';

enum PowerUpType { stickSize, ballSpeed, ballCount }

class PowerUp extends SpriteComponent with CollisionCallbacks, HasGameRef<BounceBreaker> {
  final PowerUpType type;
  final Duration duration;
  PowerUp({
    required this.velocity,
    required super.position,
    required Sprite sprite,
    required double width,
    required double height,
    required this.type,
    required this.duration,
  }) : super(
          size: Vector2(width, height),
          anchor: Anchor.center,
          paint: Paint()
            ..color = const Color.fromARGB(255, 255, 0, 157)
            ..style = PaintingStyle.fill,
          children: [RectangleHitbox()],
          sprite: sprite,
        );
  final Vector2 velocity;

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;
  }
}
