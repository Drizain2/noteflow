class Note {
  final int? id;
  final int userId;
  final int? categoryId;
  final String title;
  final String content;
  final bool isImportant;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    this.id,
    required this.userId,
    this.categoryId,
    required this.title,
    required this.content,
    this.isImportant = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'category_id': categoryId,
      'title': title,
      'content': content,
      'is_important': isImportant ? 1 : 0,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      userId: map['user_id'],
      categoryId: map['category_id'],
      title: map['title'],
      content: map['content'],
      isImportant: map['is_important'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }
}
