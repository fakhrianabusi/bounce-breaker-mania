import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

double screenWidth = 768;
double screenHeight = 1728;

double ballRadius = screenWidth * 0.02;
double playerStickMoveSteps = screenWidth * 0.03;
double brickGutter = screenWidth * 0.015;

const screenColor = Color.fromARGB(30, 255, 0, 221);

Vector2 playerStickSize = Vector2(screenWidth / 6, screenHeight / 80);

const difficultyModifier = 1.01;
final brickSize = Vector2(screenWidth / 16, screenHeight / 40);

const brickPadding = 10;

final Map<int, Color> blockColors = {
  1: Colors.red,
  2: Colors.green,
  3: Colors.blue,
};

//levels
List<List<int>> level_1 = [
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 2, 1, 1, 2, 0, 0, 0, 0],
  [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
  [1, 0, 1, 1, 3, 3, 3, 1, 1, 1, 0, 1],
  [1, 0, 1, 1, 3, 3, 3, 1, 1, 1, 0, 1],
  [0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0],
  [0, 0, 0, 0, 3, 2, 2, 3, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 2, 2, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
];
final lv_1PositionX = (screenWidth - calculateLevelCenter(level_1, kIsWeb)) / 2;

List<List<int>> level_2 = [
  [0, 0, 2, 1, 0, 1, 1, 0, 0],
  [0, 1, 1, 2, 1, 2, 1, 1, 0],
  [1, 2, 1, 1, 1, 1, 1, 2, 1],
  [1, 1, 1, 1, 2, 2, 1, 1, 1],
  [0, 1, 2, 1, 1, 1, 2, 1, 0],
  [0, 0, 1, 2, 1, 1, 1, 0, 0],
  [0, 0, 0, 1, 1, 2, 0, 0, 0],
];
final lv_2PositionX = (screenWidth - calculateLevelCenter(level_2, kIsWeb)) / 2;

List<List<int>> level_3 = [
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  [0, 0, 0, 1, 1, 0, 0, 0, 0, 1, 1, 0, 0, 0],
  [0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0],
  [0, 0, 0, 0, 2, 1, 1, 1, 1, 2, 0, 0, 0, 0],
  [0, 0, 0, 2, 2, 1, 1, 1, 1, 2, 2, 0, 0, 0],
  [0, 0, 2, 3, 2, 0, 1, 1, 0, 2, 3, 2, 0, 0],
  [0, 2, 3, 1, 2, 1, 1, 1, 1, 2, 1, 3, 2, 0],
  [0, 2, 0, 2, 2, 1, 1, 1, 1, 2, 2, 0, 2, 0],
  [0, 2, 0, 3, 1, 1, 2, 2, 1, 1, 3, 0, 2, 0],
  [0, 2, 0, 3, 0, 0, 0, 0, 0, 0, 3, 0, 2, 0],
  [0, 0, 0, 0, 3, 3, 0, 0, 3, 3, 0, 0, 0, 0],
  [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
];
final lv_3PositionX = (screenWidth - calculateLevelCenter(level_3, kIsWeb)) / 2;

double calculateLevelCenter(List<List<int>> level, bool platform) {
  if (platform) {
    return level[0].length * (brickSize.x + brickPadding) - brickPadding * 36;
  }
  return level[0].length * (brickSize.x + brickPadding) - brickPadding;
}

double convertRadiusToSigma(double radius) {
  return radius * 0.57735 + 0.5;
}
