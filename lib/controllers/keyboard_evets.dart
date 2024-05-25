import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../game_objects/components.dart';

class KeyboardController {
  final double playerStickMoveSteps;
  final Function onStarGame;
  final World world;
  final Set<LogicalKeyboardKey> keysPressed = {};

  KeyboardController({
    required this.playerStickMoveSteps,
    required this.onStarGame,
    required this.world,
  });

  KeyEventResult handleKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent) {
      keysPressed.add(event.logicalKey);
    } else if (event is KeyUpEvent) {
      keysPressed.remove(event.logicalKey);
    }

    return KeyEventResult.handled;
  }

  void update(double dt) {
    if (keysPressed.contains(LogicalKeyboardKey.arrowLeft)) {
      world.children.query<PlayerStick>().first.moveBy(-playerStickMoveSteps * 1.5);
    }
    if (keysPressed.contains(LogicalKeyboardKey.arrowRight)) {
      world.children.query<PlayerStick>().first.moveBy(playerStickMoveSteps * 1.5);
    }
    if (keysPressed.contains(LogicalKeyboardKey.space) || keysPressed.contains(LogicalKeyboardKey.enter)) {
      onStarGame();
    }
  }
}

  // KeyEventResult handleKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
  //   switch (event.logicalKey) {
  //     case LogicalKeyboardKey.arrowLeft:
  //       world.children.query<PlayerStick>().first.moveBy(-playerStickMoveSteps * 1.5);
  //       break;
  //     case LogicalKeyboardKey.arrowRight:
  //       world.children.query<PlayerStick>().first.moveBy(playerStickMoveSteps * 1.5);
  //       break;
  //     case LogicalKeyboardKey.space:
  //     case LogicalKeyboardKey.enter:
  //       onStarGame();
  //       break;
  //   }
  //   return KeyEventResult.handled;
  // }

