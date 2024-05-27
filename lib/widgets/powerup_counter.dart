import 'package:bounce_breaker/configuration/constants.dart';
import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../game/bounce_breaker_mania.dart';
import '../game_objects/components.dart';

class PowerUpDisplay extends PositionComponent with HasGameRef<BounceBreaker> {
  final Map<PowerUpType, TextComponent> _powerUpTexts = {};
  final Map<PowerUpType, Timer> _powerUpTimers = {};

  PowerUpDisplay() {
    position = kIsWeb ? Vector2(860, 162) : Vector2(screenWidth - 200, 162); // Ajuste a posição conforme necessário
  }

  void addPowerUp(PowerUpType type, Duration duration) {
    if (_powerUpTimers.containsKey(type)) {
      _powerUpTimers[type]!.stop();
      _powerUpTexts[type]!.removeFromParent();
    }

    final textComponent = TextComponent(
      text: '$type: ${duration.inSeconds}s',
      position: Vector2(0, _powerUpTexts.length * 20),
      textRenderer: TextPaint(
        style: TextStyle(
            fontSize: 22,
            color: Color.lerp(Colors.yellow, Colors.yellowAccent, 0.5),
            fontWeight: FontWeight.w500,
            fontFamily: GoogleFonts.orbitron().fontFamily,
            shadows: const [
              Shadow(
                color: Color.fromARGB(255, 249, 109, 1),
                offset: Offset(0, 0),
                blurRadius: 12,
              ),
            ]),
      ),
    );

    _powerUpTexts[type] = textComponent;
    add(textComponent);
    updateTextPositions();

    final timer = Timer(duration.inSeconds.toDouble(), onTick: () {
      textComponent.removeFromParent();
      _powerUpTexts.remove(type);
      _powerUpTimers.remove(type);
      updateTextPositions();
    });

    _powerUpTimers[type] = timer;
    timer.start();
  }

  void updateTextPositions() {
    double yOffset = 0;
    for (final text in _powerUpTexts.values) {
      text.position = Vector2(0, yOffset);
      yOffset += 20;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    final timersToUpdate = Map<PowerUpType, Timer>.from(_powerUpTimers);

    timersToUpdate.forEach((type, timer) {
      timer.update(dt);
      if (_powerUpTexts.containsKey(type)) {
        final remainingTime = timer.limit - timer.current;
        if (type == PowerUpType.ballCount) {
          _powerUpTexts[type]!.text = 'Extra Ball: ${remainingTime.toInt()}s';
        } else if (type == PowerUpType.stickSize) {
          _powerUpTexts[type]!.text = 'Stick Size: ${remainingTime.toInt()}s';
        } else if (type == PowerUpType.ballSpeed) {
          _powerUpTexts[type]!.text = 'Speed: ${remainingTime.toInt()}s';
        }
      }
    });
  }
}
