import '../database/database_helper.dart';
import '../models/user.dart';

class AuthService {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  // Inscription
  Future<int> register(User user) async {
  final existingUser = await findByEmail(user.email);

  if (existingUser != null) {
    throw Exception('Cette adresse email est déjà utilisée.');
  }

  final db = await _databaseHelper.database;

  return await db.insert(
    'users',
    user.toMap(),
  );
}

  // Recherche d'un utilisateur par email
  Future<User?> findByEmail(String email) async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return User.fromMap(result.first);
  }

  // Connexion
  Future<User?> login(String email, String password) async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
      limit: 1,
    );

    if (result.isEmpty) {
      return null;
    }

    return User.fromMap(result.first);
  }
}
