import 'package:bounce_breaker/game/bounce_breaker_mania.dart';
import 'package:flame/components.dart';

class ExplosionEffect extends SpriteAnimationComponent with HasGameRef<BounceBreaker> {
  ExplosionEffect({
    super.position,
  }) : super(
          size: Vector2.all(400),
          anchor: Anchor.center,
          removeOnFinish: true,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'sparks.png',
      SpriteAnimationData.sequenced(
        amount: 29,
        stepTime: .05,
        textureSize: Vector2(96, 96),
        loop: false,
      ),
    );
  }
}
