import 'dart:math';
import 'package:flutter/material.dart';
import '../models/subject.dart';

class QuizGameScreen extends StatefulWidget {
  final Subject subject;

  const QuizGameScreen({super.key, required this.subject});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  int _currentQuestion = 0;
  int _score = 0;
  int? _selectedAnswer;
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
        {
          'question': 'What is the SI unit of electric charge?',
          'options': ['Coulomb', 'Ampere', 'Volt', 'Ohm'],
          'correct': 0,
        },
        {
          'question': 'According to Ohm\'s Law, V equals?',
          'options': ['I/R', 'IR', 'I²R', 'R/I'],
          'correct': 1,
        },
        {
          'question': 'What does F = k(q₁q₂)/r² represent?',
          'options': ['Ohm\'s Law', 'Coulomb\'s Law', 'Faraday\'s Law', 'Gauss\'s Law'],
          'correct': 1,
        },
        {
          'question': 'Electric field is measured in?',
          'options': ['N/C', 'V/m', 'Both A and B', 'J/C'],
          'correct': 2,
        },
        {
          'question': 'Magnetic field lines form?',
          'options': ['Closed loops', 'Open curves', 'Straight lines', 'Parabolas'],
          'correct': 0,
        },
      ];
    } else if (subjectId == 'chemistry') {
      return [
        {
          'question': 'What is the formula for molarity?',
          'options': ['n/V', 'V/n', 'n×V', 'V-n'],
          'correct': 0,
        },
        {
          'question': 'pH of a solution with [H⁺] = 10⁻³ M is?',
          'options': ['3', '7', '10', '13'],
          'correct': 0,
        },
        {
          'question': 'Rate law is given by?',
          'options': ['Rate = k[A]', 'Rate = k[A]ᵐ[B]ⁿ', 'Rate = [A]/t', 'Rate = k/[A]'],
          'correct': 1,
        },
        {
          'question': 'Gibbs free energy equation is?',
          'options': ['ΔG = ΔH + TΔS', 'ΔG = ΔH - TΔS', 'ΔG = ΔH × TΔS', 'ΔG = ΔH/TΔS'],
          'correct': 1,
        },
        {
          'question': 'Nernst equation relates?',
          'options': ['Concentration and potential', 'Temperature and pressure', 'Volume and moles', 'Energy and time'],
          'correct': 0,
        },
      ];
    } else if (subjectId == 'mathematics') {
      return [
        {
          'question': 'Derivative of x² is?',
          'options': ['x', '2x', 'x²', '2x²'],
          'correct': 1,
        },
        {
          'question': '∫x dx equals?',
          'options': ['x²', 'x²/2', 'x²/2 + C', '2x + C'],
          'correct': 2,
        },
        {
          'question': 'Pythagorean theorem states?',
          'options': ['a² + b² = c²', 'a + b = c', 'a² = b² + c²', 'a = b + c'],
          'correct': 0,
        },
        {
          'question': 'Chain rule for derivative is?',
          'options': ['d/dx[f(g(x))] = f\'(g(x))', 'd/dx[f(g(x))] = f\'(g(x))g\'(x)', 'd/dx[f(g(x))] = g\'(x)', 'd/dx[f(g(x))] = f(x)g(x)'],
          'correct': 1,
        },
        {
          'question': 'Limit of sin(x)/x as x→0 is?',
          'options': ['0', '1', '∞', 'Undefined'],
          'correct': 1,
        },
      ];
    } else {
      return [
        {
          'question': 'DNA transcription produces?',
          'options': ['Protein', 'RNA', 'DNA', 'ATP'],
          'correct': 1,
        },
        {
          'question': 'Base pairing rule is?',
          'options': ['A=G, T=C', 'A=T, G=C', 'A=C, G=T', 'A=A, T=T'],
          'correct': 1,
        },
        {
          'question': 'ATP stands for?',
          'options': ['Adenosine Triphosphate', 'Adenosine Diphosphate', 'Adenosine Monophosphate', 'Adenine Triphosphate'],
          'correct': 0,
        },
        {
          'question': 'Photosynthesis equation is?',
          'options': ['CO₂ + H₂O → Glucose', 'Glucose → CO₂ + H₂O', 'O₂ + H₂O → CO₂', 'CO₂ → O₂'],
          'correct': 0,
        },
        {
          'question': 'Cell division process is called?',
          'options': ['Meiosis', 'Mitosis', 'Both', 'None'],
          'correct': 2,
        },
      ];
    }
  }

  void _selectAnswer(int index) {
    if (_showResult) return;
    
    setState(() {
      _selectedAnswer = index;
      _showResult = true;
      
      if (index == _questions[_currentQuestion]['correct']) {
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
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.green.shade50, Colors.blue.shade50],
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
                _buildStatCard('Question', '${_currentQuestion + 1}/${_questions.length}', Colors.blue),
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
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        question['question'],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(4, (index) {
                    final isCorrect = index == question['correct'];
                    final isSelected = _selectedAnswer == index;
                    
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _selectAnswer(index),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: _showResult
                                ? (isCorrect
                                    ? Colors.green.shade100
                                    : isSelected
                                        ? Colors.red.shade100
                                        : Colors.grey[100])
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _showResult
                                  ? (isCorrect
                                      ? Colors.green
                                      : isSelected
                                          ? Colors.red
                                          : Colors.grey[300]!)
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _showResult
                                      ? (isCorrect
                                          ? Colors.green
                                          : isSelected
                                              ? Colors.red
                                              : Colors.grey[300])
                                      : Colors.blue.shade100,
                                ),
                                child: Center(
                                  child: Text(
                                    String.fromCharCode(65 + index),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: _showResult && isCorrect
                                          ? Colors.white
                                          : Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  question['options'][index],
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              if (_showResult && isCorrect)
                                const Icon(Icons.check_circle, color: Colors.green),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  if (_showResult)
                    Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: ElevatedButton(
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
    if (color == Colors.blue) return Colors.blue[shade]!;
    return color;
  }
}

