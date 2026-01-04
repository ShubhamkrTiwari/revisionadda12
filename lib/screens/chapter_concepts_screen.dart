import 'package:flutter/material.dart';
import '../models/chapter_concept.dart';
import '../models/subject.dart';
import '../services/concept_service.dart';
import '../services/data_service.dart';
import '../services/roadmap_service.dart';
import 'chapter_resources_screen.dart';

class ChapterConceptsScreen extends StatefulWidget {
  final String subjectId;
  final String chapterId;

  const ChapterConceptsScreen({
    super.key,
    required this.subjectId,
    required this.chapterId,
  });

  @override
  State<ChapterConceptsScreen> createState() => _ChapterConceptsScreenState();
}

class _ChapterConceptsScreenState extends State<ChapterConceptsScreen> {
  List<ChapterConcept> _concepts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadConcepts();
  }

  void _loadConcepts() {
    setState(() {
      _isLoading = true;
    });

    final concepts = ConceptService.getConceptsForChapter(
      widget.subjectId,
      widget.chapterId,
    );

    setState(() {
      _concepts = concepts;
      _isLoading = false;
    });
  }

  Color _hexToColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }

  @override
  Widget build(BuildContext context) {
    final chapter = DataService.getChapterById(widget.subjectId, widget.chapterId);
    final subject = DataService.getSubjectById(widget.subjectId);

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
              // Header
              _buildHeader(chapter, subject),
              
              // View Full Chapter Resources Button
              if (chapter != null)
                Builder(
                  builder: (context) {
                    int chapterIndex = 0;
                    if (subject != null) {
                      final index = subject.chapters.indexWhere((ch) => ch.id == widget.chapterId);
                      chapterIndex = index >= 0 ? index : 0;
                    }
                    final avengerColor = RoadmapService.getChapterAvenger(chapterIndex)['color'] ?? '#7B68EE';
                    
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChapterResourcesScreen(
                                chapter: chapter,
                                resourceType: 'All',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.library_books),
                        label: const Text('View All Chapter Resources'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _hexToColor(avengerColor),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              
              // Concepts Grid
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : _concepts.isEmpty
                        ? const Center(
                            child: Text(
                              'No concepts available',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(20),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.85,
                            ),
                            itemCount: _concepts.length,
                            itemBuilder: (context, index) {
                              return _buildConceptCard(_concepts[index]);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(chapter, subject) {
    int chapterIndex = 0;
    if (subject != null && chapter != null) {
      final index = subject.chapters.indexWhere((ch) => ch.id == widget.chapterId);
      chapterIndex = index >= 0 ? index : 0;
    }
    
    final avenger = RoadmapService.getChapterAvenger(chapterIndex);
    final avengerName = avenger['name'] ?? 'Avenger';
    final avengerColor = avenger['color'] ?? '#7B68EE';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            _hexToColor(avengerColor),
            _hexToColor(avengerColor).withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: _hexToColor(avengerColor).withOpacity(0.5),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
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
                      avengerName ?? 'Avenger',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                    if (chapter != null)
                      Text(
                        chapter.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (chapter != null && chapter.description.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              chapter.description,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 13,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConceptCard(ChapterConcept concept) {
    final color = _hexToColor(concept.avengerColor);
    final icon = _getConceptIcon(concept.conceptType);

    return GestureDetector(
      onTap: () {
        _showConceptDetail(concept);
      },
      child: Container(
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
            color: color.withOpacity(0.6),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avenger Avatar
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                shape: BoxShape.circle,
                border: Border.all(
                  color: color,
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.5),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  concept.avengerIcon,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Concept Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                concept.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Avenger Name
            Text(
              concept.avengerName,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 8),
            // Type Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: color.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 12, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    concept.conceptType.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getConceptIcon(String type) {
    switch (type.toLowerCase()) {
      case 'formula':
        return Icons.functions;
      case 'theory':
        return Icons.menu_book;
      case 'diagram':
        return Icons.image;
      case 'example':
        return Icons.quiz;
      default:
        return Icons.lightbulb;
    }
  }

  void _showConceptDetail(ChapterConcept concept) {
    final color = _hexToColor(concept.avengerColor);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF1a1a2e),
              Colors.black,
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          children: [
            // Handle
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 3),
                    ),
                    child: Center(
                      child: Text(
                        concept.avengerIcon,
                        style: const TextStyle(fontSize: 35),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          concept.avengerName,
                          style: TextStyle(
                            color: color,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          concept.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Description
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: color.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        concept.description,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),
                    ),
                    // Key Points
                    if (concept.keyPoints != null && concept.keyPoints!.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Key Points',
                        style: TextStyle(
                          color: color,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...concept.keyPoints!.map((point) => Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: color,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    point,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                    // Formula
                    if (concept.formula != null) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Formula',
                        style: TextStyle(
                          color: color,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          concept.formula!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

