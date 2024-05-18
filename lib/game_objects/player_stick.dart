import 'dart:developer';

import 'package:bounce_breaker/configuration/constants.dart';
import 'package:bounce_breaker/game_objects/ball.dart';
import 'package:bounce_breaker/game_objects/extra_ball_power.dart';
import 'package:bounce_breaker/game_objects/power_up.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../game/bounce_breaker_mania.dart';

class PlayerStick extends PositionComponent with DragCallbacks, HasGameRef<BounceBreaker> {
  PlayerStick({
    required this.cornerRadius,
    required super.position,
    required super.size,
  }) : super(
          anchor: Anchor.center,
          children: [RectangleHitbox()],
        );

  final Radius cornerRadius;

  final _paint = Paint()
    ..color = const Color(0xffffffff)
    ..style = PaintingStyle.fill;

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
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
          Offset.zero & size.toSize(),
          cornerRadius,
        ),
        _paint);
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
    size = Vector2(game.width / 4, game.height / 80);
  }

  void resetSpeed() {
    game.children.whereType<Ball>().forEach((ball) {
      ball.velocity /= 1.5;
    });
  }

  void removeExtraBalls() {
    game.children.whereType<Ball>().forEach((ball) {
      ball.removeFromParent();
    });
  }

  void onPowerUp(PowerUp powerUp) async {
    switch (powerUp.type) {
      case PowerUpType.stickSize:
        if (powerUp.duration.inSeconds > 0) {
          size = Vector2(game.width * 0.4, game.height / 80);
          Future.delayed(powerUp.duration, resetSize);
        } else {
          size = Vector2(game.width * 0.4, game.height / 80);
        }

        break;
      case PowerUpType.ballSpeed:
        if (powerUp.duration.inSeconds > 0) {
          game.children.whereType<Ball>().forEach((ball) {
            ball.velocity.setFrom(ball.velocity * 2.5);
          });
          Future.delayed(powerUp.duration, resetSpeed);
        } else {
          game.children.whereType<Ball>().forEach((ball) {
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
