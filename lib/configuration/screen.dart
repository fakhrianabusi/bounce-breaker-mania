import 'dart:async';

import 'package:bounce_breaker/configuration/constants.dart';
import 'package:bounce_breaker/main.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Screen extends RectangleComponent with HasGameReference<BounceBreaker> {
  Screen()
      : super(
          paint: Paint()..color = screenColor,
          children: [RectangleHitbox()],
        );

  @override
  FutureOr<void> onLoad() async {
    super.onLoad();
    size = Vector2(game.width, game.height);
  }
}
