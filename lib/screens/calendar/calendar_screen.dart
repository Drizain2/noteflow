import 'package:flutter/material.dart';

import '../../models/note.dart';
import '../../services/note_service.dart';
import '../../services/session_service.dart';
import '../notes/note_editor_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  static const background = Color(0xFFF8FAFC);
  static const ink = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const primary = Color(0xFF2563EB);
  static const line = Color(0xFFE2E8F0);

  final service = NoteService();
  late Future<List<Note>> notesFuture;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    notesFuture = _loadNotes();
  }

  Future<List<Note>> _loadNotes() {
    final userId = SessionService.currentUser?.id;
    return userId == null ? Future.value(const []) : service.getAll(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text(
          'Calendrier',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: ink,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 32),
        children: [
          _buildDateCard(),
          const SizedBox(height: 26),
          Text(
            _isToday ? 'Aujourd hui' : _formatLongDate(selectedDate),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ink,
            ),
          ),
          const SizedBox(height: 12),
          _buildNotes(),
        ],
      ),
    );
  }

  Widget _buildDateCard() {
    final dates = List.generate(
      7,
      (index) => DateTime.now().add(Duration(days: index - 2)),
    );
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: line),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: dates.map((date) {
          final selected = _sameDay(date, selectedDate);
          return GestureDetector(
            onTap: () => setState(() => selectedDate = date),
            child: Column(
              children: [
                Text(
                  _weekday(date),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: selected ? primary : muted,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? primary : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : ink,
                    ),
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNotes() {
    return FutureBuilder<List<Note>>(
      future: notesFuture,
      builder: (context, snapshot) {
        final notes = (snapshot.data ?? [])
            .where((note) => _sameDay(note.updatedAt, selectedDate))
            .toList();
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        }
        if (notes.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: line),
            ),
            child: const Column(
              children: [
                Icon(
                  Icons.event_note_outlined,
                  size: 40,
                  color: Color(0xFF94A3B8),
                ),
                SizedBox(height: 12),
                Text(
                  'Aucune note ce jour',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: ink,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Votre agenda est libre.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 13,
                    color: muted,
                  ),
                ),
              ],
            ),
          );
        }
        return Column(
          children: notes.map((note) {
            return ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => NoteEditorScreen(note: note)),
              ),
              tileColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: const BorderSide(color: line),
              ),
              title: Text(
                note.title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w700,
                  color: ink,
                ),
              ),
              subtitle: Text(
                note.content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontFamily: 'Inter', color: muted),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  bool get _isToday => _sameDay(selectedDate, DateTime.now());
  bool _sameDay(DateTime first, DateTime second) =>
      first.year == second.year &&
      first.month == second.month &&
      first.day == second.day;
  String _weekday(DateTime date) =>
      const ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'][date.weekday - 1];
  String _formatLongDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
