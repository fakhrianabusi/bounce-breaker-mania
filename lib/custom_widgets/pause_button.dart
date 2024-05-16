import 'package:bounce_breaker/custom_widgets/pause_menu.dart';
import 'package:bounce_breaker/game/bounce_breaker_mania.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

class PauseButton extends StatelessWidget {
  static const id = 'pause_btn';
  final BounceBreaker gameRef;

  const PauseButton({
    super.key,
    required this.gameRef,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        margin: const EdgeInsets.only(top: 32),
        child: IconButton(
          onPressed: () {
            gameRef.pauseEngine();
            FlameAudio.bgm.pause();
            gameRef.overlays.add(PauseMenu.id);
          },
          icon: const Icon(Icons.pause),
          color: Colors.white,
        ),
      ),
    );
  }
}
