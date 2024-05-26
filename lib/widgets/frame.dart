import 'package:bounce_breaker/configuration/audio_manager.dart';
import 'package:bounce_breaker/custom_widgets/initial_screen.dart';
import 'package:bounce_breaker/widgets/levels_overlay.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../configuration/constants.dart';
import '../custom_widgets/game_over_menu.dart';
import '../custom_widgets/pause_button.dart';
import '../custom_widgets/pause_menu.dart';
import '../game/bounce_breaker_mania.dart';

class Frame extends StatefulWidget {
  const Frame({super.key});

  @override
  State<Frame> createState() => _FrameState();
}

class _FrameState extends State<Frame> {
  late final BounceBreaker game;

  @override
  void initState() {
    AudioManager().playBgm('menu_hype.mp3');

    super.initState();

    Flame.device.fullScreen();

    game = BounceBreaker();
  }

  @override
  void dispose() {
    AudioManager().stopBgm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: kIsWeb
              ? const BoxDecoration(
                  color: Color.fromARGB(255, 41, 41, 41),
                )
              : const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.white, Colors.white, Color.fromARGB(255, 255, 0, 81)]),
                ),
          child: Center(
            child: Column(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: kIsWeb ? screenWidth * 1.5 : screenWidth,
                      height: screenHeight,
                      child: GameWidget(
                        game: game,
                        overlayBuilderMap: {
                          GameStatus.initial.name: (ctx, BounceBreaker gameRef) => InitialScreen(gameRef: gameRef),
                          PauseButton.id: (ctx, BounceBreaker gameRef) => PauseButton(gameRef: gameRef),
                          PauseMenu.id: (ctx, BounceBreaker gameRef) => PauseMenu(gameRef: gameRef),
                          GameOverMenu.id: (ctx, BounceBreaker gameRef) => GameOverMenu(gameRef: gameRef),
                          GameStatus.nextLevel.name: (ctx, BounceBreaker gameRef) => const LevelsOverlays(
                                title: 'PROXIMA FASE',
                                subtitle: 'TOQUE PARA CONTINUAR',
                              ),
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
