import 'package:flutter/material.dart';

class GameConstants {
  static const noBricksInRow = 10;
  static const brickPadding = 10.0;
  static const maxValueOfBrick = 3;
  static const noBricksLayer = 5;
}

const screenWidth = 720.00;
const screenHeight = 1600.00;
const screenColor = Color(0xFF22272B);
const ballRadius = screenWidth * 0.02;
const playerStickWidth = 200.00;
const playerStickHeight = 40.00;
const playerStickMoveSteps = screenWidth * 0.03;
const difficultyModifier = 1.02;
const brickWidth = 60.00;
const brickHeight = 40.00;
const padding = 10.0;
const brickGutter = screenWidth * 0.015;

final Map<int, Color> blockColors = {
  1: Colors.red,
  2: Colors.green,
  3: Colors.blue,
};
