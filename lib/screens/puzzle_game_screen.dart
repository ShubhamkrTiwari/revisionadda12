import 'dart:math';
import 'package:flutter/material.dart';
import '../models/subject.dart';

class PuzzleGameScreen extends StatefulWidget {
  final Subject subject;
  final int level;
  final VoidCallback onComplete;

  const PuzzleGameScreen({
    super.key,
    required this.subject,
    required this.level,
    required this.onComplete,
  });

  @override
  State<PuzzleGameScreen> createState() => _PuzzleGameScreenState();
}

class _PuzzleGameScreenState extends State<PuzzleGameScreen>
    with TickerProviderStateMixin {
  late List<GameTile> _puzzle;
  late List<GameTile> _solution;
  int? _selectedIndex;
  int _moves = 0;
  bool _isSolved = false;
  late AnimationController _successController;
  late AnimationController _shuffleController;

  @override
  void initState() {
    super.initState();
    _initializePuzzle();
    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _shuffleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _shufflePuzzle();
  }

  void _initializePuzzle() {
    final gameData = _getSubjectGameData();
    final size = 3; // 3x3 grid
    final total = size * size;
    
    // Create tiles with subject content
    _solution = [];
    for (int i = 0; i < total - 1; i++) {
      if (i < gameData.length) {
        _solution.add(GameTile(
          id: i + 1,
          text: gameData[i]['text']!,
          type: gameData[i]['type']!,
        ));
      } else {
        _solution.add(GameTile(
          id: i + 1,
          text: '${i + 1}',
          type: 'number',
        ));
      }
    }
    _solution.add(GameTile(id: 0, text: '', type: 'empty')); // Empty tile
    _puzzle = List.from(_solution);
  }

  List<Map<String, String>> _getSubjectGameData() {
    final subjectId = widget.subject.id;
    final level = widget.level;
    
    if (subjectId == 'physics') {
      return [
        {'text': 'F = k(q₁q₂)/r²', 'type': 'formula'},
        {'text': 'Coulomb\'s Law', 'type': 'concept'},
        {'text': 'E = F/q', 'type': 'formula'},
        {'text': 'Electric Field', 'type': 'concept'},
        {'text': 'V = kq/r', 'type': 'formula'},
        {'text': 'Electric Potential', 'type': 'concept'},
        {'text': 'I = V/R', 'type': 'formula'},
        {'text': 'Ohm\'s Law', 'type': 'concept'},
      ];
    } else if (subjectId == 'chemistry') {
      return [
        {'text': 'M = n/V', 'type': 'formula'},
        {'text': 'Molarity', 'type': 'concept'},
        {'text': 'Rate = k[A]ᵐ', 'type': 'formula'},
        {'text': 'Rate Law', 'type': 'concept'},
        {'text': 'pH = -log[H⁺]', 'type': 'formula'},
        {'text': 'pH Scale', 'type': 'concept'},
        {'text': 'ΔG = ΔH - TΔS', 'type': 'formula'},
        {'text': 'Gibbs Energy', 'type': 'concept'},
      ];
    } else if (subjectId == 'mathematics') {
      return [
        {'text': 'd/dx[f(x)]', 'type': 'formula'},
        {'text': 'Derivative', 'type': 'concept'},
        {'text': '∫f(x)dx', 'type': 'formula'},
        {'text': 'Integration', 'type': 'concept'},
        {'text': 'lim(x→a)', 'type': 'formula'},
        {'text': 'Limit', 'type': 'concept'},
        {'text': 'a² + b² = c²', 'type': 'formula'},
        {'text': 'Pythagoras', 'type': 'concept'},
      ];
    } else { // biology
      return [
        {'text': 'DNA → RNA', 'type': 'formula'},
        {'text': 'Transcription', 'type': 'concept'},
        {'text': 'RNA → Protein', 'type': 'formula'},
        {'text': 'Translation', 'type': 'concept'},
        {'text': 'A = T, G = C', 'type': 'formula'},
        {'text': 'Base Pairing', 'type': 'concept'},
        {'text': 'ATP → ADP', 'type': 'formula'},
        {'text': 'Energy Release', 'type': 'concept'},
      ];
    }
  }

  void _shufflePuzzle() {
    _shuffleController.forward();
    final random = Random();
    for (int i = 0; i < 100; i++) {
      final emptyIndex = _puzzle.indexWhere((tile) => tile.id == 0);
      final possibleMoves = _getPossibleMoves(emptyIndex);
      if (possibleMoves.isNotEmpty) {
        final move = possibleMoves[random.nextInt(possibleMoves.length)];
        _swapTiles(emptyIndex, move);
      }
    }
    _moves = 0;
    setState(() {});
  }

  List<int> _getPossibleMoves(int emptyIndex) {
    const size = 3;
    final row = emptyIndex ~/ size;
    final col = emptyIndex % size;
    final moves = <int>[];

    if (row > 0) moves.add(emptyIndex - size); // Up
    if (row < size - 1) moves.add(emptyIndex + size); // Down
    if (col > 0) moves.add(emptyIndex - 1); // Left
    if (col < size - 1) moves.add(emptyIndex + 1); // Right

    return moves;
  }

  void _swapTiles(int index1, int index2) {
    final temp = _puzzle[index1];
    _puzzle[index1] = _puzzle[index2];
    _puzzle[index2] = temp;
  }

  void _onTileTap(int index) {
    if (_isSolved || _puzzle[index].id == 0) return;

    final emptyIndex = _puzzle.indexWhere((tile) => tile.id == 0);
    final possibleMoves = _getPossibleMoves(emptyIndex);

    if (possibleMoves.contains(index)) {
      setState(() {
        _swapTiles(emptyIndex, index);
        _moves++;
        _checkSolved();
      });
    } else {
      _selectedIndex = index;
      setState(() {});
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _selectedIndex = null;
          });
        }
      });
    }
  }

  void _checkSolved() {
    bool solved = true;
    for (int i = 0; i < _puzzle.length; i++) {
      if (_puzzle[i].id != _solution[i].id) {
        solved = false;
        break;
      }
    }

    if (solved && !_isSolved) {
      _isSolved = true;
      _successController.forward();
      Future.delayed(const Duration(milliseconds: 1500), () {
        _showCompletionDialog();
      });
    }
  }

  void _showCompletionDialog() {
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
              colors: [Colors.green.shade400, Colors.green.shade600],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: Tween(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _successController,
                    curve: Curves.elasticOut,
                  ),
                ),
                child: const Icon(
                  Icons.celebration,
                  color: Colors.white,
                  size: 64,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Level Complete!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Moves: $_moves',
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'You mastered ${widget.subject.name}!',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                    ),
                    child: const Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onComplete();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.green,
                    ),
                    child: const Text('Next Level'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTileColor(String type) {
    switch (type) {
      case 'formula':
        return Colors.blue.shade400;
      case 'concept':
        return Colors.purple.shade400;
      default:
        return Colors.grey.shade300;
    }
  }

  @override
  void dispose() {
    _successController.dispose();
    _shuffleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const size = 3;
    final tileSize = (MediaQuery.of(context).size.width - 64) / size;

    return Scaffold(
      appBar: AppBar(
        title: Text('Level ${widget.level} - ${widget.subject.name}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _shufflePuzzle,
            tooltip: 'Shuffle',
          ),
        ],
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
        child: Column(
          children: [
            // Subject Info Card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(Icons.swap_horiz, 'Moves', '$_moves'),
                      _buildStatItem(Icons.timer, 'Level', '${widget.level}'),
                      _buildStatItem(Icons.extension, 'Puzzle', '3x3'),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lightbulb_outline,
                          color: Colors.purple.shade700,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Match formulas with concepts!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.purple.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Puzzle Grid
            Expanded(
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: size,
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 1,
                    ),
                    itemCount: _puzzle.length,
                    itemBuilder: (context, index) {
                      final tile = _puzzle[index];
                      final isEmpty = tile.id == 0;
                      final isSelected = _selectedIndex == index;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: GestureDetector(
                          onTap: () => _onTileTap(index),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: isEmpty
                                  ? null
                                  : LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: isSelected
                                          ? [
                                              Colors.orange.shade300,
                                              Colors.orange.shade500,
                                            ]
                                          : [
                                              _getTileColor(tile.type),
                                              _getTileColor(tile.type)
                                                  .withOpacity(0.8),
                                            ],
                                    ),
                              color: isEmpty ? Colors.grey[200] : null,
                              borderRadius: BorderRadius.circular(8),
                              border: isSelected
                                  ? Border.all(
                                      color: Colors.orange,
                                      width: 3,
                                    )
                                  : null,
                              boxShadow: isEmpty
                                  ? null
                                  : [
                                      BoxShadow(
                                        color: _getTileColor(tile.type)
                                            .withOpacity(0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                            ),
                            child: isEmpty
                                ? null
                                : Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Text(
                                        tile.text,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: tile.type == 'formula' ? 12 : 11,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            // Instructions
            Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade400,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Formula',
                        style: TextStyle(fontSize: 12),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.purple.shade400,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Concept',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tap tiles to arrange them in order!',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: Colors.purple, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class GameTile {
  final int id;
  final String text;
  final String type; // 'formula', 'concept', 'number', 'empty'

  GameTile({
    required this.id,
    required this.text,
    required this.type,
  });
}
