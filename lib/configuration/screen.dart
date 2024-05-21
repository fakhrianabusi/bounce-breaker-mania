import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/bounce_breaker_mania.dart';
import 'constants.dart';

class Screen extends RectangleComponent with HasGameRef<BounceBreaker> {
  Screen()
      : super(
          paint: Paint()..color = screenColor,
          children: [
            RectangleHitbox(),
          ],
        );

  late final TextBoxComponent scoreCard;
  late final SpriteComponent background;
  static bool shouldDrawRectStroke = true;

  final Paint strokePaint = Paint()
    ..shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.white,
        Colors.pink,
        Colors.purple,
        Colors.blue,
        Colors.green,
        Colors.yellow,
        Colors.orange,
        Colors.red
      ],
    ).createShader(Rect.fromLTWH(0, 0, screenWidth, screenHeight))
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeWidth = 10
    ..strokeJoin = StrokeJoin.round;

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
    final backgroundImage = await Flame.images.load('neon_bg.jpg');
    background = SpriteComponent()
      ..sprite = Sprite(backgroundImage)
      ..size = size
      ..position = Vector2.zero()
      ..setAlpha(50);
    await add(background);
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
    final rect = Rect.fromLTWH(60, 120, screenWidth - 120, screenHeight - 200);
    if (shouldDrawRectStroke) {
      canvas.drawRect(rect, strokePaint);
    }
  }

  @override
  void update(double dt) {
    scoreCard.text = '${game.scoreManager.currentScore.value}';
  }
}
