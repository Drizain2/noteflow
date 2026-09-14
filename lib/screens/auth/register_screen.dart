import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  // ============================================================
  // DESIGN TOKENS — Clarity Notes
  // ============================================================

  static const Color backgroundColor = Color(0xFFFAF8FF);

  static const Color surfaceColor = Color(0xFFFFFFFF);

  static const Color primaryColor = Color(0xFF2563EB);
  static const Color primaryPressedColor = Color(0xFF1D4ED8);

  static const Color textColor = Color(0xFF0F172A);
  static const Color secondaryTextColor = Color(0xFF64748B);

  static const Color outlineColor = Color(0xFFE2E8F0);
  static const Color inputBorderColor = Color(0xFFCBD5E1);

  static const Color placeholderColor = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          child: Column(
            children: [
              // ==================================================
              // LOGO
              // ==================================================

              _buildLogo(),

              const SizedBox(height: 8),

              const Text(
                'Clarity Notes',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 22 / 15,
                  color: textColor,
                ),
              ),

              const SizedBox(height: 24),

              // ==================================================
              // REGISTER CARD
              // ==================================================

              _buildRegisterCard(context),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOGO
  // ============================================================

  Widget _buildLogo() {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: 0.20),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: const Icon(
        Icons.note_alt_outlined,
        color: Colors.white,
        size: 26,
      ),
    );
  }

  // ============================================================
  // REGISTER CARD
  // ============================================================

  Widget _buildRegisterCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),

      decoration: BoxDecoration(
        color: surfaceColor,

        borderRadius: BorderRadius.circular(16),

        border: Border.all(
          color: outlineColor,
          width: 1,
        ),

        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.03),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // TITLE
          // ======================================================

          const Center(
            child: Text(
              'Créez votre compte',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 24,
                fontWeight: FontWeight.w600,
                height: 32 / 24,
                color: textColor,
              ),
            ),
          ),

          const SizedBox(height: 8),

          const Center(
            child: Text(
              'Commencez à organiser vos notes en toute simplicité.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                height: 20 / 14,
                color: secondaryTextColor,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // ======================================================
          // NOM COMPLET
          // ======================================================

          _buildFieldLabel('Nom complet'),

          const SizedBox(height: 8),

          _buildTextField(
            hintText: 'Votre nom',
            prefixIcon: Icons.person_outline,
          ),

          const SizedBox(height: 16),

          // ======================================================
          // EMAIL
          // ======================================================

          _buildFieldLabel('Adresse Email'),

          const SizedBox(height: 8),

          _buildTextField(
            hintText: 'votre@email.com',
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
          ),

          const SizedBox(height: 16),

          // ======================================================
          // MOT DE PASSE
          // ======================================================

          _buildFieldLabel('Mot de passe'),

          const SizedBox(height: 8),

          _buildPasswordField(),

          const SizedBox(height: 16),

          // ======================================================
          // CONFIRMATION MOT DE PASSE
          // ======================================================

          _buildFieldLabel('Confirmer le mot de passe'),

          const SizedBox(height: 8),

          _buildPasswordField(),

          const SizedBox(height: 16),

          // ======================================================
          // CONDITIONS
          // ======================================================

          _buildTermsCheckbox(),

          const SizedBox(height: 20),

          // ======================================================
          // REGISTER BUTTON
          // ======================================================

          _buildRegisterButton(),

          const SizedBox(height: 20),

          // ======================================================
          // LOGIN LINK
          // ======================================================

          _buildLoginLink(context),
        ],
      ),
    );
  }

  // ============================================================
  // FIELD LABEL
  // ============================================================

  Widget _buildFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontFamily: 'Inter',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        height: 20 / 14,
        color: textColor,
      ),
    );
  }

  // ============================================================
  // TEXT FIELD
  // ============================================================

  Widget _buildTextField({
    required String hintText,
    required IconData prefixIcon,
    TextInputType? keyboardType,
  }) {
    return SizedBox(
      height: 48,
      child: TextField(
        keyboardType: keyboardType,

        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: textColor,
        ),

        decoration: InputDecoration(
          hintText: hintText,

          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: placeholderColor,
          ),

          prefixIcon: Icon(
            prefixIcon,
            size: 20,
            color: secondaryTextColor,
          ),

          filled: true,
          fillColor: surfaceColor,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: inputBorderColor,
              width: 1,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: inputBorderColor,
              width: 1,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: primaryColor,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PASSWORD FIELD
  // ============================================================

  Widget _buildPasswordField() {
    return SizedBox(
      height: 48,
      child: TextField(
        obscureText: true,

        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 14,
          color: textColor,
        ),

        decoration: InputDecoration(
          hintText: '••••••••',

          hintStyle: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            color: placeholderColor,
          ),

          prefixIcon: const Icon(
            Icons.lock_outline,
            size: 20,
            color: secondaryTextColor,
          ),

          suffixIcon: IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.visibility_outlined,
              size: 20,
              color: secondaryTextColor,
            ),
          ),

          filled: true,
          fillColor: surfaceColor,

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: inputBorderColor,
              width: 1,
            ),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: inputBorderColor,
              width: 1,
            ),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(
              color: primaryColor,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // TERMS CHECKBOX
  // ============================================================

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: false,
            onChanged: (value) {},

            activeColor: primaryColor,

            side: const BorderSide(
              color: inputBorderColor,
              width: 1.5,
            ),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),

            materialTapTargetSize:
                MaterialTapTargetSize.shrinkWrap,
          ),
        ),

        const SizedBox(width: 10),

        const Expanded(
          child: Text(
            "J'accepte les conditions d'utilisation.",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              height: 18 / 13,
              color: secondaryTextColor,
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // REGISTER BUTTON
  // ============================================================

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,

      child: ElevatedButton(
        onPressed: () {},

        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,

          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),

          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
        ),

        child: const Text(
          "S'inscrire",
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            height: 20 / 14,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // LOGIN LINK
  // ============================================================

  Widget _buildLoginLink(BuildContext context) {
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          const Text(
            'Déjà un compte ? ',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: secondaryTextColor,
            ),
          ),

          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },

            child: const Text(
              'Se connecter',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}