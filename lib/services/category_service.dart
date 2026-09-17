import '../database/database_helper.dart';
import '../models/category.dart';

class CategoryService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> create(Category category) async {
    final db = await _databaseHelper.database;

    return await db.insert('categories', category.toMap());
  }

  Future<List<Category>> getAll(int userId) async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      'categories',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'name ASC',
    );

    return result.map((map) => Category.fromMap(map)).toList();
  }

  Future<int> update(Category category) async {
    final db = await _databaseHelper.database;

    return await db.update(
      'categories',
      category.toMap(),
      where: 'id = ? AND user_id = ?',
      whereArgs: [category.id, category.userId],
    );
  }

  Future<int> delete(int categoryId, int userId) async {
    final db = await _databaseHelper.database;

    return await db.delete(
      'categories',
      where: 'id = ? AND user_id = ?',
      whereArgs: [categoryId, userId],
    );
  }
}
