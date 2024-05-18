import 'package:bounce_breaker/game/bounce_breaker_mania.dart';
import 'package:flutter/material.dart';

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
            Text(
              'Game Over!',
              style: TextStyle(
                fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize,
                fontFamily: 'Press Start 2P',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black87)),
              onPressed: () {
                gameRef.overlays.remove(GameOverMenu.id);
                gameRef.reset();
              },
              child: const Text('Reiniciar', style: TextStyle(fontFamily: 'Press Start 2P')),
            ),
            ElevatedButton(
              style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black87)),
              onPressed: () {
                print('hello');
              },
              child: const Text('Exit', style: TextStyle(fontFamily: 'Press Start 2P')),
            ),
          ],
        ),
      ),
    );
  }
}
