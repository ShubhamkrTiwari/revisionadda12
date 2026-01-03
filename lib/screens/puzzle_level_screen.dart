import 'dart:math';
import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../services/subscription_service.dart';
import 'game_types_screen.dart';
import 'subscription_screen.dart';

class PuzzleLevelScreen extends StatefulWidget {
  final Subject subject;

  const PuzzleLevelScreen({
    super.key,
    required this.subject,
  });

  @override
  State<PuzzleLevelScreen> createState() => _PuzzleLevelScreenState();
}

class _PuzzleLevelScreenState extends State<PuzzleLevelScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int _unlockedLevels = 1;
  final int _totalLevels = 15;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onLevelComplete(int level) {
    if (level == _unlockedLevels && _unlockedLevels < _totalLevels) {
      setState(() {
        _unlockedLevels++;
      });
      _showLevelUnlockedDialog(level + 1);
    }
  }

  void _showLevelUnlockedDialog(int nextLevel) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple.shade400, Colors.purple.shade600],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_open,
                        color: Colors.purple,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Level Unlocked!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Level $nextLevel is now available',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.purple,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                child: const Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subject.name} - Games'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade50,
              Colors.blue.shade50,
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.purple.shade400,
                        Colors.purple.shade600,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.sports_esports,
                        color: Colors.white,
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        widget.subject.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder<bool>(
                        future: SubscriptionService.isSubscribed(),
                        builder: (context, snapshot) {
                          final isSubscribed = snapshot.data ?? false;
                          if (isSubscribed) {
                            return const Text(
                              'Choose a game type to play',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white70,
                              ),
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.lock, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Subscribe to unlock all games',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Game Types Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.1,
                ),
                itemCount: 8,
                itemBuilder: (context, index) {
                  return _buildGameTypeCard(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameTypeCard(int index) {
    final gameTypes = [
      {
        'name': 'Puzzle',
        'icon': Icons.extension,
        'color': Colors.purple,
        'description': 'Slide tiles to match',
      },
      {
        'name': 'Matching',
        'icon': Icons.compare_arrows,
        'color': Colors.blue,
        'description': 'Match concepts',
      },
      {
        'name': 'Quiz',
        'icon': Icons.quiz,
        'color': Colors.green,
        'description': 'Quick questions',
      },
      {
        'name': 'Memory',
        'icon': Icons.memory,
        'color': Colors.orange,
        'description': 'Find pairs',
      },
      {
        'name': 'Word Search',
        'icon': Icons.search,
        'color': Colors.red,
        'description': 'Find words',
      },
      {
        'name': 'Fill Blanks',
        'icon': Icons.edit,
        'color': Colors.teal,
        'description': 'Complete sentences',
      },
      {
        'name': 'True/False',
        'icon': Icons.check_circle,
        'color': Colors.indigo,
        'description': 'Answer statements',
      },
      {
        'name': 'Sequence',
        'icon': Icons.sort,
        'color': Colors.pink,
        'description': 'Arrange in order',
      },
    ];

    final game = gameTypes[index];

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: FutureBuilder<bool>(
        future: SubscriptionService.isGameLocked(
          widget.subject.id,
          game['name'] as String,
        ),
        builder: (context, snapshot) {
          final isLocked = snapshot.data ?? false;
          return InkWell(
            onTap: isLocked
                ? () async {
                    // Show subscription screen
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubscriptionScreen(
                          onSubscribe: () {
                            setState(() {}); // Refresh UI
                          },
                        ),
                      ),
                    );
                    // Refresh after returning from subscription screen
                    setState(() {});
                  }
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GameTypesScreen(
                          subject: widget.subject,
                          gameType: game['name'] as String,
                        ),
                      ),
                    ).then((_) {
                      // Reload status after completing a game
                      setState(() {});
                    });
                  },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: _getGradientColors(game['color'] as Color),
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: (game['color'] as Color).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isLocked ? Icons.lock : game['icon'] as IconData,
                        color: Colors.white,
                        size: 40,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        game['name'] as String,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isLocked ? 'Locked' : game['description'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  if (isLocked)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Color> _getGradientColors(Color color) {
    if (color == Colors.purple) return [Colors.purple.shade400, Colors.purple.shade600];
    if (color == Colors.blue) return [Colors.blue.shade400, Colors.blue.shade600];
    if (color == Colors.green) return [Colors.green.shade400, Colors.green.shade600];
    if (color == Colors.orange) return [Colors.orange.shade400, Colors.orange.shade600];
    if (color == Colors.red) return [Colors.red.shade400, Colors.red.shade600];
    if (color == Colors.teal) return [Colors.teal.shade400, Colors.teal.shade600];
    if (color == Colors.indigo) return [Colors.indigo.shade400, Colors.indigo.shade600];
    if (color == Colors.pink) return [Colors.pink.shade400, Colors.pink.shade600];
    return [color, color];
  }
}
