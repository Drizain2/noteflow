class Category {
  final int? id;
  final int userId;
  final String name;
  final String? color;

  Category({this.id, required this.userId, required this.name, this.color});

  Map<String, dynamic> toMap() {
    return {'id': id, 'user_id': userId, 'name': name, 'color': color};
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      color: map['color'],
    );
  }
}
