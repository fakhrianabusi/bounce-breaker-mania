import 'package:bounce_breaker/game_configuration/constants.dart';
import 'package:bounce_breaker/main.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Screen extends RectangleComponent with HasGameReference<BounceBreaker> {
  Screen()
      : super(
          paint: Paint()..color = screenColor,
        );

  @override
  void onLoad() {
    super.onLoad();
    width = screenWidth;
    height = screenHeight;
  }
}
