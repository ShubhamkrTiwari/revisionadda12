class RoadmapItem {
  final String id;
  final String name;
  final String subjectId;
  final String chapterId;
  final String description;
  final String avengerName; // Marvel character name for this concept
  final String avengerColor; // Color theme for this avenger
  final int order;
  final bool isCompleted;
  final bool isLocked;

  RoadmapItem({
    required this.id,
    required this.name,
    required this.subjectId,
    required this.chapterId,
    required this.description,
    required this.avengerName,
    required this.avengerColor,
    required this.order,
    this.isCompleted = false,
    this.isLocked = false,
  });
}

