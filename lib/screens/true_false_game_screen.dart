import 'dart:math';
import 'package:flutter/material.dart';
import '../models/subject.dart';

class TrueFalseGameScreen extends StatefulWidget {
  final Subject subject;

  const TrueFalseGameScreen({super.key, required this.subject});

  @override
  State<TrueFalseGameScreen> createState() => _TrueFalseGameScreenState();
}

class _TrueFalseGameScreenState extends State<TrueFalseGameScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  bool? _selectedAnswer;
  bool _showResult = false;
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
        {'statement': 'Coulomb\'s Law states F = k(q₁q₂)/r²', 'answer': true},
        {'statement': 'Ohm\'s Law is V = I/R', 'answer': false},
        {'statement': 'Electric field is measured in N/C', 'answer': true},
        {'statement': 'Magnetic field lines are open curves', 'answer': false},
        {'statement': 'Faraday\'s Law relates to electromagnetic induction', 'answer': true},
      ];
    } else if (subjectId == 'chemistry') {
      return [
        {'statement': 'Molarity is n/V', 'answer': true},
        {'statement': 'pH of 10⁻³ M H⁺ is 3', 'answer': true},
        {'statement': 'Rate law is Rate = k[A]', 'answer': false},
        {'statement': 'Gibbs energy ΔG = ΔH + TΔS', 'answer': false},
        {'statement': 'Nernst equation relates concentration and potential', 'answer': true},
      ];
    } else if (subjectId == 'mathematics') {
      return [
        {'statement': 'Derivative of x² is 2x', 'answer': true},
        {'statement': '∫x dx = x²/2', 'answer': false},
        {'statement': 'Pythagorean theorem is a² + b² = c²', 'answer': true},
        {'statement': 'Chain rule is d/dx[f(g(x))] = f\'(g(x))', 'answer': false},
        {'statement': 'Limit of sin(x)/x as x→0 is 1', 'answer': true},
      ];
    } else {
      return [
        {'statement': 'DNA transcription produces RNA', 'answer': true},
        {'statement': 'Base pairing is A=G, T=C', 'answer': false},
        {'statement': 'ATP stands for Adenosine Triphosphate', 'answer': true},
        {'statement': 'Photosynthesis is CO₂ + H₂O → Glucose', 'answer': true},
        {'statement': 'Mitosis and Meiosis are the same', 'answer': false},
      ];
    }
  }

  void _selectAnswer(bool answer) {
    if (_showResult) return;
    
    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
      
      if (answer == _questions[_currentQuestion]['answer']) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedAnswer = null;
        _showResult = false;
      });
    } else {
      _showFinalScore();
    }
  }

  void _showFinalScore() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('🎯 Quiz Complete!'),
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
                _selectedAnswer = null;
                _showResult = false;
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
    final isCorrect = _selectedAnswer == question['answer'];
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.pink.shade50, Colors.red.shade50],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatCard('Score', '$_score', Colors.green),
                _buildStatCard('Question', '${_currentQuestion + 1}/${_questions.length}', Colors.pink),
              ],
            ),
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
                      child: Text(
                        question['statement'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildAnswerButton(
                        true,
                        _selectedAnswer == true,
                        isCorrect != null && _selectedAnswer == true && isCorrect,
                        isCorrect != null && _selectedAnswer == true && !isCorrect,
                      ),
                      _buildAnswerButton(
                        false,
                        _selectedAnswer == false,
                        isCorrect != null && _selectedAnswer == false && isCorrect,
                        isCorrect != null && _selectedAnswer == false && !isCorrect,
                      ),
                    ],
                  ),
                  if (_showResult) ...[
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isCorrect ? Colors.green.shade100 : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isCorrect ? Icons.check_circle : Icons.cancel,
                            color: isCorrect ? Colors.green : Colors.red,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            isCorrect ? 'Correct!' : 'Wrong!',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                      ),
                      child: Text(
                        _currentQuestion < _questions.length - 1
                            ? 'Next Question'
                            : 'View Results',
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerButton(bool isTrue, bool isSelected, bool isCorrect, bool isWrong) {
    Color color;
    Color bgColor;
    if (isCorrect) {
      color = Colors.green;
      bgColor = Colors.green.shade100;
    } else if (isWrong) {
      color = Colors.red;
      bgColor = Colors.red.shade100;
    } else if (isSelected) {
      color = Colors.blue;
      bgColor = Colors.blue.shade100;
    } else {
      color = Colors.grey;
      bgColor = Colors.grey.shade100;
    }
    
    return InkWell(
      onTap: () => _selectAnswer(isTrue),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color,
            width: 3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isTrue ? Icons.check_circle : Icons.cancel,
              color: color,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              isTrue ? 'TRUE' : 'FALSE',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _getShadeColor(color, 700),
              ),
            ),
          ],
        ),
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
    if (color == Colors.pink) return Colors.pink[shade]!;
    return color;
  }
}

