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
  final List<Material> materials;

  Chapter({
    required this.id,
    required this.name,
    required this.subjectId,
    required this.description,
    required this.materials,
  });
}

class Material {
  final String id;
  final String title;
  final String type; // 'pdf', 'notes', 'video', 'quiz'
  final String url;
  final String chapterId;
  final String? description;
  final bool isPremium;

  Material({
    required this.id,
    required this.title,
    required this.type,
    required this.url,
    required this.chapterId,
    this.description,
    this.isPremium = false,
  });
}

