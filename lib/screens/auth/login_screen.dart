import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../services/session_service.dart';
import '../../widgets/auth_widgets.dart';
import '../shell/app_shell.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final authService = AuthService();
  bool isPasswordVisible = false;
  bool isLoading = false;
  String? loginError;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: 'Bienvenue sur Clarity Notes',
      subtitle: 'Connectez-vous pour retrouver vos notes et taches.',
      form: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthField(
              controller: emailController,
              label: 'Adresse email',
              hint: 'exemple@email.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Veuillez saisir votre email'
                  : null,
            ),
            const SizedBox(height: 18),
            AuthPasswordField(
              controller: passwordController,
              label: 'Mot de passe',
              isVisible: isPasswordVisible,
              onVisibilityChanged: () => setState(
                () => isPasswordVisible = !isPasswordVisible,
              ),
              validator: (value) => value == null || value.isEmpty
                  ? 'Veuillez saisir votre mot de passe'
                  : null,
            ),
            if (loginError != null) ...[
              const SizedBox(height: 18),
              AuthErrorBanner(message: loginError!),
            ],
            const SizedBox(height: 24),
            AuthSubmitButton(
              label: 'Se connecter',
              isLoading: isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
      footer: AuthFooter(
        prompt: 'Pas encore de compte ?',
        actionLabel: 'Creer un compte',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RegisterScreen()),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() {
      isLoading = true;
      loginError = null;
    });

    try {
      final User? user = await authService.login(
        emailController.text.trim(),
        passwordController.text,
      );
      if (!mounted) return;

      if (user == null) {
        setState(() => loginError = 'Email ou mot de passe incorrect.');
        return;
      }

      SessionService.login(user);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AppShell()),
      );
    } catch (_) {
      if (mounted) {
        setState(
          () => loginError = 'Une erreur est survenue lors de la connexion.',
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
