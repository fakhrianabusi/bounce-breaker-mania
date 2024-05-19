import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';

import '../configuration/screen.dart';
import '../game/bounce_breaker_mania.dart';
import 'block.dart';
import 'player_stick.dart';
import 'trail_effect.dart';

class ExtraBall extends CircleComponent with CollisionCallbacks, HasGameRef<BounceBreaker> {
  ExtraBall({
    required this.velocity,
    required super.position,
    required double radius,
    required this.difficultyModifier,
  }) : super(
          radius: radius,
          priority: 100000,
          anchor: Anchor.center,
          paint: Paint()
            ..color = Color.fromARGB(
              255,
              Random().nextInt(256),
              Random().nextInt(256),
              Random().nextInt(256),
            )
            ..style = PaintingStyle.fill,
          children: [CircleHitbox()],
        );

  Vector2 velocity;

  final double difficultyModifier;

  final Map<int, Trail> _trails = {};

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    final trail = _trails.putIfAbsent(
      DateTime.now().microsecondsSinceEpoch,
      () => Trail(position.clone()),
    );
    trail.addPoint(position.clone());
    gameRef.world.add(trail);
  }

  gameOver() {
    position = Vector2(game.width / 2, game.height / 2);
    velocity.setValues(0, 0);
    gameRef.world.children.whereType<GameBlocks>().forEach((element) {
      element.removeFromParent();
    });
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Screen) {
      if (intersectionPoints.first.y <= 0) {
        velocity.y = -velocity.y;
        velocity.setFrom(velocity - velocity * 0.3);
      } else if (intersectionPoints.first.x <= 0) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.x >= game.width) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.y >= game.height) {
        add(RemoveEffect(
          delay: 0.35,
        ));
        removeFromParent();
      }
    } else if (other is PlayerStick) {
      velocity.y = -velocity.y;
      velocity.x = velocity.x + (position.x - other.position.x) / other.size.x * game.width * 0.3;
    } else if (other is GameBlocks) {
      if (position.y < other.position.y - other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.y > other.position.y + other.size.y / 2) {
        velocity.y = -velocity.y;
      } else if (position.x < other.position.x) {
        velocity.x = -velocity.x;
      } else if (position.x > other.position.x) {
        velocity.x = -velocity.x;
      }
      velocity.setFrom(velocity * difficultyModifier);
    }
  }
}
