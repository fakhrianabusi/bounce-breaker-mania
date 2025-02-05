import 'package:bounce_breaker/configuration/audio_manager.dart';
import 'package:flutter/material.dart';

import '../game/bounce_breaker_mania.dart';
import '../widgets/frame.dart';

class GameOverMenu extends StatelessWidget {
  static const id = 'game_over_menu';
  final BounceBreaker gameRef;

  const GameOverMenu({super.key, required this.gameRef});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.maxFinite,
        color: const Color.fromARGB(146, 112, 112, 112).withRed(600),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Game Over!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 64,
                fontFamily: 'Press Start 2P',
              ),
            ),
            const SizedBox(height: 64),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black87)),
                  onPressed: () {
                    AudioManager().stopBgm();
                    Navigator.pushAndRemoveUntil(
                        context, MaterialPageRoute(builder: (context) => const Frame()), (route) => false);
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
                    child: Text(
                      'Sair',
                      style: TextStyle(fontSize: 32, fontFamily: 'Press Start 2P'),
                    ),
                  ),
                ),
                const SizedBox(width: 32),
                ElevatedButton(
                  style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black87)),
                  onPressed: () {
                    AudioManager().stopBgm();
                    gameRef.overlays.remove(GameOverMenu.id);
                    gameRef.reset();
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 14.0),
                    child: Text(
                      'Reiniciar',
                      style: TextStyle(fontSize: 32, fontFamily: 'Press Start 2P'),
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
