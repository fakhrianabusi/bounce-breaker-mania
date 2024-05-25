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

  void pauseBgm() {
    if (_isBgmPlaying) {
      FlameAudio.bgm.pause();
      _isBgmPlaying = false;
    }
  }

  void resumeBgm() {
    if (!_isBgmPlaying) {
      FlameAudio.bgm.resume();
      _isBgmPlaying = true;
    }
  }

  void playSound(String fileName) {
    if (!_isSoundEffectPlaying) {
      log('Playing sound effect: $fileName');
      _isSoundEffectPlaying = true;
      FlameAudio.play(fileName).then((_) {
        _isSoundEffectPlaying = false;
      });
    } else {
      log('Sound effect already playing.');
    }
  }
}
