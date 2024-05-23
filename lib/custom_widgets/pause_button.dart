import 'package:flutter/material.dart';

import '../game/bounce_breaker_mania.dart';
import 'pause_menu.dart';

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
      alignment: Alignment.topRight,
      child: Container(
        margin: const EdgeInsets.only(top: 32, right: 32),
        child: IconButton(
          onPressed: () {
            gameRef.pauseEngine();

            gameRef.overlays.add(PauseMenu.id);
          },
          icon: const Icon(
            Icons.pause,
            size: 48,
          ),
          color: Colors.white,
        ),
      ),
    );
  }
}
