import 'package:flutter/material.dart';

import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../widgets/auth_widgets.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final authService = AuthService();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool acceptedTerms = false;
  bool isLoading = false;
  String? termsError;
  String? registerError;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthPage(
      title: 'Creez votre compte',
      subtitle: 'Organisez vos notes en toute simplicite.',
      form: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AuthField(
              controller: nameController,
              label: 'Nom complet',
              hint: 'Votre nom',
              icon: Icons.person_outline_rounded,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Le nom est obligatoire'
                  : null,
            ),
            const SizedBox(height: 16),
            AuthField(
              controller: emailController,
              label: 'Adresse email',
              hint: 'votre@email.com',
              icon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
            const SizedBox(height: 16),
            AuthPasswordField(
              controller: passwordController,
              label: 'Mot de passe',
              isVisible: isPasswordVisible,
              onVisibilityChanged: () =>
                  setState(() => isPasswordVisible = !isPasswordVisible),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Le mot de passe est obligatoire';
                }
                if (value.length < 6) return 'Minimum 6 caracteres';
                return null;
              },
            ),
            const SizedBox(height: 16),
            AuthPasswordField(
              controller: confirmPasswordController,
              label: 'Confirmer le mot de passe',
              isVisible: isConfirmPasswordVisible,
              onVisibilityChanged: () => setState(
                () => isConfirmPasswordVisible = !isConfirmPasswordVisible,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez confirmer le mot de passe';
                }
                if (value != passwordController.text) {
                  return 'Les mots de passe ne correspondent pas';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            _buildTermsField(),
            if (registerError != null) ...[
              const SizedBox(height: 16),
              AuthErrorBanner(message: registerError!),
            ],
            const SizedBox(height: 20),
            AuthSubmitButton(
              label: 'S inscrire',
              isLoading: isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
      footer: AuthFooter(
        prompt: 'Deja un compte ?',
        actionLabel: 'Se connecter',
        onPressed: () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        ),
      ),
    );
  }

  Widget _buildTermsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: Checkbox(
                value: acceptedTerms,
                onChanged: (value) => setState(() {
                  acceptedTerms = value ?? false;
                  if (acceptedTerms) termsError = null;
                }),
                activeColor: AuthTokens.primary,
                side: const BorderSide(
                  color: AuthTokens.inputOutline,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                "J'accepte les conditions d'utilisation.",
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 13,
                  color: AuthTokens.muted,
                ),
              ),
            ),
          ],
        ),
        if (termsError != null) ...[
          const SizedBox(height: 6),
          Text(
            termsError!,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              color: AuthTokens.error,
            ),
          ),
        ],
      ],
    );
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "L'adresse email est obligatoire";
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value.trim())) {
      return 'Veuillez saisir une adresse email valide';
    }
    return null;
  }

  Future<void> _submit() async {
    final formIsValid = formKey.currentState?.validate() ?? false;
    final termsAreValid = acceptedTerms;
    setState(() {
      termsError = termsAreValid
          ? null
          : "Vous devez accepter les conditions d'utilisation";
    });
    if (!formIsValid || !termsAreValid) {
      return;
    }

    setState(() {
      isLoading = true;
      registerError = null;
    });

    try {
      await authService.register(
        User(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text,
        ),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Compte cree avec succes.')));
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } catch (error) {
      if (mounted) {
        setState(
          () =>
              registerError = error.toString().replaceFirst('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }
}
