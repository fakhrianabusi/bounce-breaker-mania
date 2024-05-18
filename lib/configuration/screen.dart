import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/bounce_breaker_mania.dart';
import 'constants.dart';

class Screen extends RectangleComponent with HasGameRef<BounceBreaker> {
  Screen()
      : super(
          paint: Paint()..color = screenColor,
          children: [
            RectangleHitbox(
              collisionType: CollisionType.active,
            ),
          ],
        );

  late final TextBoxComponent scoreCard;

  final Paint strokePaint = Paint()
    ..shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.white, Colors.pink],
    ).createShader(const Rect.fromLTWH(0, 0, screenWidth, screenHeight))
    ..style = PaintingStyle.stroke
    ..strokeWidth = 3;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);

    scoreCard = TextBoxComponent(
      size: Vector2(600, 100),
      text: '0',
      textRenderer: TextPaint(
          style: TextStyle(
        fontSize: 32,
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontFamily: GoogleFonts.pressStart2p().fontFamily,
      )),
    )..position = Vector2(50, 40);

    await add(scoreCard);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawRect(size.toRect(), strokePaint);
  }

  @override
  void update(double dt) {
    scoreCard.text = '${game.scoreManager.currentScore.value}';
  }
}
