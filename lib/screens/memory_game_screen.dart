import 'dart:math';
import 'package:flutter/material.dart';
import '../models/subject.dart';

class MemoryGameScreen extends StatefulWidget {
  final Subject subject;

  const MemoryGameScreen({super.key, required this.subject});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<MemoryCard> _cards = [];
  List<int> _flippedIndices = [];
  int _matches = 0;
  int _moves = 0;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final pairs = _getSubjectPairs();
    _cards = [];
    
    for (var pair in pairs) {
      _cards.add(MemoryCard(id: pair['id']!, text: pair['text']!, isFlipped: false, isMatched: false));
      _cards.add(MemoryCard(id: pair['id']!, text: pair['text']!, isFlipped: false, isMatched: false));
    }
    
    _cards.shuffle(Random());
    _matches = 0;
    _moves = 0;
    _flippedIndices = [];
    _isComplete = false;
    setState(() {});
  }

  List<Map<String, String>> _getSubjectPairs() {
    final subjectId = widget.subject.id;
    
    if (subjectId == 'physics') {
      return [
        {'id': '1', 'text': 'Coulomb\'s Law'},
        {'id': '2', 'text': 'Ohm\'s Law'},
        {'id': '3', 'text': 'Electric Field'},
        {'id': '4', 'text': 'Magnetic Field'},
        {'id': '5', 'text': 'Faraday\'s Law'},
        {'id': '6', 'text': 'Gauss\'s Law'},
      ];
    } else if (subjectId == 'chemistry') {
      return [
        {'id': '1', 'text': 'Molarity'},
        {'id': '2', 'text': 'pH Scale'},
        {'id': '3', 'text': 'Rate Law'},
        {'id': '4', 'text': 'Gibbs Energy'},
        {'id': '5', 'text': 'Nernst Eq'},
        {'id': '6', 'text': 'Arrhenius'},
      ];
    } else if (subjectId == 'mathematics') {
      return [
        {'id': '1', 'text': 'Derivative'},
        {'id': '2', 'text': 'Integration'},
        {'id': '3', 'text': 'Limit'},
        {'id': '4', 'text': 'Pythagoras'},
        {'id': '5', 'text': 'Chain Rule'},
        {'id': '6', 'text': 'Product Rule'},
      ];
    } else {
      return [
        {'id': '1', 'text': 'Transcription'},
        {'id': '2', 'text': 'Translation'},
        {'id': '3', 'text': 'Base Pairing'},
        {'id': '4', 'text': 'ATP'},
        {'id': '5', 'text': 'Mitosis'},
        {'id': '6', 'text': 'Photosynthesis'},
      ];
    }
  }

  void _flipCard(int index) {
    if (_cards[index].isFlipped || _cards[index].isMatched || _flippedIndices.length >= 2) {
      return;
    }

    setState(() {
      _cards[index].isFlipped = true;
      _flippedIndices.add(index);
      
      if (_flippedIndices.length == 2) {
        _moves++;
        _checkMatch();
      }
    });
  }

  void _checkMatch() {
    final first = _cards[_flippedIndices[0]];
    final second = _cards[_flippedIndices[1]];
    
    if (first.id == second.id) {
      // Match found
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          setState(() {
            first.isMatched = true;
            second.isMatched = true;
            _matches++;
            _flippedIndices.clear();
            
            if (_matches == _cards.length ~/ 2) {
              _isComplete = true;
              _showCompletionDialog();
            }
          });
        }
      });
    } else {
      // No match
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            first.isFlipped = false;
            second.isFlipped = false;
            _flippedIndices.clear();
          });
        }
      });
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 Memory Master!'),
        content: Text('You completed in $_moves moves!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Back'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeGame();
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.orange.shade50, Colors.pink.shade50],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Matches', '$_matches/${_cards.length ~/ 2}', Colors.green),
                _buildStatCard('Moves', '$_moves', Colors.orange),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.9,
              ),
              itemCount: _cards.length,
              itemBuilder: (context, index) {
                final card = _cards[index];
                return GestureDetector(
                  onTap: () => _flipCard(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    decoration: BoxDecoration(
                      color: card.isMatched
                          ? Colors.green.shade100
                          : card.isFlipped
                              ? Colors.white
                              : Colors.blue.shade400,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: card.isMatched
                            ? Colors.green
                            : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: card.isFlipped || card.isMatched
                        ? Center(
                            child: Text(
                              card.text,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: card.isMatched ? Colors.green.shade700 : Colors.black87,
                              ),
                            ),
                          )
                        : const Center(
                            child: Icon(
                              Icons.help_outline,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                  ),
                );
              },
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
    if (color == Colors.orange) return Colors.orange[shade]!;
    return color;
  }
}

class MemoryCard {
  final String id;
  final String text;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.text,
    this.isFlipped = false,
    this.isMatched = false,
  });
}

