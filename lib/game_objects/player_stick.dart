import 'dart:developer';

import 'package:bounce_breaker/configuration/constants.dart';
import 'package:bounce_breaker/game_objects/ball.dart';
import 'package:bounce_breaker/game_objects/power_up.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

import '../game/bounce_breaker_mania.dart';

class PlayerStick extends PositionComponent
    with DragCallbacks, HasGameRef<BounceBreaker> {
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
        log('PowerUp collected: $powerUp');
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

  void onPowerUp(PowerUp powerUp) {
    switch (powerUp.type) {
      case PowerUpType.stickSize:
        size = Vector2(playerStickWidth * 1.5, playerStickHeight);

        break;
      case PowerUpType.ballSpeed:
        game.children.whereType<Ball>().forEach((ball) {
          ball.velocity *= 1.5;
        });
        break;
      case PowerUpType.ballCount:
        game.add(Ball(
          difficultyModifier: difficultyModifier,
          radius: ballRadius,
          position: position + Vector2(0, -30),
          velocity: Vector2(0, -game.height / 4),
        ));
        break;
    }
  }
}
