import 'package:bounce_breaker/game/bounce_breaker_mania.dart';
import 'package:flame/components.dart';

class ExplosionEffect extends SpriteAnimationComponent with HasGameRef<BounceBreaker> {
  ExplosionEffect({
    super.position,
  }) : super(
          size: Vector2.all(300),
          anchor: Anchor.center,
          removeOnFinish: true,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'explode.png',
      SpriteAnimationData.sequenced(
        amount: 10,
        stepTime: .05,
        textureSize: Vector2(200, 200),
        loop: false,
      ),
    );
  }
}
