import 'package:bounce_breaker/configuration/screen.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    FlameAudio.bgm.stop();
    FlameAudio.bgm.play('menu_music.ogg');

    super.initState();

    Flame.device.fullScreen();

    game = BounceBreaker();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: screenWidth,
                    height: screenHeight,
                    child: GameWidget(
                      game: game,
                      initialActiveOverlays: const [PauseButton.id],
                      overlayBuilderMap: {
                        GameStatus.initial.name: (context, BounceBreaker game) => Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    textAlign: TextAlign.center,
                                    'Bounce Breaker Mania',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 60,
                                      fontFamily: GoogleFonts.orbitron().fontFamily,
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  Text(
                                    'High Score: ${game.scoreManager.highScore.value}',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontFamily: GoogleFonts.orbitron().fontFamily,
                                    ),
                                  ),
                                  const SizedBox(height: 64),
                                  ElevatedButton(
                                    onPressed: () async {
                                      Screen.shouldDrawRectStroke = false;
                                      FlameAudio.bgm.stop();
                                      await game.onStarGame();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Text(
                                        'Tap to Start',
                                        style: TextStyle(
                                          fontSize: 40,
                                          fontFamily: GoogleFonts.orbitron().fontFamily,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        PauseButton.id: (BuildContext ctx, BounceBreaker gameRef) => PauseButton(gameRef: gameRef),
                        PauseMenu.id: (BuildContext ctx, BounceBreaker gameRef) => PauseMenu(gameRef: gameRef),
                        GameOverMenu.id: (BuildContext ctx, BounceBreaker gameRef) => GameOverMenu(gameRef: gameRef),
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
