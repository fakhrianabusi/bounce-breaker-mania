import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

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

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);

    scoreCard = TextBoxComponent(
      text: 'score: ',
      textRenderer: TextPaint(
          style: const TextStyle(
        fontSize: 36,
        color: Colors.white,
        fontWeight: FontWeight.w500,
      )),
    )..position = Vector2(450, 50);

    await add(scoreCard);
  }

  @override
  void update(double dt) {
    scoreCard.text = 'score: ${game.score.value}';
  }
}
