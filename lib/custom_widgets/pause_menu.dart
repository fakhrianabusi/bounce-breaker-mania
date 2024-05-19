import 'dart:developer';

import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../game/bounce_breaker_mania.dart';

class PauseMenu extends StatelessWidget {
  static const id = 'pause_menu';
  final BounceBreaker gameRef;

  const PauseMenu({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.maxFinite,
        color: const Color.fromARGB(150, 161, 103, 238),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                gameRef.resumeEngine();
                gameRef.overlays.remove(PauseMenu.id);
                FlameAudio.bgm.resume();
              },
              child: const Text('Continuar', style: TextStyle(fontFamily: 'Press Start 2P')),
            ),
            ElevatedButton(
              onPressed: () {
                log('hello');
              },
              child: const Text('Exit', style: TextStyle(fontFamily: 'Press Start 2P')),
            ),
          ],
        ),
      ),
    );
  }
}
