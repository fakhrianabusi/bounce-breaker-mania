import 'dart:developer';

import 'package:flame_audio/flame_audio.dart';

class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  AudioManager._internal();

  bool _isBgmPlaying = false;
  bool _isSoundEffectPlaying = false;

  void playBgm(String fileName) {
    if (!_isBgmPlaying) {
      log('Playing BGM: $fileName');
      FlameAudio.bgm.play(fileName);
      _isBgmPlaying = true;
    } else {
      log('BGM already playing.');
    }
  }

  void stopBgm() {
    if (_isBgmPlaying) {
      FlameAudio.bgm.stop();
      _isBgmPlaying = false;
    }
  }

  void playSound(String fileName) {
    if (!_isSoundEffectPlaying) {
      log('Playing sound effect: $fileName');
      FlameAudio.play(fileName);
      _isSoundEffectPlaying = true;
    } else {
      log('Sound effect already playing.');
    }
  }
}
