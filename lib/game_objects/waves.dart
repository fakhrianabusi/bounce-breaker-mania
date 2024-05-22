import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class LavaComponent extends PositionComponent {
  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _drawLava(canvas);
  }

  void _drawLava(Canvas canvas) {
    final path = Path();
    const waveHeight1 = 20.0;
    const waveHeight2 = 15.0;
    const waveLength1 = 100.0;
    const waveLength2 = 150.0;
    const speed1 = 0.8;
    const speed2 = 0.6;
    final time = DateTime.now().millisecondsSinceEpoch / 1000;

    Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color.fromARGB(255, 248, 0, 145), Color.fromARGB(255, 255, 0, 43), Color.fromARGB(255, 255, 108, 59)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.x, size.y));

    for (double x = 0; x < size.x; x++) {
      double y1 = size.y / 2 + waveHeight1 * sin(x / waveLength1 + time * speed1);
      double y2 = size.y / 2 + waveHeight2 * sin(x / waveLength2 + time * speed2);
      double y = (y1 + y2) / 2;

      if (x == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    path.lineTo(size.x, size.y);
    path.lineTo(0, size.y);
    path.close();

    canvas.drawPath(path, paint);
  }
}
