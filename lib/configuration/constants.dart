import 'package:flame/game.dart';
import 'package:flutter/material.dart';

const screenWidth = 720.00;
const screenHeight = 1600.00;
const screenColor = Color(0xFF22272B);
const ballRadius = screenWidth * 0.02;
const playerStickWidth = 200.00;
const playerStickHeight = 40.00;
const playerStickMoveSteps = screenWidth * 0.03;
const difficultyModifier = 1.02;
final brickSize = Vector2(50, 40);

const bickPadding = 2.5;
const brickGutter = screenWidth * 0.015;

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
  [0, 2, 2, 2, 2, 0, 0, 2, 2, 2, 2, 0],
  [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
  [2, 1, 0, 1, 2, 2, 2, 2, 1, 0, 1, 2],
  [2, 1, 1, 1, 2, 2, 2, 2, 1, 1, 1, 2],
  [2, 1, 0, 1, 2, 3, 3, 2, 1, 0, 1, 2],
  [1, 1, 1, 1, 1, 2, 2, 1, 1, 1, 1, 1],
  [0, 2, 2, 2, 3, 3, 3, 3, 2, 2, 2, 0],
];

final level_1Position = level_1[0].length * (brickSize.x + bickPadding) - bickPadding;
final level_2Position = level_2[0].length * (brickSize.x + bickPadding) - bickPadding;
