import 'dart:developer';

import 'package:bounce_breaker/configuration/audio_manager.dart';
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    log('hello');
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
                    child: Text(
                      'Exit',
                      style: TextStyle(
                        fontFamily: 'Press Start 2P',
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                ElevatedButton(
                  onPressed: () {
                    gameRef.resumeEngine();
                    AudioManager().resumeBgm();
                    gameRef.overlays.remove(PauseMenu.id);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
                    child: Text(
                      'Continuar',
                      style: TextStyle(
                        fontFamily: 'Press Start 2P',
                        fontSize: 32,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
