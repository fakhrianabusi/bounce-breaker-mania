import 'dart:developer';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';

import '../game/bounce_breaker_mania.dart';
import 'player_stick.dart';

class SwipeControlArea extends RiveComponent with DragCallbacks, TapCallbacks, HasGameRef<BounceBreaker> {
  final Artboard artboards;
  final PlayerStick target;
  late SMIBool trigger;
  SwipeControlArea({
    required this.target,
    required this.cornerRadius,
    required super.position,
    required super.size,
    required this.artboards,
  }) : super(
          artboard: artboards,
          anchor: Anchor.bottomCenter,
          children: [RectangleHitbox()],
        );

  final Radius cornerRadius;

  final _paint = Paint()
    ..color = const Color(0x88FFFFFF)
    ..style = PaintingStyle.stroke;

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

  @override
  void onLoad() async {
    super.onLoad();

    final controller = StateMachineController.fromArtboard(
      artboard,
      "statemachine",
    )!;

    trigger = controller.findSMI<SMIBool>('swiped')!;
    artboard.addController(controller);
  }

  @override
  void onTapDown(TapDownEvent event) {
    log('Tap Tapped');
    trigger.value = true;
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
