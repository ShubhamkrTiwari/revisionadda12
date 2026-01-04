class MindMapNode {
  final String id;
  final String title;
  final String description;
  final String avengerName;
  final String avengerIcon;
  final String avengerColor;
  final double x;
  final double y;
  final List<String> childIds;
  final String nodeType; // 'main', 'concept', 'subconcept'
  final int level; // 0 = center, 1 = first level, 2 = second level

  MindMapNode({
    required this.id,
    required this.title,
    required this.description,
    required this.avengerName,
    required this.avengerIcon,
    required this.avengerColor,
    required this.x,
    required this.y,
    this.childIds = const [],
    this.nodeType = 'concept',
    this.level = 0,
  });
}

