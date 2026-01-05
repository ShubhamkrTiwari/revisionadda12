class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime? reminderDate;
  final bool isReminder;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.reminderDate,
    this.isReminder = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
      'reminderDate': reminderDate?.toIso8601String(),
      'isReminder': isReminder,
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      reminderDate: json['reminderDate'] != null
          ? DateTime.parse(json['reminderDate'] as String)
          : null,
      isReminder: json['isReminder'] as bool? ?? false,
    );
  }

  Note copyWith({
    String? id,
    String? title,
    String? content,
    DateTime? createdAt,
    DateTime? reminderDate,
    bool? isReminder,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      reminderDate: reminderDate ?? this.reminderDate,
      isReminder: isReminder ?? this.isReminder,
    );
  }
}

