import 'package:bounce_breaker/configuration/screen.dart';
import 'package:bounce_breaker/custom_widgets/pause_button.dart';
import 'package:bounce_breaker/game/bounce_breaker_mania.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InitialScreen extends StatelessWidget {
  final BounceBreaker gameRef;

  const InitialScreen({
    super.key,
    required this.gameRef,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 600,
            ),
            child: Text(
              textAlign: TextAlign.center,
              'Bounce Breaker Mania',
              style: TextStyle(
                color: Colors.white,
                fontSize: 62,
                fontFamily: GoogleFonts.orbitron().fontFamily,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Melhor pontuação: ${gameRef.scoreManager.highScore.value}',
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
              gameRef.overlays.add(PauseButton.id);
              FlameAudio.bgm.stop();
              await gameRef.onStarGame();
            },
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Start',
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
    );
  }
}
