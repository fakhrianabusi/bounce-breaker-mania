import 'package:bounce_breaker/game/bounce_breaker_mania.dart';
import 'package:flame/components.dart';

class HitSpriteEffect extends SpriteAnimationComponent with HasGameRef<BounceBreaker> {
  HitSpriteEffect({
    super.position,
  }) : super(
          size: Vector2.all(200),
          anchor: Anchor.center,
          removeOnFinish: true,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    animation = await game.loadSpriteAnimation(
      'ahit.png',
      SpriteAnimationData.sequenced(
        amount: 29,
        stepTime: .05,
        textureSize: Vector2(291, 301),
        loop: false,
      ),
    );
  }
}
