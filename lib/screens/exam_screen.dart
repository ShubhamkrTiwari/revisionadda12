import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../services/data_service.dart';
import 'paper_viewer_screen.dart';
import 'previous_year_papers_screen.dart';
import 'roadmap_navigation_screen.dart';

class ExamScreen extends StatelessWidget {
  const ExamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final subjects = DataService.getSubjects();
    // For simplicity, we'll navigate to the first subject's papers.
    // A better implementation might show a combined list or a different UI.
    final defaultSubject = subjects.isNotEmpty ? subjects.first : null;

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Container(
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                children: [
                  _buildFeatureCard(
                    context: context,
                    title: 'AVENGERS ROADMAP',
                    subtitle: 'Complete your learning journey',
                    emoji: '🦸',
                    gradientColors: [const Color(0xFFC41E3A), const Color(0xFFED1C24)],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoadmapNavigationScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    context: context,
                    title: '90% IMPORTANT QS',
                    subtitle: 'High-yield questions for success',
                    emoji: '🎯',
                    gradientColors: [const Color(0xFF3B82F6), const Color(0xFF2563EB)],
                    onTap: () {
                      if (defaultSubject != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PaperViewerScreen(
                              subject: defaultSubject,
                              paperType: '90match',
                              subjectName: defaultSubject.name,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  _buildFeatureCard(
                    context: context,
                    title: 'PREVIOUS YEAR QS',
                    subtitle: 'Practice with past exam papers',
                    emoji: '📜',
                    gradientColors: [const Color(0xFFF59E0B), const Color(0xFFD97706)],
                    onTap: () {
                      if (defaultSubject != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PreviousYearPapersScreen(
                              subject: defaultSubject,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withOpacity(0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.assignment,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exam Corner',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontSize: 22,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Your resources for exam preparation',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: 13,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String emoji,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradientColors,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: gradientColors[0].withOpacity(0.4),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  emoji,
                  style: const TextStyle(fontSize: 28),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
