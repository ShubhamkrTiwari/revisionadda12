import '../models/chapter_concept.dart';
import '../models/subject.dart';
import '../services/data_service.dart';
import '../services/roadmap_service.dart';

class ConceptService {
  // Generate concepts for a chapter based on subject and chapter
  static List<ChapterConcept> getConceptsForChapter(String subjectId, String chapterId) {
    final chapter = DataService.getChapterById(subjectId, chapterId);
    if (chapter == null) return [];

    final List<ChapterConcept> concepts = [];
    int conceptIndex = 0;

    // Get avenger for this chapter
    final subject = DataService.getSubjectById(subjectId);
    if (subject == null) return [];

    final chapterIndex = subject.chapters.indexWhere((ch) => ch.id == chapterId);
    if (chapterIndex == -1) return [];

    final avenger = RoadmapService.getChapterAvenger(chapterIndex);

    // Generate concepts based on chapter description and materials
    final materials = chapter.materials;
    
    // Main concept from chapter name
    concepts.add(
      ChapterConcept(
        id: '${chapterId}_main',
        name: chapter.name,
        description: chapter.description,
        avengerName: avenger['name']!,
        avengerIcon: avenger['icon']!,
        avengerColor: avenger['color']!,
        conceptType: 'theory',
        keyPoints: _extractKeyPoints(chapter.description),
      ),
    );
    conceptIndex++;

    // Concepts from materials
    for (var material in materials) {
      if (material.type == 'notes' || material.type == 'pdf') {
        final conceptAvenger = RoadmapService.getChapterAvenger(conceptIndex);
        concepts.add(
          ChapterConcept(
            id: '${chapterId}_${material.id}',
            name: material.title,
            description: material.description ?? 'Important concept to learn',
            avengerName: conceptAvenger['name']!,
            avengerIcon: conceptAvenger['icon']!,
            avengerColor: conceptAvenger['color']!,
            conceptType: material.type == 'pdf' ? 'formula' : 'theory',
            keyPoints: material.description != null 
                ? _extractKeyPoints(material.description!) 
                : null,
          ),
        );
        conceptIndex++;
      } else if (material.type == 'quiz') {
        final conceptAvenger = RoadmapService.getChapterAvenger(conceptIndex);
        concepts.add(
          ChapterConcept(
            id: '${chapterId}_${material.id}',
            name: 'Practice Questions',
            description: material.description ?? 'Test your understanding',
            avengerName: conceptAvenger['name']!,
            avengerIcon: conceptAvenger['icon']!,
            avengerColor: conceptAvenger['color']!,
            conceptType: 'example',
            keyPoints: ['Practice makes perfect', 'Test your knowledge'],
          ),
        );
        conceptIndex++;
      }
    }

    // Add some default concepts if needed
    if (concepts.length < 3) {
      final additionalConcepts = _getDefaultConceptsForChapter(chapter.name, chapterId, conceptIndex);
      concepts.addAll(additionalConcepts);
    }

    return concepts;
  }

  static List<String> _extractKeyPoints(String description) {
    // Simple extraction - split by common separators
    final points = description
        .split(RegExp(r'[,;]'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty && p.length > 10)
        .take(3)
        .toList();
    
    if (points.isEmpty) {
      return ['Important concept', 'Key learning point', 'Essential knowledge'];
    }
    
    return points;
  }

  static List<ChapterConcept> _getDefaultConceptsForChapter(
    String chapterName,
    String chapterId,
    int startIndex,
  ) {
    final List<ChapterConcept> defaultConcepts = [];
    
    // Add key concepts based on chapter name patterns
    if (chapterName.toLowerCase().contains('electric')) {
      final avenger1 = RoadmapService.getChapterAvenger(startIndex);
      defaultConcepts.add(
        ChapterConcept(
          id: '${chapterId}_electric_field',
          name: 'Electric Field',
          description: 'Understanding electric field and its properties',
          avengerName: avenger1['name']!,
          avengerIcon: avenger1['icon']!,
          avengerColor: avenger1['color']!,
          conceptType: 'theory',
          keyPoints: ['Field lines', 'Direction', 'Strength'],
        ),
      );
    }
    
    if (chapterName.toLowerCase().contains('derivative') || 
        chapterName.toLowerCase().contains('integration')) {
      final avenger2 = RoadmapService.getChapterAvenger(startIndex + 1);
      defaultConcepts.add(
        ChapterConcept(
          id: '${chapterId}_formulas',
          name: 'Key Formulas',
          description: 'Important formulas and their applications',
          avengerName: avenger2['name']!,
          avengerIcon: avenger2['icon']!,
          avengerColor: avenger2['color']!,
          conceptType: 'formula',
          keyPoints: ['Formula derivation', 'Applications', 'Examples'],
        ),
      );
    }

    return defaultConcepts;
  }
}

