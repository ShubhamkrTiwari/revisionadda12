import 'avenger_game.dart';

class GameLevel {
  final int levelNumber;
  final String levelName;
  final String avengerName;
  final String avengerIcon;
  final String avengerColor;
  final List<AvengerGameQuestion> questions;
  final bool isUnlocked;
  final bool isCompleted;

  GameLevel({
    required this.levelNumber,
    required this.levelName,
    required this.avengerName,
    required this.avengerIcon,
    required this.avengerColor,
    required this.questions,
    this.isUnlocked = false,
    this.isCompleted = false,
  });
}

