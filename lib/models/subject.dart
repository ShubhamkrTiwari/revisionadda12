class Subject {
  final String id;
  final String name;
  final String icon;
  final String description;
  final List<Chapter> chapters;

  Subject({
    required this.id,
    required this.name,
    required this.icon,
    required this.description,
    required this.chapters,
  });
}

class Chapter {
  final String id;
  final String name;
  final String subjectId;
  final String description;
  final List<StudyMaterial> materials;

  Chapter({
    required this.id,
    required this.name,
    required this.subjectId,
    required this.description,
    required this.materials,
  });
}

class StudyMaterial {
  final String id;
  final String title;
  final String type; // 'pdf', 'notes', 'video', 'quiz'
  final String url;
  final String chapterId;
  final String? description;
  final bool isPremium;

  StudyMaterial({
    required this.id,
    required this.title,
    required this.type,
    required this.url,
    required this.chapterId,
    this.description,
    this.isPremium = false,
  });
}

