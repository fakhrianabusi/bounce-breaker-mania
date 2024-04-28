import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import 'configuration/constants.dart';
import 'configuration/screen.dart';

void main() {
  final game = BounceBreaker();
  runApp(GameWidget(game: game));
}

class BounceBreaker extends FlameGame
    with HasCollisionDetection, DragCallbacks {
  BounceBreaker()
      : super(
          camera: CameraComponent.withFixedResolution(
              width: screenWidth, height: screenHeight),
        );
  double get width => size.x;
  double get height => size.y;
  @override
  Future<void> onLoad() async {
    super.onLoad();
    camera.viewfinder.anchor = Anchor.topLeft;
    world.add(Screen());
  }
}
