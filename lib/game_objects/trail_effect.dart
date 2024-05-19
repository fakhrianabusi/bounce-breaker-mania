import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';

import '../configuration/constants.dart';

class Trail extends Component {
  Trail(Vector2 origin)
      : _paths = [Path()..moveTo(origin.x, origin.y)],
        _opacity = [1],
        _lastPoint = origin.clone(),
        _color = Color.fromARGB(
          255,
          Random().nextInt(256),
          Random().nextInt(256),
          Random().nextInt(256),
        );

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
