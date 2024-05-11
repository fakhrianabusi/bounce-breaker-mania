import 'package:bounce_breaker/game_objects/player_stick.dart';
import 'package:bounce_breaker/main.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class SwipeControllArea extends PositionComponent
    with DragCallbacks, HasGameReference<BounceBreaker> {
  final PlayerStick target;
  SwipeControllArea({
    required this.target,
    required this.cornerRadius,
    required super.position,
    required super.size,
  }) : super(
          anchor: Anchor.bottomCenter,
          children: [RectangleHitbox()],
        );

  final Radius cornerRadius;

  final _paint = Paint()
    ..color = const Color(0x88FFFFFF)
    ..style = PaintingStyle.stroke
    ..shader = const LinearGradient(
      colors: [Colors.white, Colors.black],
    ).createShader(const Rect.fromLTWH(0, 0, 1, 1));

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
  void onDragUpdate(
    DragUpdateEvent event,
  ) {
    super.onDragUpdate(event);
    position.x = (position.x + event.localDelta.x).clamp(0, game.width);
    target.setPositionX(position.x);
  }

  void moveBy(double dx) {
    add(
      MoveToEffect(
        Vector2((position.x + dx).clamp(0, game.width), position.y),
        EffectController(duration: 0.1),
        target: this,
      ),
    );
  }
}
