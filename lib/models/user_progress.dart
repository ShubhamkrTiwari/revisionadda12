class UserProgress {
  final String materialId;
  final double progress; // 0.0 to 1.0
  final DateTime lastAccessed;
  final bool isCompleted;

  UserProgress({
    required this.materialId,
    required this.progress,
    required this.lastAccessed,
    this.isCompleted = false,
  });
}

