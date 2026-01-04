import 'package:flutter/material.dart';
import '../services/data_service.dart';
import '../services/roadmap_service.dart';
import '../services/ai_content_service.dart';
import 'avenger_game_screen.dart';

class ChapterVisualContentScreen extends StatefulWidget {
  final String subjectId;
  final String chapterId;

  const ChapterVisualContentScreen({
    super.key,
    required this.subjectId,
    required this.chapterId,
  });

  @override
  State<ChapterVisualContentScreen> createState() => _ChapterVisualContentScreenState();
}

class _ChapterVisualContentScreenState extends State<ChapterVisualContentScreen> {
  Map<String, dynamic>? _aiContent;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  void _loadContent() {
    final content = AIContentService.generateChapterContent(
      widget.subjectId,
      widget.chapterId,
    );
    setState(() {
      _aiContent = content;
    });
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    final chapter = DataService.getChapterById(widget.subjectId, widget.chapterId);
    final subject = DataService.getSubjectById(widget.subjectId);

    if (chapter == null || subject == null || _aiContent == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

    final chapterIndex = subject.chapters.indexWhere((ch) => ch.id == widget.chapterId);
    final avenger = RoadmapService.getChapterAvenger(chapterIndex >= 0 ? chapterIndex : 0);
    final color = _hexToColor(avenger['color']!);

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
              _buildHeader(chapter, avenger, color),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        // Avengers Game Button
                        _buildGameButton(color),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameButton(Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.4),
            color.withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '🦸',
                style: const TextStyle(fontSize: 40),
              ),
              const SizedBox(width: 12),
              Text(
                '🎮',
                style: const TextStyle(fontSize: 40),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Play Avengers Game!',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Test your knowledge with Avengers characters',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AvengerGameScreen(
                      subjectId: widget.subjectId,
                      chapterId: widget.chapterId,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.play_arrow, size: 28),
              label: const Text(
                'Start Game',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(chapter, avenger, Color color) {
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
                  avenger['name']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  chapter.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Text(
            avenger['icon']!,
            style: const TextStyle(fontSize: 40),
          ),
        ],
      ),
    );
  }
}
