import '../models/roadmap_item.dart';
import '../models/subject.dart';
import '../services/data_service.dart';

class RoadmapService {
  // Marvel Avengers mapping for subjects
  static const Map<String, Map<String, String>> _subjectAvengers = {
    'physics': {
      'name': 'Iron Man',
      'color': '#FF6B35', // Iron Man red/orange
      'icon': '⚡',
    },
    'chemistry': {
      'name': 'Hulk',
      'color': '#4ECDC4', // Hulk green/cyan
      'icon': '🧪',
    },
    'mathematics': {
      'name': 'Doctor Strange',
      'color': '#9B59B6', // Mystical purple
      'icon': '🔮',
    },
    'biology': {
      'name': 'Spider-Man',
      'color': '#E74C3C', // Spider-Man red
      'icon': '🕷️',
    },
  };

  // Avengers for chapters (different characters for variety)
  static final List<Map<String, String>> _chapterAvengers = [
    {'name': 'Captain America', 'color': '#3498DB', 'icon': '🛡️'},
    {'name': 'Thor', 'color': '#F39C12', 'icon': '⚡'},
    {'name': 'Black Widow', 'color': '#E91E63', 'icon': '🕷️'},
    {'name': 'Hawkeye', 'color': '#8E44AD', 'icon': '🏹'},
    {'name': 'Black Panther', 'color': '#1ABC9C', 'icon': '🐾'},
    {'name': 'Ant-Man', 'color': '#E67E22', 'icon': '🐜'},
    {'name': 'Wasp', 'color': '#F1C40F', 'icon': '🐝'},
    {'name': 'Falcon', 'color': '#34495E', 'icon': '🦅'},
    {'name': 'War Machine', 'color': '#95A5A6', 'icon': '🛡️'},
    {'name': 'Vision', 'color': '#9B59B6', 'icon': '👁️'},
    {'name': 'Scarlet Witch', 'color': '#E74C3C', 'icon': '✨'},
    {'name': 'Winter Soldier', 'color': '#2C3E50', 'icon': '❄️'},
    {'name': 'Star-Lord', 'color': '#3498DB', 'icon': '⭐'},
    {'name': 'Gamora', 'color': '#27AE60', 'icon': '🗡️'},
    {'name': 'Drax', 'color': '#E67E22', 'icon': '⚔️'},
    {'name': 'Rocket', 'color': '#95A5A6', 'icon': '🚀'},
  ];

  static String getSubjectAvengerName(String subjectId) {
    return _subjectAvengers[subjectId]?['name'] ?? 'Avenger';
  }

  static String getSubjectAvengerColor(String subjectId) {
    return _subjectAvengers[subjectId]?['color'] ?? '#7B68EE';
  }

  static String getSubjectAvengerIcon(String subjectId) {
    return _subjectAvengers[subjectId]?['icon'] ?? '🦸';
  }

  static Map<String, String> getChapterAvenger(int index) {
    return _chapterAvengers[index % _chapterAvengers.length];
  }

  static List<RoadmapItem> generateRoadmapForSubject(String subjectId) {
    final subject = DataService.getSubjectById(subjectId);
    if (subject == null) return [];

    final List<RoadmapItem> roadmap = [];
    int order = 0;

    for (var chapter in subject.chapters) {
      final avenger = getChapterAvenger(order);
      roadmap.add(
        RoadmapItem(
          id: '${subjectId}_${chapter.id}',
          name: chapter.name,
          subjectId: subjectId,
          chapterId: chapter.id,
          description: chapter.description,
          avengerName: avenger['name']!,
          avengerColor: avenger['color']!,
          order: order++,
          isLocked: order > 1, // First chapter unlocked, rest locked initially
        ),
      );
    }

    return roadmap;
  }

  static List<RoadmapItem> generateCompleteRoadmap() {
    final subjects = DataService.getSubjects();
    final List<RoadmapItem> completeRoadmap = [];
    int globalOrder = 0;

    for (var subject in subjects) {
      for (var chapter in subject.chapters) {
        final avenger = getChapterAvenger(globalOrder);
        completeRoadmap.add(
          RoadmapItem(
            id: '${subject.id}_${chapter.id}',
            name: chapter.name,
            subjectId: subject.id,
            chapterId: chapter.id,
            description: chapter.description,
            avengerName: avenger['name']!,
            avengerColor: avenger['color']!,
            order: globalOrder++,
            isLocked: globalOrder > 1,
          ),
        );
      }
    }

    return completeRoadmap;
  }
}

