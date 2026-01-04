import 'game_level.dart';

class AvengerGameQuestion {
  final String id;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final String explanation;
  final String avengerName;
  final String avengerIcon;
  final String avengerColor;
  final String concept;

  AvengerGameQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.explanation,
    required this.avengerName,
    required this.avengerIcon,
    required this.avengerColor,
    required this.concept,
  });
}

class AvengerGame {
  final String chapterId;
  final String chapterName;
  final List<AvengerGameQuestion> questions;
  final String mainAvengerName;
  final String mainAvengerIcon;
  final String mainAvengerColor;
  final List<GameLevel> levels;

  AvengerGame({
    required this.chapterId,
    required this.chapterName,
    required this.questions,
    required this.mainAvengerName,
    required this.mainAvengerIcon,
    required this.mainAvengerColor,
    required this.levels,
  });
}

