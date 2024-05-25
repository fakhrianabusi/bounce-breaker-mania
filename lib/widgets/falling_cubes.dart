import 'dart:math';
import 'dart:ui';

import 'package:bounce_breaker/game/bounce_breaker_mania.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class FallingCubes extends Component with HasGameRef<BounceBreaker> {
  final List<Cube> cubes = [];
  final Random random = Random();

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _spawnCubes();
  }

  void _spawnCubes() {
    // Spawna cubos a cada 0.5 segundos
    Future.delayed(const Duration(seconds: 2), () {
      final size = gameRef.size;
      final cubeSize = random.nextDouble() * 50 + 20;
      final position = Vector2(random.nextDouble() * size.x, -cubeSize);
      final speed = random.nextDouble() * 50 + 50;
      final rotationSpeed = random.nextDouble() * pi / 2 + pi / 4;
      final color = Color.fromARGB(
        255,
        random.nextInt(256),
        random.nextInt(256),
        random.nextInt(256),
      ).withOpacity(0.5);

      final cube = Cube(
        size: cubeSize,
        position: position,
        speed: speed,
        rotationSpeed: rotationSpeed,
        color: color,
      );

      cubes.add(cube);
      add(cube);
      _spawnCubes();
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    cubes.removeWhere((cube) => cube.position.y > gameRef.size.y);
  }
}

class Cube extends PositionComponent {
  final double speed;
  final double rotationSpeed;
  final Color color;

  Cube({
    required double size,
    required Vector2 position,
    required this.speed,
    required this.rotationSpeed,
    required this.color,
  }) {
    this.position = position;
    this.size = Vector2.all(size);
    anchor = Anchor.center;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.y += speed * dt;
    angle -= rotationSpeed * dt;
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.save();
    canvas.translate(size.x / 2, size.y / 2);
    canvas.rotate(angle);
    canvas.drawRect(
      Rect.fromCenter(center: Offset.zero, width: size.x, height: size.y),
      paint,
    );
    canvas.restore();
  }
}
