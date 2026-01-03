import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/subject.dart';
import '../services/subscription_service.dart';

class MCQQuestionsScreen extends StatefulWidget {
  final Chapter chapter;
  final int setNumber;

  const MCQQuestionsScreen({
    super.key,
    required this.chapter,
    required this.setNumber,
  });

  @override
  State<MCQQuestionsScreen> createState() => _MCQQuestionsScreenState();
}

class _MCQQuestionsScreenState extends State<MCQQuestionsScreen> {
  Timer? _timer;
  int _remainingSeconds = 60; // 1 minute timer
  bool _isTimeUp = false;
  int _currentQuestionIndex = 0;
  Map<int, int?> _selectedAnswers = {}; // questionIndex -> selectedOptionIndex

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        if (!_isTimeUp) {
          setState(() {
            _isTimeUp = true;
          });
          _playTimeUpSound();
          _showTimeUpDialog();
        }
      }
    });
  }

  void _playTimeUpSound() {
    HapticFeedback.heavyImpact();
    SystemSound.play(SystemSoundType.alert);
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.timer_off, color: Colors.red, size: 28),
            SizedBox(width: 8),
            Text('Time\'s Up!'),
          ],
        ),
        content: const Text(
          'Your 1 minute timer has ended. You can still review the questions and answers.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Continue'),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _selectOption(int optionIndex) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = optionIndex;
    });
    HapticFeedback.lightImpact();
  }

  void _goToNextQuestion() {
    if (_currentQuestionIndex < 9) {
      setState(() {
        _currentQuestionIndex++;
      });
    } else {
      // User has viewed all questions, mark as completed
      _markSetCompleted();
    }
  }

  Future<void> _markSetCompleted() async {
    // Mark as completed (for both free and subscribed users)
    // Check if already completed to avoid duplicate marking
    final isCompleted = await SubscriptionService.isSetCompleted(
      widget.chapter.id,
      widget.setNumber,
    );
    if (!isCompleted) {
      await SubscriptionService.markSetCompleted(
        widget.chapter.id,
        widget.setNumber,
      );
    }
  }

  void _goToPreviousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final questionNumber = _currentQuestionIndex + 1;
    final mcq = _getMCQForQuestion(questionNumber);
    final selectedOption = _selectedAnswers[_currentQuestionIndex];
    final correctOptionIndex = mcq['correct'] as int;
    final showAnswer = selectedOption != null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Set ${widget.setNumber} - ${widget.chapter.name}'),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _remainingSeconds <= 10
                  ? Colors.red
                  : _remainingSeconds <= 30
                      ? Colors.orange
                      : Colors.green,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: (_remainingSeconds <= 10
                          ? Colors.red
                          : _remainingSeconds <= 30
                              ? Colors.orange
                              : Colors.green)
                      .withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _isTimeUp ? Icons.timer_off : Icons.timer,
                  color: Colors.white,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  _isTimeUp ? '00:00' : _formatTime(_remainingSeconds),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: LinearProgressIndicator(
                    value: (questionNumber) / 10,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  'Question $questionNumber/10',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          // Question Card
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade600],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '$questionNumber',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Question $questionNumber',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Question Text
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.green.shade400,
                                      Colors.green.shade600
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'Q$questionNumber',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            mcq['question']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Options
                  const Text(
                    'Select an option:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...['A', 'B', 'C', 'D'].asMap().entries.map((optEntry) {
                    final optIndex = optEntry.key;
                    final optLabel = optEntry.value;
                    final isSelected = selectedOption == optIndex;
                    final isCorrect = optIndex == correctOptionIndex;
                    final showResult = showAnswer && isCorrect;
                    final isWrongSelection = showAnswer && isSelected && !isCorrect;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: InkWell(
                        onTap: () => _selectOption(optIndex),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: showResult
                                ? Colors.green.withOpacity(0.1)
                                : isWrongSelection
                                    ? Colors.red.withOpacity(0.1)
                                    : isSelected
                                        ? Colors.blue.withOpacity(0.1)
                                        : Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: showResult
                                  ? Colors.green
                                  : isWrongSelection
                                      ? Colors.red
                                      : isSelected
                                          ? Colors.blue
                                          : Colors.grey[300]!,
                              width: showResult || isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: showResult
                                      ? Colors.green
                                      : isWrongSelection
                                          ? Colors.red
                                          : isSelected
                                              ? Colors.blue
                                              : Colors.grey[300],
                                ),
                                child: Center(
                                  child: Text(
                                    optLabel,
                                    style: TextStyle(
                                      color: showResult || isSelected || isWrongSelection
                                          ? Colors.white
                                          : Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  mcq['options']![optIndex],
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: isSelected || showResult || isWrongSelection
                                        ? FontWeight.w600
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (showResult)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 28,
                                )
                              else if (isWrongSelection)
                                const Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                  size: 28,
                                )
                              else if (isSelected && !showAnswer)
                                const Icon(
                                  Icons.radio_button_checked,
                                  color: Colors.blue,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                  // Answer and Explanation (shown after selection)
                  if (showAnswer) ...[
                    const SizedBox(height: 24),
                    Builder(
                      builder: (context) {
                        final isAnswerCorrect = selectedOption == correctOptionIndex;
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isAnswerCorrect
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isAnswerCorrect ? Colors.green : Colors.red,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isAnswerCorrect ? Icons.check_circle : Icons.cancel,
                                color: isAnswerCorrect ? Colors.green : Colors.red,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  isAnswerCorrect
                                      ? 'Correct Answer!'
                                      : 'Incorrect Answer. Correct option is ${['A', 'B', 'C', 'D'][correctOptionIndex]}.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isAnswerCorrect ? Colors.green : Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.lightbulb_outline,
                                  color: Colors.blue, size: 24),
                              const SizedBox(width: 8),
                              Text(
                                'Explanation',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            mcq['explanation']!,
                            style: const TextStyle(
                              fontSize: 14,
                              height: 1.6,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
          // Navigation Buttons
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentQuestionIndex > 0
                        ? _goToPreviousQuestion
                        : null,
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Previous'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black87,
                      disabledBackgroundColor: Colors.grey[200],
                      disabledForegroundColor: Colors.grey[400],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _currentQuestionIndex < 9
                        ? _goToNextQuestion
                        : null,
                    icon: const Icon(Icons.arrow_forward),
                    label: Text(_currentQuestionIndex < 9 ? 'Next' : 'Finish'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      disabledBackgroundColor: Colors.grey[200],
                      disabledForegroundColor: Colors.grey[400],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _getMCQForQuestion(int questionNumber) {
    final chapterName = widget.chapter.name;
    final questionIndex = (widget.setNumber - 1) * 10 + questionNumber - 1;
    final concepts = _getChapterTopics();
    
    final optionA = concepts[(questionIndex * 2) % concepts.length];
    final optionB = concepts[(questionIndex * 3 + 1) % concepts.length];
    final optionC = concepts[(questionIndex * 4 + 2) % concepts.length];
    final optionD = concepts[(questionIndex * 5 + 3) % concepts.length];
    
    return {
      'question': 'Q$questionNumber: What is the main concept related to $chapterName in this question?',
      'options': [
        'Option A: $optionA',
        'Option B: $optionB',
        'Option C: $optionC',
        'Option D: $optionD',
      ],
      'correct': questionIndex % 4,
      'explanation': 'This question tests understanding of $chapterName. The correct answer demonstrates knowledge of key concepts and their applications in this chapter.',
    };
  }

  List<String> _getChapterTopics() {
    final subjectId = widget.chapter.subjectId;
    if (subjectId == 'physics') {
      return [
        'Electric field and potential',
        'Coulomb\'s law and its applications',
        'Gauss\'s law and electric flux',
        'Capacitance and dielectrics',
        'Current and resistance',
        'Ohm\'s law and circuits',
        'Magnetic field and forces',
        'Electromagnetic induction',
        'AC circuits and transformers',
        'Optics and wave phenomena',
      ];
    } else if (subjectId == 'chemistry') {
      return [
        'Chemical bonding and structure',
        'Reaction mechanisms',
        'Equilibrium and kinetics',
        'Thermodynamics',
        'Electrochemistry',
        'Organic reactions',
        'Coordination compounds',
        'Biomolecules',
        'Polymers and materials',
        'Environmental chemistry',
      ];
    } else if (subjectId == 'mathematics') {
      return [
        'Functions and relations',
        'Calculus and derivatives',
        'Integration techniques',
        'Differential equations',
        'Vector algebra',
        '3D geometry',
        'Probability and statistics',
        'Linear programming',
        'Matrices and determinants',
        'Trigonometric functions',
      ];
    } else {
      return [
        'Biological processes',
        'Cell structure and function',
        'Genetics and inheritance',
        'Evolution and ecology',
        'Human physiology',
        'Biotechnology',
        'Reproduction and development',
        'Health and disease',
        'Biodiversity',
        'Environmental biology',
      ];
    }
  }
}
