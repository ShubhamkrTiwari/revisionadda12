class ChapterConcept {
  final String id;
  final String name;
  final String description;
  final String avengerName;
  final String avengerIcon;
  final String avengerColor;
  final String conceptType; // 'formula', 'theory', 'diagram', 'example'
  final String? imageUrl;
  final String? formula;
  final List<String>? keyPoints;

  ChapterConcept({
    required this.id,
    required this.name,
    required this.description,
    required this.avengerName,
    required this.avengerIcon,
    required this.avengerColor,
    required this.conceptType,
    this.imageUrl,
    this.formula,
    this.keyPoints,
  });
}

