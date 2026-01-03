import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../services/subscription_service.dart';
import 'mcq_questions_screen.dart';
import 'subscription_screen.dart';

class MCQSetsScreen extends StatefulWidget {
  final Chapter chapter;

  const MCQSetsScreen({
    super.key,
    required this.chapter,
  });

  @override
  State<MCQSetsScreen> createState() => _MCQSetsScreenState();
}

class _MCQSetsScreenState extends State<MCQSetsScreen> {
  bool _isSubscribed = false;
  int _completedSetsCount = 0;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionStatus();
  }

  Future<void> _loadSubscriptionStatus() async {
    final subscribed = await SubscriptionService.isSubscribed();
    final completedCount = await SubscriptionService.getCompletedSetsCount();
    setState(() {
      _isSubscribed = subscribed;
      _completedSetsCount = completedCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: SubscriptionService.isSubscribed(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _isSubscribed = snapshot.data ?? false;
        }
        return _buildContent();
      },
    );
  }

  Widget _buildContent() {
    return Scaffold(
      appBar: AppBar(
        title: Text('MCQ Sets - ${widget.chapter.name}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
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
                  const Icon(
                    Icons.quiz,
                    color: Colors.white,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Multiple Choice Questions',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.chapter.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<bool>(
                    future: SubscriptionService.isSubscribed(),
                    builder: (context, snapshot) {
                      final isSubscribed = snapshot.data ?? false;
                      if (isSubscribed) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatChip(Icons.library_books, '15 Sets', Colors.white),
                            _buildStatChip(Icons.quiz, '150 Questions', Colors.white),
                            _buildStatChip(Icons.access_time, '10 Min/Set', Colors.white),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildStatChip(Icons.library_books, '2 Free Sets', Colors.white),
                                _buildStatChip(Icons.quiz, '20 Questions', Colors.white),
                                _buildStatChip(Icons.lock, '13 Locked', Colors.white),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
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
                                    'Subscribe to unlock all 15 sets',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Select a Set',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // Sets List
            ...List.generate(15, (index) {
              return FutureBuilder<bool>(
                future: SubscriptionService.isSetLocked(widget.chapter.id, index + 1),
                builder: (context, snapshot) {
                  final isLocked = snapshot.data ?? false;
                  return _buildSetCard(context, index + 1, isLocked);
                },
              );
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatChip(IconData icon, String text, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSetCard(BuildContext context, int setNumber, bool isLocked) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLocked
                ? () async {
                    // Show subscription screen
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SubscriptionScreen(
                          onSubscribe: () {
                            _loadSubscriptionStatus();
                            setState(() {}); // Refresh UI
                          },
                        ),
                      ),
                    );
                    // Refresh after returning from subscription screen
                    _loadSubscriptionStatus();
                    setState(() {});
                  }
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MCQQuestionsScreen(
                          chapter: widget.chapter,
                          setNumber: setNumber,
                        ),
                      ),
                    ).then((_) {
                      // Reload status after completing a set
                      _loadSubscriptionStatus();
                    });
                  },
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.green.shade50,
                    Colors.green.shade100.withOpacity(0.3),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.green.shade300,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: isLocked
                            ? [Colors.grey.shade400, Colors.grey.shade600]
                            : [Colors.green.shade400, Colors.green.shade600],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (isLocked ? Colors.grey : Colors.green).withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: isLocked
                          ? const Icon(
                              Icons.lock,
                              color: Colors.white,
                              size: 28,
                            )
                          : Text(
                              '$setNumber',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Set',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isLocked ? 'Locked' : '10 Questions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isLocked ? Colors.grey : Colors.green,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.quiz, size: 14, color: Colors.grey[600]),
                            const SizedBox(width: 4),
                            Text(
                              'MCQ Practice',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (isLocked ? Colors.grey : Colors.green).withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isLocked ? Icons.lock : Icons.arrow_forward_ios,
                      color: isLocked ? Colors.grey : Colors.green,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
