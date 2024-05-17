import 'package:bounce_breaker/custom_widgets/pause_button.dart';
import 'package:bounce_breaker/custom_widgets/pause_menu.dart';
import 'package:bounce_breaker/custom_widgets/game_over_menu.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'game/bounce_breaker_mania.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('fonts/Press_Start_2P/OFL.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  final game = BounceBreaker();
  runApp(GameWidget(
    game: game,
    initialActiveOverlays: const [PauseButton.id],
    overlayBuilderMap: {
      PauseButton.id: (BuildContext ctx, BounceBreaker gameRef) => PauseButton(gameRef: gameRef),
      PauseMenu.id: (BuildContext ctx, BounceBreaker gameRef) => PauseMenu(gameRef: gameRef),
      GameOverMenu.id: (BuildContext ctx, BounceBreaker gameRef) => GameOverMenu(gameRef: gameRef),
    },
  ));
}
