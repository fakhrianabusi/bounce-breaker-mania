import 'dart:math';

import 'package:bounce_breaker/configuration/audio_manager.dart';
import 'package:bounce_breaker/game_objects/components.dart';
import 'package:bounce_breaker/game_objects/explosion_effect.dart';
import 'package:bounce_breaker/game_objects/hit_effect.dart';
import 'package:bounce_breaker/game_objects/lava.dart';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

import '../configuration/constants.dart';
import '../configuration/screen.dart';
import '../custom_widgets/game_over_menu.dart';
import '../game/bounce_breaker_mania.dart';

double maxSpeed = 800.0;

class Ball extends CircleComponent with CollisionCallbacks, HasGameRef<BounceBreaker> {
  Ball({
    required this.velocity,
    required super.position,
    required double radius,
    required this.difficultyModifier,
  }) : super(
          radius: radius,
          anchor: Anchor.center,
          priority: 100000,
          paint: Paint()
            ..color = const Color.fromARGB(255, 198, 81, 214)
            ..style = PaintingStyle.fill,
          children: [CircleHitbox()],
        );

  Vector2 velocity;
  final double difficultyModifier;
  final Map<int, Trail> _trails = {};

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final glowPaint = Paint()
      ..color = const Color.fromARGB(255, 253, 86, 206).withOpacity(0.6)
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(16));
    canvas.drawCircle(const Offset(15, 14), radius + 5, glowPaint);
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += velocity * dt;

    final trail = _trails.putIfAbsent(
      DateTime.now().microsecondsSinceEpoch,
      () => Trail(position.clone()),
    );
    trail.addPoint(position.clone());
    gameRef.world.add(trail);
  }

  void gameOver() {
    removeFromParent();
    gameRef.world.children.whereType<GameBlocks>().forEach((element) {
      element.removeFromParent();
    });
    gameRef.world.children.whereType<Ball>().forEach((element) {
      element.removeFromParent();
    });
    gameRef.world.children.whereType<PlayerStick>().forEach((element) {
      element.removeFromParent();
    });
    gameRef.world.children.whereType<PowerUp>().forEach((element) {
      element.removeFromParent();
    });
    gameRef.world.children.whereType<ExtraBall>().forEach((element) {
      element.removeFromParent();
    });
    gameRef.world.children.whereType<Trail>().forEach((element) {
      element.removeFromParent();
    });
    gameRef.world.children.whereType<SwipeControlArea>().forEach((element) {
      element.removeFromParent();
    });
    gameRef.scoreManager.currentScore.value = 0;

    Future.delayed(const Duration(seconds: 1), () {
      AudioManager().playBgm('game_over_drama.ogg');
    });
    gameRef.overlays.add(GameOverMenu.id);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    if (other is Screen) {
      FlameAudio.play('batendo_nas_laterais.mp3');

      if (intersectionPoints.first.y <= 0) {
        velocity.y = -velocity.y;
      } else if (intersectionPoints.first.x <= 0) {
        velocity.x = -velocity.x;
      } else if (intersectionPoints.first.x >= game.width) {
        velocity.x = -velocity.x;
      }
    } else if (other is PlayerStick) {
      FlameAudio.play('batendo_na_base.mp3');

      gameRef.add(HitSpriteEffect(position: position.clone()));
      velocity.y = -velocity.y;

      double impactFactor = (position.x - other.position.x) / other.size.x;
      double speed = velocity.length;
      velocity.x = velocity.x + impactFactor * game.width * 0.3;

      velocity.setFrom(velocity.normalized() * speed);
    } else if (other is GameBlocks) {
      FlameAudio.play('quebrando_bloco.mp3');

      double deltaX = position.x - other.position.x;
      double deltaY = position.y - other.position.y;

      if (deltaY.abs() > deltaX.abs()) {
        velocity.y = -velocity.y;
      } else {
        velocity.x = -velocity.x;
      }

      velocity.setFrom(velocity * difficultyModifier);
    } else if (other is LavaComponent) {
      gameRef.add(ExplosionEffect(
        position: position.clone(),
      ));
      add(RemoveEffect(
        delay: 0.35,
      ));
      AudioManager().stopBgm();
      FlameAudio.play('dead.mp3');
      Future.delayed(const Duration(milliseconds: 300), () {
        AudioManager().playSound('game_over.ogg');
      });
      game.screenShake.resume();
      debugPrint('--------------------------------- here ---------------------------------');
      Future.delayed(const Duration(milliseconds: 500), () {
        gameOver();
        game.screenShake.pause();
      });
    }
    if (velocity.length > maxSpeed) {
      velocity.setFrom(velocity.normalized() * maxSpeed);
    }
  }
}

class Trail extends Component {
  Trail(Vector2 origin)
      : _paths = [Path()..moveTo(origin.x, origin.y)],
        _opacity = [1],
        _lastPoint = origin.clone(),
        _color = const Color.fromARGB(255, 255, 0, 155);

  final List<Path> _paths;
  final List<double> _opacity;
  final Color _color;
  late final _linePaint = Paint()..style = PaintingStyle.stroke;
  late final _circlePaint = Paint()
    ..color = _color
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, convertRadiusToSigma(8));
  double _timer = 0;
  final _vanishInterval = 0.03;
  final Vector2 _lastPoint;
  static final random = Random();
  static const lineWidth = 16.0;

  @override
  void render(Canvas canvas) {
    assert(_paths.length == _opacity.length);
    for (var i = 0; i < _paths.length; i++) {
      final path = _paths[i];
      final opacity = _opacity[i];
      if (opacity > 0) {
        _linePaint.color = _color.withOpacity(opacity);
        _linePaint.strokeWidth = lineWidth * opacity;
        canvas.drawPath(path, _linePaint);
      }
    }
    double sideLength = (lineWidth - 2) * _opacity.last + 2;

    canvas.drawRect(
      Rect.fromCenter(
        center: _lastPoint.toOffset(),
        width: sideLength * 1.5,
        height: sideLength * 1.5,
      ),
      _circlePaint,
    );
  }

  @override
  void update(double dt) {
    assert(_paths.length == _opacity.length);
    _timer += dt;
    while (_timer > _vanishInterval) {
      _timer -= _vanishInterval + random.nextDouble() * 0.01;
      for (var i = 0; i < _paths.length; i++) {
        _opacity[i] -= 0.1;
        if (_opacity[i] <= 0) {
          _paths[i].reset();
        }
      }
    }

    if (_opacity.last < 0) {
      removeFromParent();
    }
  }

  void addPoint(Vector2 point) {
    if (!point.x.isNaN) {
      for (final path in _paths) {
        path.lineTo(point.x, point.y);
      }
      _lastPoint.setFrom(point);
    }
  }
}
