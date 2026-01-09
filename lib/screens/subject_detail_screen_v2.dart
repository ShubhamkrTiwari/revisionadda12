import 'package:flutter/material.dart';
import '../models/subject.dart';
import '../utils/icon_helper.dart';
import 'chapter_resources_screen.dart';
import 'paper_viewer_screen.dart';
import 'previous_year_papers_screen.dart';
import 'roadmap_screen.dart';

class SubjectDetailScreenV2 extends StatefulWidget {
  final Subject subject;

  const SubjectDetailScreenV2({
    super.key,
    required this.subject,
  });

  @override
  State<SubjectDetailScreenV2> createState() => _SubjectDetailScreenV2State();
}

class _SubjectDetailScreenV2State extends State<SubjectDetailScreenV2> {
  final Map<String, bool> _expandedChapters = {};

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final subjectColor = _getSubjectColor(widget.subject.id);
    
    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1F1F1F) : Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                subjectColor,
                subjectColor.withOpacity(0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: subjectColor.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
        ),
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.subject.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            Row(
              children: [
                Icon(Icons.menu_book, size: 14, color: Colors.white.withOpacity(0.9)),
                const SizedBox(width: 4),
                Text(
                  '${widget.subject.chapters.length} Chapters',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.map, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoadmapScreen(
                      subjectId: widget.subject.id,
                    ),
                  ),
                );
              },
              tooltip: 'View ${widget.subject.name} Roadmap',
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    subjectColor.withOpacity(0.1),
                    const Color(0xFF1F1F1F),
                  ]
                : [
                    subjectColor.withOpacity(0.05),
                    Colors.grey[50]!,
                  ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Chapters Section
            if (widget.subject.chapters.isNotEmpty) ...[
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: subjectColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.library_books,
                      color: subjectColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Chapters',
                    style: TextStyle(
                      color: isDark ? Colors.white : Colors.grey[900],
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Chapters List
              ...widget.subject.chapters.asMap().entries.map((entry) {
                final index = entry.key;
                final chapter = entry.value;
                final isExpanded = _expandedChapters[chapter.id] ?? false;
                return _buildChapterCard(chapter, index + 1, isExpanded);
              }),
            ] else ...[
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inbox,
                        size: 64,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No chapters available yet',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
        ],
        ),
      ),
    );
  }

  Widget _buildChapterCard(Chapter chapter, int chapterNumber, bool isExpanded) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Card(
        color: const Color(0xFF2D2D2D),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
        children: [
          // Chapter Header
          InkWell(
            onTap: () {
              setState(() {
                _expandedChapters[chapter.id] = !isExpanded;
              });
            },
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Chapter Number Badge
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        '$chapterNumber',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Chapter Title
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          chapter.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _buildBadge('70 MCQs', Colors.blue),
                            const SizedBox(width: 8),
                            _buildBadge('5 PYQs', Colors.blue),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Expand/Collapse Button
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF3B82F6).withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Icon(
                      isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Chapter Resources (Expanded Content)
          if (isExpanded)
            Container(
              color: const Color(0xFF252525),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Chapter Resources',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  _buildResourceItem(
                    icon: Icons.library_books,
                    title: 'Revision',
                    subtitle: 'Key Points & Mind Maps',
                    color: Colors.red,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChapterResourcesScreen(
                            chapter: chapter,
                            resourceType: 'Revision',
                          ),
                        ),
                      );
                    },
                  ),
                  _buildResourceItem(
                    icon: Icons.straighten,
                    title: 'Formula',
                    subtitle: 'Quick Reference',
                    color: Colors.orange,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChapterResourcesScreen(
                            chapter: chapter,
                            resourceType: 'Formula',
                          ),
                        ),
                      );
                    },
                  ),
                  _buildResourceItem(
                    icon: Icons.book,
                    title: 'NCERT',
                    subtitle: 'AI Generated',
                    color: Colors.purple,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChapterResourcesScreen(
                            chapter: chapter,
                            resourceType: 'NCERT',
                          ),
                        ),
                      );
                    },
                  ),
                  _buildResourceItem(
                    icon: Icons.quiz,
                    title: 'MCQ',
                    subtitle: '15 Sets • 150 Questions',
                    color: Colors.green,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChapterResourcesScreen(
                            chapter: chapter,
                            resourceType: 'MCQ',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
        ],
      ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildResourceItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF2D2D2D),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        color,
                        color.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: color,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.chevron_right,
                    color: color,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getSubjectColor(String subjectId) {
    switch (subjectId) {
      case 'physics':
        return const Color(0xFF6366F1); // Indigo
      case 'chemistry':
        return const Color(0xFF10B981); // Green
      case 'mathematics':
        return const Color(0xFF3B82F6); // Blue
      case 'biology':
        return const Color(0xFF14B8A6); // Teal
      default:
        return const Color(0xFF7B68EE); // Purple
    }
  }
}
