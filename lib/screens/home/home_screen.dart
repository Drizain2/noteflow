import 'package:flutter/material.dart';

import '../../services/session_service.dart';
import '../notes/note_editor_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const background = Color(0xFFF8FAFC);
  static const ink = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const primary = Color(0xFF2563EB);
  static const line = Color(0xFFE2E8F0);

  final noteService = NoteService();
  final searchController = TextEditingController();
  late Future<List<Note>> notesFuture;
  String selectedCategory = 'Toutes';

  final categories = const [
    ('Toutes', Color(0xFF2563EB), Color(0xFFEFF6FF)),
    ('Travail', Color(0xFF8B5CF6), Color(0xFFEDE9FE)),
    ('Personnel', Color(0xFF059669), Color(0xFFD1FAE5)),
    ('Etudes', Color(0xFFD97706), Color(0xFFFEF3C7)),
    ('Idees', Color(0xFF0284C7), Color(0xFFE0F2FE)),
  ];

  @override
  void initState() {
    super.initState();
    notesFuture = _loadNotes();
    searchController.addListener(() => setState(() {}));
  }

  Future<List<Note>> _loadNotes() {
    final userId = SessionService.currentUser?.id;
    return userId == null ? Future.value(const []) : noteService.getAll(userId);
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = SessionService.currentUser;

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
              sliver: SliverToBoxAdapter(child: _buildHeader(firstName)),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
              sliver: SliverToBoxAdapter(child: _buildSearch()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
              sliver: SliverToBoxAdapter(child: _buildWelcome()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              sliver: SliverToBoxAdapter(child: _buildCategories()),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notes recentes',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ink,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Voir tout'),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: _buildNotes(),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 96)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'home-add-note',
        onPressed: _openNoteEditor,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  Widget _buildHeader(String firstName) {
    return Row(
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
          onPressed: () => _showMessage('Notifications'),
          icon: const Icon(Icons.notifications_none_rounded, color: muted),
        ),
        CircleAvatar(
          radius: 19,
          backgroundColor: const Color(0xFFDBEAFE),
          child: Text(
            firstName.isEmpty ? 'V' : firstName[0].toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w700, color: primary),
          ),
        ),
      ],
    );
  }

  Widget _buildSearch() {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Rechercher notes, taches...',
        hintStyle: const TextStyle(
          fontFamily: 'Inter',
          color: Color(0xFF94A3B8),
        ),
        prefixIcon: const Icon(Icons.search_rounded, color: muted),
        suffixIcon: searchController.text.isEmpty
            ? null
            : IconButton(
                onPressed: searchController.clear,
                icon: const Icon(Icons.close_rounded, size: 19),
              ),
        filled: true,
        fillColor: const Color(0xFFF1F5F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 13,
          horizontal: 16,
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    final firstName =
        SessionService.currentUser?.name.split(' ').first ?? 'a vous';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Bonjour $firstName',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 27,
            height: 1.2,
            fontWeight: FontWeight.w700,
            color: ink,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Retrouvez vos notes et taches.',
          style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: muted),
        ),
        const SizedBox(height: 22),
        const Text(
          'Categories',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: ink,
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final category = categories[index];
          final selected = selectedCategory == category.$1;
          return ChoiceChip(
            label: Text(category.$1),
            selected: selected,
            onSelected: (_) => setState(() => selectedCategory = category.$1),
            labelStyle: TextStyle(
              fontFamily: 'Inter',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? category.$2 : muted,
            ),
            backgroundColor: Colors.white,
            selectedColor: category.$3,
            side: BorderSide(color: selected ? category.$2 : line),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            showCheckmark: false,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          );
        },
      ),
    );
  }

  Widget _buildNotes() {
    return SliverToBoxAdapter(
      child: FutureBuilder<List<Note>>(
        future: notesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 44),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            );
          }
          final query = searchController.text.trim().toLowerCase();
          final notes = (snapshot.data ?? [])
              .where(
                (note) =>
                    query.isEmpty ||
                    note.title.toLowerCase().contains(query) ||
                    note.content.toLowerCase().contains(query),
              )
              .toList();
          return notes.isEmpty
              ? _buildEmptyState()
              : Column(children: notes.map(_buildNoteCard).toList());
        },
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    return GestureDetector(
      onTap: () => _openNoteEditorForNote(note),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: line),
          boxShadow: const [
            BoxShadow(
              color: Color(0x080F172A),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: ink,
                    ),
                  ),
                ),
                if (note.isImportant)
                  const Icon(Icons.push_pin_rounded, size: 18, color: primary),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              note.content,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 13,
                height: 1.45,
                color: muted,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              _formatDate(note.updatedAt),
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 11,
                color: Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: line),
      ),
      child: const Column(
        children: [
          Icon(Icons.note_alt_outlined, size: 40, color: Color(0xFF94A3B8)),
          SizedBox(height: 12),
          Text(
            'Aucune note pour le moment',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: ink,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  Future<void> _openNoteEditor() async {
    await _openNoteEditorForNote();
  }

  Future<void> _openNoteEditorForNote([Note? note]) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => NoteEditorScreen(note: note)),
    );
    if (saved == true && mounted) {
      final refreshedNotes = _loadNotes();
      setState(() => notesFuture = refreshedNotes);
    }
  }

  void _showMessage(String label) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('$label sera bientot disponible.')));
  }
}
