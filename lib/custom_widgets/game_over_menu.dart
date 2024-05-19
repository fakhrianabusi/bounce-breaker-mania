import 'dart:developer';

import 'package:flutter/material.dart';

import '../game/bounce_breaker_mania.dart';

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
                color: Colors.white,
                fontSize: Theme.of(context).textTheme.headlineLarge!.fontSize,
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Reiniciar',
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize, fontFamily: 'Press Start 2P'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Colors.black87)),
              onPressed: () {
                log('hello');
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Exit',
                  style: TextStyle(
                      fontSize: Theme.of(context).textTheme.headlineMedium!.fontSize, fontFamily: 'Press Start 2P'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
