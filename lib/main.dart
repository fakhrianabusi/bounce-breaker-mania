import 'package:bounce_breaker/custom_widgets/pause_button.dart';
import 'package:bounce_breaker/custom_widgets/pause_menu.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'game/bounce_breaker_mania.dart';

void main() {
  final game = BounceBreaker();
  runApp(GameWidget(
    game: game,
    initialActiveOverlays: const [PauseButton.id],
    overlayBuilderMap: {
      PauseButton.id: (BuildContext ctx, BounceBreaker gameRef) => PauseButton(gameRef: gameRef),
      PauseMenu.id: (BuildContext ctx, BounceBreaker gameRef) => PauseMenu(gameRef: gameRef),
    },
  ));
}
