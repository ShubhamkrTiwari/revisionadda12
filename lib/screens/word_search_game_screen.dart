import 'dart:math';
import 'package:flutter/material.dart';
import '../models/subject.dart';

class WordSearchGameScreen extends StatefulWidget {
  final Subject subject;

  const WordSearchGameScreen({super.key, required this.subject});

  @override
  State<WordSearchGameScreen> createState() => _WordSearchGameScreenState();
}

class _WordSearchGameScreenState extends State<WordSearchGameScreen> {
  List<List<String>> _grid = [];
  List<String> _words = [];
  List<String> _foundWords = [];
  Set<int> _selectedCells = {};

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    _words = _getSubjectWords();
    _generateGrid();
    _foundWords = [];
    _selectedCells = {};
    setState(() {});
  }

  List<String> _getSubjectWords() {
    final subjectId = widget.subject.id;
    
    if (subjectId == 'physics') {
      return ['COULOMB', 'OHM', 'FARADAY', 'GAUSS', 'ELECTRIC', 'MAGNETIC'];
    } else if (subjectId == 'chemistry') {
      return ['MOLARITY', 'PH', 'RATE', 'GIBBS', 'NERNST', 'ARRHENIUS'];
    } else if (subjectId == 'mathematics') {
      return ['DERIVATIVE', 'INTEGRAL', 'LIMIT', 'PYTHAGORAS', 'CHAIN', 'PRODUCT'];
    } else {
      return ['TRANSCRIPTION', 'TRANSLATION', 'ATP', 'MITOSIS', 'PHOTOSYNTHESIS', 'DNA'];
    }
  }

  void _generateGrid() {
    const size = 12;
    _grid = List.generate(size, (_) => List.filled(size, ''));
    
    // Place words
    for (var word in _words) {
      _placeWord(word);
    }
    
    // Fill remaining cells
    final letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random();
    for (int i = 0; i < size; i++) {
      for (int j = 0; j < size; j++) {
        if (_grid[i][j].isEmpty) {
          _grid[i][j] = letters[random.nextInt(letters.length)];
        }
      }
    }
  }

  void _placeWord(String word) {
    final random = Random();
    bool placed = false;
    int attempts = 0;
    
    while (!placed && attempts < 100) {
      final row = random.nextInt(_grid.length);
      final col = random.nextInt(_grid.length);
      final horizontal = random.nextBool();
      
      if (horizontal && col + word.length <= _grid.length) {
        bool canPlace = true;
        for (int i = 0; i < word.length; i++) {
          if (_grid[row][col + i].isNotEmpty && _grid[row][col + i] != word[i]) {
            canPlace = false;
            break;
          }
        }
        if (canPlace) {
          for (int i = 0; i < word.length; i++) {
            _grid[row][col + i] = word[i];
          }
          placed = true;
        }
      } else if (!horizontal && row + word.length <= _grid.length) {
        bool canPlace = true;
        for (int i = 0; i < word.length; i++) {
          if (_grid[row + i][col].isNotEmpty && _grid[row + i][col] != word[i]) {
            canPlace = false;
            break;
          }
        }
        if (canPlace) {
          for (int i = 0; i < word.length; i++) {
            _grid[row + i][col] = word[i];
          }
          placed = true;
        }
      }
      attempts++;
    }
  }

  void _onCellTap(int row, int col) {
    setState(() {
      final index = row * _grid.length + col;
      if (_selectedCells.contains(index)) {
        _selectedCells.remove(index);
      } else {
        _selectedCells.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal.shade50, Colors.cyan.shade50],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildStatCard('Found', '${_foundWords.length}/${_words.length}', Colors.green),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _words.map((word) {
                    final isFound = _foundWords.contains(word);
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isFound ? Colors.green.shade100 : Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        word,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isFound ? Colors.green.shade700 : Colors.grey[600],
                          decoration: isFound ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: List.generate(_grid.length, (row) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(_grid[row].length, (col) {
                            final index = row * _grid.length + col;
                            final isSelected = _selectedCells.contains(index);
                            
                            return GestureDetector(
                              onTap: () => _onCellTap(row, col),
                              child: Container(
                                width: 28,
                                height: 28,
                                margin: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.blue.shade200 : Colors.white,
                                  border: Border.all(
                                    color: isSelected ? Colors.blue : Colors.grey[300]!,
                                    width: isSelected ? 2 : 1,
                                  ),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Text(
                                    _grid[row][col],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.blue.shade700 : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _initializeGame,
                    child: const Text('New Game'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    final bgColor = _getShadeColor(color, 100);
    final textColor = _getShadeColor(color, 700);
    final labelColor = _getShadeColor(color, 600);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }

  Color _getShadeColor(Color color, int shade) {
    if (color == Colors.green) return Colors.green[shade]!;
    return color;
  }
}

