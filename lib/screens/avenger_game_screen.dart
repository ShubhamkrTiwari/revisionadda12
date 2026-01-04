import 'package:flutter/material.dart';
import '../models/avenger_game.dart';
import '../models/game_level.dart';
import '../services/avenger_game_service.dart';

class AvengerGameScreen extends StatefulWidget {
  final String subjectId;
  final String chapterId;

  const AvengerGameScreen({
    super.key,
    required this.subjectId,
    required this.chapterId,
  });

  @override
  State<AvengerGameScreen> createState() => _AvengerGameScreenState();
}

class _AvengerGameScreenState extends State<AvengerGameScreen> {
  AvengerGame? _game;
  int _currentLevelIndex = -1; // Start with -1 to show level selection
  int _currentQuestionIndex = 0;
  int? _selectedAnswer;
  bool _showExplanation = false;
  int _totalScore = 0;
  int _levelScore = 0;
  bool _levelCompleted = false;
  bool _gameCompleted = false;
  Map<int, bool> _completedLevels = {}; // Track completed levels
  Map<int, bool> _unlockedLevels = {0: true}; // Track unlocked levels (Level 1 is unlocked by default)

  @override
  void initState() {
    super.initState();
    _loadGame();
  }

  void _loadGame() {
    final game = AvengerGameService.generateGameForChapter(
      widget.subjectId,
      widget.chapterId,
    );
    setState(() {
      _game = game;
    });
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }

  void _selectAnswer(int index) {
    if (_showExplanation) return;
    
    setState(() {
      _selectedAnswer = index;
    });
  }

  void _submitAnswer() {
    if (_selectedAnswer == null || _game == null) return;

    final currentLevel = _game!.levels[_currentLevelIndex];
    final question = currentLevel.questions[_currentQuestionIndex];
    final isCorrect = _selectedAnswer == question.correctAnswer;

    setState(() {
      _showExplanation = true;
      if (isCorrect) {
        _levelScore++;
        _totalScore++;
      }
    });
  }

  void _nextQuestion() {
    if (_game == null) return;

    final currentLevel = _game!.levels[_currentLevelIndex];
    
    if (_currentQuestionIndex < currentLevel.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswer = null;
        _showExplanation = false;
      });
    } else {
      // Level completed - all questions answered
      setState(() {
        _levelCompleted = true;
        _completedLevels[_currentLevelIndex] = true;
        // Unlock next level if exists
        if (_currentLevelIndex < _game!.levels.length - 1) {
          final nextLevelIndex = _currentLevelIndex + 1;
          _unlockedLevels[nextLevelIndex] = true; // Mark next level as unlocked
          final nextLevel = _game!.levels[nextLevelIndex];
          _game!.levels[nextLevelIndex] = GameLevel(
            levelNumber: nextLevel.levelNumber,
            levelName: nextLevel.levelName,
            avengerName: nextLevel.avengerName,
            avengerIcon: nextLevel.avengerIcon,
            avengerColor: nextLevel.avengerColor,
            questions: nextLevel.questions,
            isUnlocked: true, // Unlock next level
            isCompleted: false,
          );
        }
      });
    }
  }

  void _nextLevel() {
    if (_game == null) return;

    if (_currentLevelIndex < _game!.levels.length - 1) {
      final nextLevelIndex = _currentLevelIndex + 1;
      
      // Ensure next level is unlocked
      _unlockedLevels[nextLevelIndex] = true;
      
      // Update the next level in game to be unlocked
      final nextLevel = _game!.levels[nextLevelIndex];
      _game!.levels[nextLevelIndex] = GameLevel(
        levelNumber: nextLevel.levelNumber,
        levelName: nextLevel.levelName,
        avengerName: nextLevel.avengerName,
        avengerIcon: nextLevel.avengerIcon,
        avengerColor: nextLevel.avengerColor,
        questions: nextLevel.questions,
        isUnlocked: true,
        isCompleted: false,
      );
      
      setState(() {
        _currentLevelIndex = nextLevelIndex;
        _currentQuestionIndex = 0;
        _selectedAnswer = null;
        _showExplanation = false;
        _levelCompleted = false;
        _levelScore = 0;
      });
    } else {
      setState(() {
        _gameCompleted = true;
      });
    }
  }

  void _selectLevel(int levelIndex) {
    if (_game == null) return;
    final level = _game!.levels[levelIndex];
    
    if (level.isUnlocked) {
      setState(() {
        _currentLevelIndex = levelIndex;
        _currentQuestionIndex = 0;
        _selectedAnswer = null;
        _showExplanation = false;
        _levelCompleted = false;
        _levelScore = 0;
      });
    }
  }

  void _restartGame() {
    setState(() {
      _currentLevelIndex = -1; // Show level selection
      _currentQuestionIndex = 0;
      _selectedAnswer = null;
      _showExplanation = false;
      _totalScore = 0;
      _levelScore = 0;
      _levelCompleted = false;
      _gameCompleted = false;
      _completedLevels.clear();
      _unlockedLevels = {0: true}; // Reset to only level 1 unlocked
    });
    _loadGame();
  }

  @override
  Widget build(BuildContext context) {
    if (_game == null || _game!.levels.isEmpty) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    // Show level selection screen if no level is active
    if (_currentLevelIndex < 0 || _currentLevelIndex >= _game!.levels.length) {
      return _buildLevelSelectionScreen();
    }

    if (_gameCompleted) {
      return _buildGameCompleteScreen();
    }

    final currentLevel = _game!.levels[_currentLevelIndex];
    if (_currentQuestionIndex >= currentLevel.questions.length) {
      return _buildLevelCompleteScreen();
    }

    final question = currentLevel.questions[_currentQuestionIndex];
    final color = _hexToColor(question.avengerColor);
    final mainColor = _hexToColor(currentLevel.avengerColor);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(mainColor),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      // Progress Bar
                      _buildProgressBar(),
                      const SizedBox(height: 24),
                      
                      // Avenger Character
                      _buildAvengerCharacter(question, color),
                      const SizedBox(height: 24),
                      
                      // Question
                      _buildQuestionCard(question, color),
                      const SizedBox(height: 20),
                      
                      // Options
                      _buildOptions(question, color),
                      
                      // Explanation
                      if (_showExplanation)
                        _buildExplanation(question, color),
                      
                      const SizedBox(height: 20),
                      
                      // Action Button
                      if (!_showExplanation)
                        _buildSubmitButton(color)
                      else
                        _buildNextButton(color),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _game!.mainAvengerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  '${_game!.chapterName} Challenge',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Total: $_totalScore',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    if (_game == null) return const SizedBox();
    final currentLevel = _game!.levels[_currentLevelIndex];
    final progress = (_currentQuestionIndex + 1) / currentLevel.questions.length;
    
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Level ${currentLevel.levelNumber}: Question ${_currentQuestionIndex + 1}/${currentLevel.questions.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation<Color>(
              _hexToColor(currentLevel.avengerColor),
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget _buildAvengerCharacter(AvengerGameQuestion question, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color,
          width: 3,
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              shape: BoxShape.circle,
              border: Border.all(
                color: color,
                width: 3,
              ),
            ),
            child: Center(
              child: Text(
                question.avengerIcon,
                style: const TextStyle(fontSize: 50),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            question.avengerName,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'asks you:',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(AvengerGameQuestion question, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Text(
        question.question,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOptions(AvengerGameQuestion question, Color color) {
    return Column(
      children: question.options.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        final isSelected = _selectedAnswer == index;
        final isCorrect = index == question.correctAnswer;
        final showResult = _showExplanation;

        Color optionColor = color;
        if (showResult) {
          if (isCorrect) {
            optionColor = Colors.green;
          } else if (isSelected && !isCorrect) {
            optionColor = Colors.red;
          } else {
            optionColor = Colors.grey;
          }
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _selectAnswer(index),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? optionColor.withOpacity(0.3)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? optionColor
                        : Colors.white.withOpacity(0.2),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: optionColor.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: optionColor,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          String.fromCharCode(65 + index), // A, B, C, D
                          style: TextStyle(
                            color: optionColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        option,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                    if (showResult && isCorrect)
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 24,
                      )
                    else if (showResult && isSelected && !isCorrect)
                      Icon(
                        Icons.cancel,
                        color: Colors.red,
                        size: 24,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExplanation(AvengerGameQuestion question, Color color) {
    final isCorrect = _selectedAnswer == question.correctAnswer;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: (isCorrect ? Colors.green : Colors.orange).withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: (isCorrect ? Colors.green : Colors.orange).withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCorrect ? Icons.check_circle : Icons.info,
                color: isCorrect ? Colors.green : Colors.orange,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                isCorrect ? 'Correct!' : 'Not quite right',
                style: TextStyle(
                  color: isCorrect ? Colors.green : Colors.orange,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            question.explanation,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton(Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _selectedAnswer != null ? _submitAnswer : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Submit Answer',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(Color color) {
    if (_game == null) return const SizedBox();
    final currentLevel = _game!.levels[_currentLevelIndex];
    
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _nextQuestion,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Builder(
          builder: (context) {
            if (_game == null) return const Text('Next');
            final currentLevel = _game!.levels[_currentLevelIndex];
            return Text(
              _currentQuestionIndex < currentLevel.questions.length - 1
                  ? 'Next Question'
                  : 'Complete Level',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildGameCompleteScreen() {
    final mainColor = _hexToColor(_game!.mainAvengerColor);
    final totalQuestions = _game!.levels.fold<int>(0, (sum, level) => sum + level.questions.length);
    final percentage = totalQuestions > 0 ? (_totalScore / totalQuestions * 100).toInt() : 0;
    final completedLevelsCount = _completedLevels.length;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _game!.mainAvengerIcon,
                      style: const TextStyle(fontSize: 80),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Game Complete!',
                      style: TextStyle(
                        color: mainColor,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: mainColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: mainColor,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Your Score',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$_totalScore / $totalQuestions',
                            style: TextStyle(
                              color: mainColor,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Levels Completed: $completedLevelsCount / ${_game!.levels.length}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$percentage%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _restartGame,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Play Again'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.home),
                            label: const Text('Home'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(0.1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLevelSelectionScreen() {
    final mainColor = _hexToColor(_game!.mainAvengerColor);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildLevelSelectionHeader(mainColor),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: _game!.levels.length,
                  itemBuilder: (context, index) {
                    return _buildLevelCard(_game!.levels[index], index, mainColor);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelSelectionHeader(Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color,
            color.withOpacity(0.8),
          ],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _game!.mainAvengerName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Select Level',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(GameLevel level, int index, Color mainColor) {
    final color = _hexToColor(level.avengerColor);
    // Level is unlocked if:
    // 1. It's the first level (index 0)
    // 2. Previous level is completed
    // 3. Level is marked as unlocked in the game
    // 4. Level is in unlocked levels map
    final isUnlocked = _unlockedLevels.containsKey(index) || 
                       level.isUnlocked || 
                       index == 0 || 
                       _completedLevels.containsKey(index - 1);
    
    return GestureDetector(
      onTap: isUnlocked ? () => _selectLevel(index) : null,
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked
              ? color.withOpacity(0.3)
              : Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isUnlocked ? color : Colors.grey,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!isUnlocked)
              const Icon(Icons.lock, color: Colors.grey, size: 30)
            else
              Text(
                level.avengerIcon,
                style: const TextStyle(fontSize: 32),
              ),
            const SizedBox(height: 8),
            Text(
              'Level ${level.levelNumber}',
              style: TextStyle(
                color: isUnlocked ? Colors.white : Colors.grey,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (isUnlocked && _completedLevels.containsKey(index))
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelCompleteScreen() {
    final currentLevel = _game!.levels[_currentLevelIndex];
    final color = _hexToColor(currentLevel.avengerColor);
    final percentage = (_levelScore / currentLevel.questions.length * 100).toInt();
    final isLastLevel = _currentLevelIndex == _game!.levels.length - 1;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              const Color(0xFF1a1a2e),
              const Color(0xFF16213e),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      currentLevel.avengerIcon,
                      style: const TextStyle(fontSize: 80),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Level ${currentLevel.levelNumber} Complete!',
                      style: TextStyle(
                        color: color,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: color,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Level Score',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$_levelScore / ${currentLevel.questions.length}',
                            style: TextStyle(
                              color: color,
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$percentage%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (!isLastLevel)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: _nextLevel,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Next Level'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _gameCompleted = true;
                            });
                          },
                          icon: const Icon(Icons.emoji_events),
                          label: const Text('View Final Results'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _currentLevelIndex = -1;
                        });
                      },
                      child: const Text(
                        'Back to Levels',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

