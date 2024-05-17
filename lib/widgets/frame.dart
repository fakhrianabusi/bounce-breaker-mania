import 'package:bounce_breaker/configuration/constants.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
    super.initState();
    game = BounceBreaker();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  Expanded(
                      child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: screenWidth - 22,
                      height: screenHeight - 50,
                      child: GameWidget(
                        game: game,
                        initialActiveOverlays: const [PauseButton.id],
                        overlayBuilderMap: {
                          GameStatus.initial.name: (context, game) => Center(
                                child: Text(
                                  textAlign: TextAlign.center,
                                  'Bounce Breaker Mania\n Tap to Start',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontFamily:
                                        GoogleFonts.orbitron().fontFamily,
                                  ),
                                ),
                              ),
                          PauseButton.id:
                              (BuildContext ctx, BounceBreaker gameRef) =>
                                  PauseButton(gameRef: gameRef),
                          PauseMenu.id:
                              (BuildContext ctx, BounceBreaker gameRef) =>
                                  PauseMenu(gameRef: gameRef),
                        },
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
