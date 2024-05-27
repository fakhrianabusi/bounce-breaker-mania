import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../configuration/constants.dart';
import '../game/bounce_breaker_mania.dart';
import '../widgets/powerup_counter.dart';
import 'ball.dart';
import 'extra_ball_power.dart';
import 'power_up.dart';

class PlayerStick extends SpriteComponent with DragCallbacks, HasGameRef<BounceBreaker> {
  final PowerUpDisplay powerUpDisplay;
  PlayerStick({
    required this.cornerRadius,
    required super.position,
    required super.size,
    required Sprite sprite,
    required this.powerUpDisplay,
  }) : super(
          anchor: Anchor.center,
          children: [RectangleHitbox()],
          sprite: sprite,
        );

  final Radius cornerRadius;

  @override
  void update(double dt) {
    super.update(dt);
    gameRef.world.children.whereType<PowerUp>().forEach((powerUp) {
      if (powerUp.toRect().overlaps(toRect())) {
        log('type: ${powerUp.type} duration: ${powerUp.duration}');
        onPowerUp(powerUp);
        powerUp.removeFromParent();
      }
    });
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    position.x = (position.x + event.localDelta.x).clamp(0, game.width);
  }

  void moveBy(double dx) {
    add(MoveToEffect(
      Vector2((position.x + dx).clamp(0, game.width), position.y),
      EffectController(duration: 0.1),
    ));
  }

  void setPositionX(double newX) {
    position.x = newX.clamp(0, game.width);
  }

  void resetSize() {
    size = playerStickSize;
  }

  void resetSpeed() {
    gameRef.world.children.whereType<Ball>().forEach((ball) {
      ball.velocity /= 1.5;
    });
  }

  void removeExtraBalls() {
    gameRef.world.children.whereType<ExtraBall>().forEach((element) {
      element.removeFromParent();
    });
  }

  void onPowerUp(PowerUp powerUp) async {
    powerUpDisplay.addPowerUp(powerUp.type, powerUp.duration);

    switch (powerUp.type) {
      case PowerUpType.stickSize:
        if (powerUp.duration.inSeconds > 0) {
          size = Vector2(game.width / 2, game.height / 50);
          Future.delayed(powerUp.duration, resetSize);
        } else {
          size = playerStickSize;
        }
        break;
      case PowerUpType.ballSpeed:
        if (powerUp.duration.inSeconds > 0) {
          gameRef.world.children.whereType<Ball>().forEach((ball) {
            ball.velocity.setFrom(ball.velocity * 2.5);
          });
          Future.delayed(powerUp.duration, resetSpeed);
        } else {
          gameRef.world.children.whereType<Ball>().forEach((ball) {
            ball.velocity.setFrom(ball.velocity * 2.5);
          });
        }
        break;
      case PowerUpType.ballCount:
        if (powerUp.duration.inSeconds > 0) {
          game.world.add(ExtraBall(
            difficultyModifier: difficultyModifier,
            radius: ballRadius,
            position: position + Vector2(0, -30),
            velocity: Vector2(0, -game.height / 4),
          ));
          Future.delayed(powerUp.duration, removeExtraBalls);
        } else {
          game.world.add(ExtraBall(
            difficultyModifier: difficultyModifier,
            radius: ballRadius,
            position: position + Vector2(0, -30),
            velocity: Vector2(0, -game.height / 4),
          ));
        }
        break;
    }
  }
}
