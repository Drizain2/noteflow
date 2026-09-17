import '../database/database_helper.dart';
import '../models/note.dart';

class NoteService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<int> create(Note note) async {
    final db = await _databaseHelper.database;

    return await db.insert(
      'notes',
      note.toMap(),
    );
  }

  Future<List<Note>> getAll(int userId) async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      'notes',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'updated_at DESC',
    );

    return result.map((map) => Note.fromMap(map)).toList();
  }

  Future<List<Note>> getByCategory(int userId, int categoryId) async {
  final db = await _databaseHelper.database;

  final result = await db.query(
    'notes',
    where: 'user_id = ? AND category_id = ?',
    whereArgs: [userId, categoryId],
    orderBy: 'updated_at DESC',
  );

  return result.map((map) => Note.fromMap(map)).toList();
}

Future<int> update(Note note) async {
  final db = await _databaseHelper.database;

  return await db.update(
    'notes',
    note.toMap(),
    where: 'id = ? AND user_id = ?',
    whereArgs: [note.id, note.userId],
  );
}

Future<int> delete(int noteId, int userId) async {
  final db = await _databaseHelper.database;

  return await db.delete(
    'notes',
    where: 'id = ? AND user_id = ?',
    whereArgs: [noteId, userId],
  );
}
}