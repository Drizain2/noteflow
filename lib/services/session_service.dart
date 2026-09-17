import '../models/user.dart';

class SessionService {
  static User? _currentUser;

  // Utilisateur actuellement connecté
  static User? get currentUser => _currentUser;

  // Enregistrer l'utilisateur connecté
  static void login(User user) {
    _currentUser = user;
  }

  // Déconnecter l'utilisateur
  static void logout() {
    _currentUser = null;
  }

  // Vérifier si un utilisateur est connecté
  static bool get isLoggedIn => _currentUser != null;
}