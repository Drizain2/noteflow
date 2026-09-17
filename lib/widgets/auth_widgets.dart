import 'package:flutter/material.dart';

class AuthTokens {
  static const background = Color(0xFFF8FAFC);
  static const surface = Colors.white;
  static const primary = Color(0xFF2563EB);
  static const ink = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const outline = Color(0xFFE2E8F0);
  static const inputOutline = Color(0xFFCBD5E1);
  static const placeholder = Color(0xFF94A3B8);
  static const error = Color(0xFFEF4444);
  static const errorSurface = Color(0xFFFEF2F2);
}

class AuthPage extends StatelessWidget {
  const AuthPage({
    required this.title,
    required this.subtitle,
    required this.form,
    required this.footer,
    super.key,
  });

  final String title;
  final String subtitle;
  final Widget form;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthTokens.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                children: [
                  const AuthBrand(),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AuthTokens.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AuthTokens.outline),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A0F172A),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 24,
                            height: 32 / 24,
                            fontWeight: FontWeight.w700,
                            color: AuthTokens.ink,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            height: 20 / 14,
                            color: AuthTokens.muted,
                          ),
                        ),
                        const SizedBox(height: 28),
                        form,
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  footer,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AuthBrand extends StatelessWidget {
  const AuthBrand({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AuthTokens.primary,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Color(0x332563EB),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.edit_note_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 12),
        const Text(
          'Clarity Notes',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: AuthTokens.ink,
          ),
        ),
      ],
    );
  }
}

class AuthField extends StatelessWidget {
  const AuthField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          textInputAction: TextInputAction.next,
          style: _inputStyle,
          decoration: _decoration(hint, icon),
        ),
      ],
    );
  }
}

class AuthPasswordField extends StatelessWidget {
  const AuthPasswordField({
    required this.controller,
    required this.label,
    required this.isVisible,
    required this.onVisibilityChanged,
    this.validator,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final bool isVisible;
  final VoidCallback onVisibilityChanged;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: _labelStyle),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: !isVisible,
          validator: validator,
          textInputAction: TextInputAction.next,
          style: _inputStyle,
          decoration:
              _decoration(
                'Votre mot de passe',
                Icons.lock_outline_rounded,
              ).copyWith(
                suffixIcon: IconButton(
                  tooltip: isVisible
                      ? 'Masquer le mot de passe'
                      : 'Afficher le mot de passe',
                  onPressed: onVisibilityChanged,
                  icon: Icon(
                    isVisible
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AuthTokens.muted,
                  ),
                ),
              ),
        ),
      ],
    );
  }
}

class AuthErrorBanner extends StatelessWidget {
  const AuthErrorBanner({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AuthTokens.errorSurface,
        border: Border.all(color: const Color(0xFFFCA5A5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            size: 20,
            color: AuthTokens.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                height: 18 / 13,
                color: AuthTokens.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AuthSubmitButton extends StatelessWidget {
  const AuthSubmitButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AuthTokens.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AuthTokens.primary.withValues(alpha: 0.55),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}

class AuthFooter extends StatelessWidget {
  const AuthFooter({
    required this.prompt,
    required this.actionLabel,
    required this.onPressed,
    super.key,
  });

  final String prompt;
  final String actionLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          prompt,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 13,
            color: AuthTokens.muted,
          ),
        ),
        TextButton(
          onPressed: onPressed,
          child: Text(
            actionLabel,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AuthTokens.primary,
            ),
          ),
        ),
      ],
    );
  }
}

const _labelStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 14,
  fontWeight: FontWeight.w600,
  color: AuthTokens.ink,
);
const _inputStyle = TextStyle(
  fontFamily: 'Inter',
  fontSize: 14,
  color: AuthTokens.ink,
);

InputDecoration _decoration(String hint, IconData icon) {
  OutlineInputBorder border(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: color),
  );

  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(
      fontFamily: 'Inter',
      fontSize: 14,
      color: AuthTokens.placeholder,
    ),
    prefixIcon: Icon(icon, size: 20, color: AuthTokens.muted),
    filled: true,
    fillColor: AuthTokens.surface,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
    border: border(AuthTokens.inputOutline),
    enabledBorder: border(AuthTokens.inputOutline),
    focusedBorder: border(AuthTokens.primary),
    errorBorder: border(AuthTokens.error),
    focusedErrorBorder: border(AuthTokens.error),
  );
}
