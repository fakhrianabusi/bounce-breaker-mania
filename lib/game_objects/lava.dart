import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class LavaComponent extends PositionComponent with CollisionCallbacks {
  bool _hasCollided = false;

  LavaComponent() : super(priority: 100001);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _updateHitbox();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _drawLava(canvas);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!_hasCollided) {
      _updateHitbox();
    }
  }

  void _drawLava(Canvas canvas) {
    final path = Path();
    const waveHeight1 = 20.0;
    const waveHeight2 = 15.0;
    const waveLength1 = 100.0;
    const waveLength2 = 150.0;
    const speed1 = 0.5;
    const speed2 = 0.3;
    final time = DateTime.now().millisecondsSinceEpoch / 1000;

    Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.pink.shade700, Colors.redAccent, Colors.orange],
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

  void _updateHitbox() {
    // Verifica se o tamanho do componente é válido
    if (size.x <= 0 || size.y <= 0) {
      return;
    }

    const waveHeight1 = 20.0;
    const waveHeight2 = 15.0;
    const waveLength1 = 100.0;
    const waveLength2 = 150.0;
    const speed1 = 0.5;
    const speed2 = 0.3;
    final time = DateTime.now().millisecondsSinceEpoch / 1000;

    List<Vector2> points = [];
    for (double x = 0; x < size.x; x++) {
      double y1 = size.y / 2 + waveHeight1 * sin(x / waveLength1 + time * speed1);
      double y2 = size.y / 2 + waveHeight2 * sin(x / waveLength2 + time * speed2);
      double y = (y1 + y2) / 2;
      points.add(Vector2(x, y));
    }
    points.add(Vector2(size.x, size.y));
    points.add(Vector2(0, size.y));

    if (points.length < 3) {
      return;
    }

    children.whereType<PolygonHitbox>().forEach(remove);

    final hitbox = PolygonHitbox(points);
    add(hitbox);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (!_hasCollided) {
      _hasCollided = true;
      //Deactivate the hitbox afdter the first collision
      children.whereType<PolygonHitbox>().forEach(remove);
    }
  }
}
