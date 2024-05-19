import 'package:flame/game.dart';
import 'package:flutter/material.dart';

Size screenSize = WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
double screenWidth = screenSize.width;
double screenHeight = screenSize.height;

double ballRadius = screenWidth * 0.02;
double playerStickMoveSteps = screenWidth * 0.03;
double brickGutter = screenWidth * 0.015;

const screenColor = Color.fromARGB(30, 255, 0, 221);

const playerStickWidth = 200.00;
const playerStickHeight = 30.00;

const difficultyModifier = 1.01;
final brickSize = Vector2(50, 40);

const brickPadding = 2.5;

final Map<int, Color> blockColors = {
  1: Colors.red,
  2: Colors.green,
  3: Colors.blue,
};

//levels

List<List<int>> level_1 = [
  [0, 0, 2, 1, 0, 1, 1, 0, 0],
  [0, 1, 1, 2, 1, 2, 1, 1, 0],
  [1, 2, 1, 1, 1, 1, 1, 2, 1],
  [1, 1, 1, 1, 2, 2, 1, 1, 1],
  [0, 1, 2, 1, 1, 1, 2, 1, 0],
  [0, 0, 1, 2, 1, 1, 1, 0, 0],
  [0, 0, 0, 1, 1, 2, 0, 0, 0],
];

List<List<int>> level_2 = [
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

double calculateLevelCenter(List<List<int>> level) {
  return level[0].length * (brickSize.x + brickPadding) - brickPadding;
}

double convertRadiusToSigma(double radius) {
  return radius * 0.57735 + 0.5;
}
