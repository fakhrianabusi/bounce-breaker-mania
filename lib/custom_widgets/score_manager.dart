import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ScoreManager {
  ValueNotifier<int> currentScore = ValueNotifier<int>(0);
  ValueNotifier<int> highScore = ValueNotifier<int>(0);

  ScoreManager() {
    loadScores();
  }

  void loadScores() async {
    final prefs = await SharedPreferences.getInstance();
    currentScore.value = prefs.getInt('game_current_score') ?? 0;
    highScore.value = prefs.getInt('game_high_score') ?? 0;
  }

  Future<void> saveCurrentScore() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('game_current_score', currentScore.value);
  }

  Future<void> resetScore() async {
    currentScore.value = 0;
    await saveCurrentScore();
  }

  Future<void> updateHighScore() async {
    if (currentScore.value > highScore.value) {
      highScore.value = currentScore.value;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('game_high_score', highScore.value);
    }
  }
}
