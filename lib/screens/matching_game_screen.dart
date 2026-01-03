import 'dart:math';
import 'package:flutter/material.dart';
import '../models/subject.dart';

class MatchingGameScreen extends StatefulWidget {
  final Subject subject;

  MatchingGameScreen({super.key, required this.subject});

  @override
  State<MatchingGameScreen> createState() => _MatchingGameScreenState();
}

class _MatchingGameScreenState extends State<MatchingGameScreen> {
  List<MatchItem> _leftItems = [];
  List<MatchItem> _rightItems = [];
  MatchItem? _selectedLeft;
  MatchItem? _selectedRight;
  int _matches = 0;
  int _totalMatches = 0;
  bool _isComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    final pairs = _getSubjectPairs();
    _totalMatches = pairs.length;
    
    _leftItems = pairs.map((pair) => MatchItem(
      id: pair['concept']!,
      text: pair['concept']!,
      isMatched: false,
    )).toList();
    
    _rightItems = pairs.map((pair) => MatchItem(
      id: pair['concept']!,
      text: pair['definition']!,
      isMatched: false,
    )).toList();
    
    _rightItems.shuffle(Random());
    setState(() {});
  }

  List<Map<String, String>> _getSubjectPairs() {
    final subjectId = widget.subject.id;
    
    if (subjectId == 'physics') {
      return [
        {'concept': 'Coulomb\'s Law', 'definition': 'F = k(q₁q₂)/r²'},
        {'concept': 'Ohm\'s Law', 'definition': 'V = IR'},
        {'concept': 'Electric Field', 'definition': 'E = F/q'},
        {'concept': 'Electric Potential', 'definition': 'V = kq/r'},
        {'concept': 'Magnetic Field', 'definition': 'B = μ₀I/2πr'},
        {'concept': 'Faraday\'s Law', 'definition': 'ε = -dΦ/dt'},
      ];
    } else if (subjectId == 'chemistry') {
      return [
        {'concept': 'Molarity', 'definition': 'M = n/V'},
        {'concept': 'Rate Law', 'definition': 'Rate = k[A]ᵐ[B]ⁿ'},
        {'concept': 'pH Scale', 'definition': 'pH = -log[H⁺]'},
        {'concept': 'Gibbs Energy', 'definition': 'ΔG = ΔH - TΔS'},
        {'concept': 'Nernst Equation', 'definition': 'E = E° - (RT/nF)lnQ'},
        {'concept': 'Arrhenius Equation', 'definition': 'k = Ae^(-Ea/RT)'},
      ];
    } else if (subjectId == 'mathematics') {
      return [
        {'concept': 'Derivative', 'definition': 'd/dx[f(x)]'},
        {'concept': 'Integration', 'definition': '∫f(x)dx'},
        {'concept': 'Limit', 'definition': 'lim(x→a) f(x)'},
        {'concept': 'Pythagoras', 'definition': 'a² + b² = c²'},
        {'concept': 'Chain Rule', 'definition': 'd/dx[f(g(x))] = f\'(g(x))g\'(x)'},
        {'concept': 'Product Rule', 'definition': 'd/dx[uv] = u\'v + uv\''},
      ];
    } else {
      return [
        {'concept': 'Transcription', 'definition': 'DNA → RNA'},
        {'concept': 'Translation', 'definition': 'RNA → Protein'},
        {'concept': 'Base Pairing', 'definition': 'A=T, G=C'},
        {'concept': 'ATP', 'definition': 'Adenosine Triphosphate'},
        {'concept': 'Mitosis', 'definition': 'Cell division'},
        {'concept': 'Photosynthesis', 'definition': 'CO₂ + H₂O → Glucose'},
      ];
    }
  }

  void _onLeftTap(MatchItem item) {
    if (item.isMatched) return;
    
    setState(() {
      if (_selectedLeft?.id == item.id) {
        _selectedLeft = null;
      } else {
        _selectedLeft = item;
        if (_selectedRight != null) {
          _checkMatch();
        }
      }
    });
  }

  void _onRightTap(MatchItem item) {
    if (item.isMatched) return;
    
    setState(() {
      if (_selectedRight?.id == item.id) {
        _selectedRight = null;
      } else {
        _selectedRight = item;
        if (_selectedLeft != null) {
          _checkMatch();
        }
      }
    });
  }

  void _checkMatch() {
    if (_selectedLeft != null && _selectedRight != null) {
      if (_selectedLeft!.id == _selectedRight!.id) {
        // Correct match
        setState(() {
          _selectedLeft!.isMatched = true;
          _selectedRight!.isMatched = true;
          _matches++;
          _selectedLeft = null;
          _selectedRight = null;
          
          if (_matches == _totalMatches) {
            _isComplete = true;
            Future.delayed(const Duration(milliseconds: 500), () {
              _showCompletionDialog();
            });
          }
        });
      } else {
        // Wrong match
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            setState(() {
              _selectedLeft = null;
              _selectedRight = null;
            });
          }
        });
      }
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎉 Perfect Match!'),
        content: Text('You matched all $_totalMatches pairs correctly!'),
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
          colors: [Colors.blue.shade50, Colors.purple.shade50],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Matches', '$_matches/$_totalMatches', Colors.green),
                _buildStatCard('Subject', widget.subject.name, Colors.blue),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: _buildColumn('Concepts', _leftItems, _onLeftTap, Colors.blue),
                ),
                Container(
                  width: 2,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: _buildColumn('Definitions', _rightItems, _onRightTap, Colors.purple),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColumn(String title, List<MatchItem> items, Function(MatchItem) onTap, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: _getShadeColor(color, 100),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: _getShadeColor(color, 700),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final isSelected = (title == 'Concepts' && _selectedLeft?.id == item.id) ||
                  (title == 'Definitions' && _selectedRight?.id == item.id);
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: InkWell(
                  onTap: () => onTap(item),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: item.isMatched
                          ? Colors.green.shade100
                          : isSelected
                              ? _getShadeColor(color, 200)
                              : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: item.isMatched
                            ? Colors.green
                            : isSelected
                                ? color
                                : Colors.grey[300]!,
                        width: item.isMatched || isSelected ? 2 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        if (item.isMatched)
                          const Icon(Icons.check_circle, color: Colors.green),
                        if (item.isMatched) const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            item.text,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: item.isMatched ? FontWeight.bold : FontWeight.normal,
                              color: item.isMatched ? Colors.green.shade700 : Colors.black87,
                              decoration: item.isMatched ? TextDecoration.lineThrough : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
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
    if (color == Colors.blue) return Colors.blue[shade]!;
    if (color == Colors.purple) return Colors.purple[shade]!;
    return color;
  }
}

class MatchItem {
  final String id;
  final String text;
  bool isMatched;

  MatchItem({
    required this.id,
    required this.text,
    this.isMatched = false,
  });
}

