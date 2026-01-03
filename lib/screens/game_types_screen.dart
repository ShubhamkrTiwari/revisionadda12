import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../services/subscription_service.dart';
import 'puzzle_game_screen.dart';
import 'matching_game_screen.dart';
import 'quiz_game_screen.dart';
import 'memory_game_screen.dart';
import 'word_search_game_screen.dart';
import 'fill_blanks_game_screen.dart';
import 'true_false_game_screen.dart';
import 'sequence_game_screen.dart';

class GameTypesScreen extends StatefulWidget {
  final Subject subject;
  final String gameType;

  const GameTypesScreen({
    super.key,
    required this.subject,
    required this.gameType,
  });

  @override
  State<GameTypesScreen> createState() => _GameTypesScreenState();
}

class _GameTypesScreenState extends State<GameTypesScreen> {
  @override
  void initState() {
    super.initState();
    // Mark game as completed when user starts playing
    _markGameStarted();
  }

  Future<void> _markGameStarted() async {
    // Mark game as completed when user plays it (for both free and subscribed users)
    await SubscriptionService.markGameCompleted(
      widget.subject.id,
      widget.gameType,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.gameType} - ${widget.subject.name}'),
      ),
      body: _buildGameScreen(context),
    );
  }

  Widget _buildGameScreen(BuildContext context) {
    switch (widget.gameType) {
      case 'Puzzle':
        return PuzzleGameScreen(
          subject: widget.subject,
          level: 1,
          onComplete: () {},
        );
      case 'Matching':
        return MatchingGameScreen(subject: widget.subject);
      case 'Quiz':
        return QuizGameScreen(subject: widget.subject);
      case 'Memory':
        return MemoryGameScreen(subject: widget.subject);
      case 'Word Search':
        return WordSearchGameScreen(subject: widget.subject);
      case 'Fill Blanks':
        return FillBlanksGameScreen(subject: widget.subject);
      case 'True/False':
        return TrueFalseGameScreen(subject: widget.subject);
      case 'Sequence':
        return SequenceGameScreen(subject: widget.subject);
      default:
        return const Center(child: Text('Game not found'));
    }
  }
}

