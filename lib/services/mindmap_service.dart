import '../models/mindmap_node.dart';
import '../models/chapter_concept.dart';
import '../services/concept_service.dart';
import '../services/roadmap_service.dart';
import '../services/data_service.dart';
import 'dart:math' as math;

class MindMapService {
  static List<MindMapNode> generateMindMapForChapter(
    String subjectId,
    String chapterId,
  ) {
    final concepts = ConceptService.getConceptsForChapter(subjectId, chapterId);
    if (concepts.isEmpty) return [];

    final List<MindMapNode> nodes = [];
    
    // Get chapter info
    final chapter = DataService.getChapterById(subjectId, chapterId);
    final subject = DataService.getSubjectById(subjectId);
    
    int chapterIndex = 0;
    if (subject != null && chapter != null) {
      final index = subject.chapters.indexWhere((ch) => ch.id == chapterId);
      chapterIndex = index >= 0 ? index : 0;
    }

    // Center node - Main Chapter Concept
    final mainAvenger = RoadmapService.getChapterAvenger(chapterIndex);
    final mainConcept = concepts.first;
    
    nodes.add(
      MindMapNode(
        id: 'center',
        title: chapter?.name ?? mainConcept.name,
        description: chapter?.description ?? mainConcept.description,
        avengerName: mainAvenger['name']!,
        avengerIcon: mainAvenger['icon']!,
        avengerColor: mainAvenger['color']!,
        x: 0.5, // Center position (normalized 0-1)
        y: 0.5,
        nodeType: 'main',
        level: 0,
      ),
    );

    // Generate child nodes in circular pattern
    final int conceptCount = concepts.length > 1 ? concepts.length - 1 : concepts.length;
    final double angleStep = (2 * math.pi) / conceptCount;
    final double radius = 0.25; // Distance from center

    for (int i = 0; i < conceptCount; i++) {
      final concept = concepts[i == 0 && concepts.length > 1 ? i + 1 : i];
      final angle = i * angleStep;
      
      // Calculate position in circular pattern
      final x = 0.5 + radius * math.cos(angle);
      final y = 0.5 + radius * math.sin(angle);

      // Get avenger for this concept
      final conceptAvenger = RoadmapService.getChapterAvenger(chapterIndex + i + 1);

      nodes.add(
        MindMapNode(
          id: 'node_$i',
          title: concept.name,
          description: concept.description,
          avengerName: conceptAvenger['name']!,
          avengerIcon: conceptAvenger['icon']!,
          avengerColor: conceptAvenger['color']!,
          x: x,
          y: y,
          childIds: [],
          nodeType: 'concept',
          level: 1,
        ),
      );

      // Add center node's child reference
      nodes[0] = MindMapNode(
        id: nodes[0].id,
        title: nodes[0].title,
        description: nodes[0].description,
        avengerName: nodes[0].avengerName,
        avengerIcon: nodes[0].avengerIcon,
        avengerColor: nodes[0].avengerColor,
        x: nodes[0].x,
        y: nodes[0].y,
        childIds: [...nodes[0].childIds, 'node_$i'],
        nodeType: nodes[0].nodeType,
        level: nodes[0].level,
      );
    }

    // Add sub-concepts for main concepts (comprehensive overview for revision)
    int subNodeIndex = 0;
    for (int i = 0; i < conceptCount && subNodeIndex < 6; i++) {
      final concept = concepts[i == 0 && concepts.length > 1 ? i + 1 : i];
      
      // Generate sub-concepts from key points or create default ones
      List<String> subConcepts = [];
      if (concept.keyPoints != null && concept.keyPoints!.isNotEmpty) {
        subConcepts = concept.keyPoints!.take(3).toList();
      } else {
        // Generate default sub-concepts based on concept type
        if (concept.conceptType == 'formula') {
          subConcepts = ['Important Formulas', 'Applications', 'Examples'];
        } else if (concept.conceptType == 'theory') {
          subConcepts = ['Key Concepts', 'Definitions', 'Principles'];
        } else {
          subConcepts = ['Main Points', 'Details', 'Examples'];
        }
      }
      
      final parentNode = nodes[i + 1];
      
      for (int j = 0; j < subConcepts.length && j < 2; j++) {
        final subAngle = (i * angleStep) + (j == 0 ? -0.25 : 0.25);
        final subRadius = radius + 0.18;
        
        final subX = 0.5 + subRadius * math.cos(subAngle);
        final subY = 0.5 + subRadius * math.sin(subAngle);

        final subAvenger = RoadmapService.getChapterAvenger(chapterIndex + 20 + subNodeIndex);
        
        final subNodeId = 'subnode_${i}_$j';
        nodes.add(
          MindMapNode(
            id: subNodeId,
            title: subConcepts[j],
            description: 'Revision point: ${subConcepts[j]} related to ${concept.name}',
            avengerName: subAvenger['name']!,
            avengerIcon: subAvenger['icon']!,
            avengerColor: subAvenger['color']!,
            x: subX,
            y: subY,
            childIds: [],
            nodeType: 'subconcept',
            level: 2,
          ),
        );

        // Update parent node
        final parentIndex = nodes.indexWhere((n) => n.id == parentNode.id);
        if (parentIndex >= 0) {
          nodes[parentIndex] = MindMapNode(
            id: nodes[parentIndex].id,
            title: nodes[parentIndex].title,
            description: nodes[parentIndex].description,
            avengerName: nodes[parentIndex].avengerName,
            avengerIcon: nodes[parentIndex].avengerIcon,
            avengerColor: nodes[parentIndex].avengerColor,
            x: nodes[parentIndex].x,
            y: nodes[parentIndex].y,
            childIds: [...nodes[parentIndex].childIds, subNodeId],
            nodeType: nodes[parentIndex].nodeType,
            level: nodes[parentIndex].level,
          );
        }

        subNodeIndex++;
      }
    }

    return nodes;
  }
}

