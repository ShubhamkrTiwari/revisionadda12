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
import 'subscription_screen.dart';

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
  bool _isLocked = false;

  @override
  void initState() {
    super.initState();
    _checkLockStatus();
  }

  Future<void> _checkLockStatus() async {
    final isLocked = await SubscriptionService.isGameLocked(
      widget.subject.id,
      widget.gameType,
    );

    if (isLocked) {
      if (mounted) {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SubscriptionScreen(
              onSubscribe: () {
                // Reload the status after subscription
                _checkLockStatus();
              },
            ),
          ),
        );
      }
    } else {
      // Mark game as completed only when it's played
      await SubscriptionService.markGameCompleted(
        widget.subject.id,
        widget.gameType,
      );
    }

    if (mounted) {
      setState(() {
        _isLocked = isLocked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLocked) {
      return const Scaffold(
        body: Center(
          child: Text('Redirecting to subscription...'),
        ),
      );
    }

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
          level: 1, // Example level
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
