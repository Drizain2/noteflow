import 'package:flutter/material.dart';

import '../services/session_service.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({this.onProfile, this.onNotifications, super.key});

  final VoidCallback? onProfile;
  final VoidCallback? onNotifications;

  static const ink = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const primary = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    final name = SessionService.currentUser?.name ?? 'Utilisateur';
    final initial = name.isEmpty ? 'U' : name[0].toUpperCase();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: primary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Icon(
              Icons.edit_note_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Clarity Notes',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ink,
              ),
            ),
          ),
          IconButton(
            tooltip: 'Notifications',
            onPressed: onNotifications,
            icon: const Icon(Icons.notifications_none_rounded, color: muted),
          ),
          GestureDetector(
            onTap: onProfile,
            child: CircleAvatar(
              radius: 19,
              backgroundColor: const Color(0xFFDBEAFE),
              child: Text(
                initial,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
