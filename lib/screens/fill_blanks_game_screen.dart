import 'dart:math';
import 'package:flutter/material.dart';
import '../models/subject.dart';

class FillBlanksGameScreen extends StatefulWidget {
  final Subject subject;

  const FillBlanksGameScreen({super.key, required this.subject});

  @override
  State<FillBlanksGameScreen> createState() => _FillBlanksGameScreenState();
}

class _FillBlanksGameScreenState extends State<FillBlanksGameScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  String _userAnswer = '';
  List<Map<String, dynamic>> _questions = [];

  @override
  void initState() {
    super.initState();
    _questions = _generateQuestions();
  }

  List<Map<String, dynamic>> _generateQuestions() {
    final subjectId = widget.subject.id;
    
    if (subjectId == 'physics') {
      return [
        {
          'sentence': 'According to ______ Law, F = k(q₁q₂)/r²',
          'answer': 'Coulomb\'s',
          'options': ['Coulomb\'s', 'Ohm\'s', 'Faraday\'s', 'Gauss\'s'],
        },
        {
          'sentence': 'Electric field E = ______ /q',
          'answer': 'F',
          'options': ['F', 'V', 'I', 'R'],
        },
        {
          'sentence': 'Ohm\'s Law states V = ______',
          'answer': 'IR',
          'options': ['IR', 'I/R', 'I²R', 'R/I'],
        },
      ];
    } else if (subjectId == 'chemistry') {
      return [
        {
          'sentence': 'Molarity M = ______ /V',
          'answer': 'n',
          'options': ['n', 'V', 'm', 'M'],
        },
        {
          'sentence': 'pH = -log[______]',
          'answer': 'H⁺',
          'options': ['H⁺', 'OH⁻', 'H₂O', 'H₂'],
        },
        {
          'sentence': 'Rate Law: Rate = k[______]ᵐ',
          'answer': 'A',
          'options': ['A', 'B', 'C', 'D'],
        },
      ];
    } else if (subjectId == 'mathematics') {
      return [
        {
          'sentence': 'Derivative of x² is ______',
          'answer': '2x',
          'options': ['2x', 'x', 'x²', '2x²'],
        },
        {
          'sentence': '∫x dx = x²/2 + ______',
          'answer': 'C',
          'options': ['C', 'x', '0', '1'],
        },
        {
          'sentence': 'Pythagorean theorem: a² + b² = ______',
          'answer': 'c²',
          'options': ['c²', 'c', '2c', 'c/2'],
        },
      ];
    } else {
      return [
        {
          'sentence': 'DNA transcription produces ______',
          'answer': 'RNA',
          'options': ['RNA', 'DNA', 'Protein', 'ATP'],
        },
        {
          'sentence': 'Base pairing: A pairs with ______',
          'answer': 'T',
          'options': ['T', 'G', 'C', 'A'],
        },
        {
          'sentence': 'ATP stands for Adenosine ______',
          'answer': 'Triphosphate',
          'options': ['Triphosphate', 'Diphosphate', 'Monophosphate', 'Phosphate'],
        },
      ];
    }
  }

  void _checkAnswer() {
    if (_userAnswer.isEmpty) return;
    
    final question = _questions[_currentQuestion];
    final isCorrect = _userAnswer.trim().toLowerCase() == 
        question['answer'].toString().toLowerCase();
    
    if (isCorrect) {
      _score++;
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isCorrect ? '✅ Correct!' : '❌ Wrong'),
        content: Text(isCorrect 
            ? 'Well done!'
            : 'Correct answer: ${question['answer']}'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (_currentQuestion < _questions.length - 1) {
                setState(() {
                  _currentQuestion++;
                  _userAnswer = '';
                });
              } else {
                _showFinalScore();
              }
            },
            child: const Text('Next'),
          ),
        ],
      ),
    );
  }

  void _showFinalScore() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎯 Complete!'),
        content: Text('Your Score: $_score/${_questions.length}'),
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
              setState(() {
                _currentQuestion = 0;
                _score = 0;
                _userAnswer = '';
                _questions = _generateQuestions();
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) return const Center(child: CircularProgressIndicator());
    
    final question = _questions[_currentQuestion];
    final sentenceParts = question['sentence'].toString().split('______');
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.indigo.shade50, Colors.purple.shade50],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: _buildStatCard('Score', '$_score/${_questions.length}', Colors.indigo),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 20, color: Colors.black87),
                          children: [
                            TextSpan(text: sentenceParts[0]),
                            WidgetSpan(
                              child: Container(
                                width: 120,
                                height: 40,
                                margin: const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue, width: 2),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    _userAnswer.isEmpty ? '?' : _userAnswer,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            if (sentenceParts.length > 1)
                              TextSpan(text: sentenceParts[1]),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: (question['options'] as List).map<Widget>((option) {
                      return ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _userAnswer = option.toString();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _userAnswer == option
                              ? Colors.blue
                              : Colors.grey[200],
                          foregroundColor: _userAnswer == option
                              ? Colors.white
                              : Colors.black87,
                        ),
                        child: Text(option.toString()),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _userAnswer.isNotEmpty ? _checkAnswer : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('Check Answer'),
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
    if (color == Colors.indigo) return Colors.indigo[shade]!;
    return color;
  }
}

