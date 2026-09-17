import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../models/note.dart';
import '../../services/category_service.dart';
import '../../services/note_service.dart';
import '../../services/session_service.dart';
import '../../widgets/app_header.dart';
import '../notes/note_editor_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
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
  final categoryService = CategoryService();
  final searchController = TextEditingController();
  late Future<List<Note>> notesFuture;
  late Future<List<Category>> categoriesFuture;
  List<Category> categorySnapshot = const [];
  String selectedCategory = 'Toutes';
  int? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    notesFuture = _loadNotes();
    categoriesFuture = _loadCategories();
    categoriesFuture.then((loaded) {
      if (mounted) setState(() => categorySnapshot = loaded);
    });
    searchController.addListener(_onSearchChanged);
  }

  Future<List<Note>> _loadNotes() {
    final userId = SessionService.currentUser?.id;
    return userId == null ? Future.value(const []) : noteService.getAll(userId);
  }

  Future<List<Category>> _loadCategories() {
    final userId = SessionService.currentUser?.id;
    return userId == null
        ? Future.value(const [])
        : categoryService.getAll(userId);
  }

  void _onSearchChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final firstName =
        SessionService.currentUser?.name.split(' ').first ?? 'vous';

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refreshContent,
          color: primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                sliver: SliverToBoxAdapter(
                  child: AppHeader(
                    onProfile: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ProfileScreen()),
                    ),
                    onNotifications: () =>
                        _showMessage('Aucune nouvelle notification.'),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                sliver: SliverToBoxAdapter(child: _buildSearch()),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
                sliver: SliverToBoxAdapter(child: _buildWelcome(firstName)),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                sliver: SliverToBoxAdapter(child: _buildCategorySection()),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 12),
                sliver: SliverToBoxAdapter(child: _buildNotesHeader()),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: _buildNotes(),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 96)),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'home-add-note',
        onPressed: _openNoteEditor,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  Widget _buildSearch() {
    return TextField(
      controller: searchController,
      textInputAction: TextInputAction.search,
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
                tooltip: 'Effacer la recherche',
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

  Widget _buildWelcome(String firstName) {
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
      ],
    );
  }

  Widget _buildCategorySection() {
    return FutureBuilder<List<Category>>(
      future: categoriesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 68,
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }
        final categories = snapshot.data ?? const <Category>[];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Categories',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: ink,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length + 1,
                separatorBuilder: (_, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return _buildCategoryChip(
                      label: 'Toutes',
                      color: primary,
                      tint: const Color(0xFFEFF6FF),
                      selected: selectedCategoryId == null,
                      onSelected: () => setState(() {
                        selectedCategory = 'Toutes';
                        selectedCategoryId = null;
                      }),
                    );
                  }
                  final category = categories[index - 1];
                  return _buildCategoryChip(
                    label: category.name,
                    color: _parseColor(category.color),
                    tint: _parseColor(category.color).withValues(alpha: 0.12),
                    selected: selectedCategoryId == category.id,
                    onSelected: () => setState(() {
                      selectedCategory = category.name;
                      selectedCategoryId = category.id;
                    }),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoryChip({
    required String label,
    required Color color,
    required Color tint,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      labelStyle: TextStyle(
        fontFamily: 'Inter',
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: selected ? color : muted,
      ),
      backgroundColor: Colors.white,
      selectedColor: tint,
      side: BorderSide(color: selected ? color : line),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      showCheckmark: false,
      padding: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildNotesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Toutes vos notes',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: ink,
          ),
        ),
        TextButton(
          onPressed: () => setState(() {
            selectedCategory = 'Toutes';
            selectedCategoryId = null;
            searchController.clear();
          }),
          child: const Text('Reinitialiser'),
        ),
      ],
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
          if (snapshot.hasError) {
            return _buildMessageState(
              icon: Icons.cloud_off_rounded,
              title: 'Impossible de charger les notes',
              message: 'Tirez vers le bas pour reessayer.',
            );
          }
          final query = searchController.text.trim().toLowerCase();
          final notes = (snapshot.data ?? []).where((note) {
            final matchesSearch =
                query.isEmpty ||
                note.title.toLowerCase().contains(query) ||
                note.content.toLowerCase().contains(query);
            final matchesCategory =
                selectedCategoryId == null ||
                note.categoryId == selectedCategoryId;
            return matchesSearch && matchesCategory;
          }).toList();
          return notes.isEmpty ? _buildEmptyState() : _buildGroupedNotes(notes);
        },
      ),
    );
  }

  Widget _buildGroupedNotes(List<Note> notes) {
    final categories = <int?, List<Note>>{};
    for (final note in notes) {
      categories.putIfAbsent(note.categoryId, () => []).add(note);
    }
    final categoryList = categories.keys.toList()
      ..sort(
        (first, second) =>
            _categoryTitle(first).compareTo(_categoryTitle(second)),
      );

    return Column(
      children: [
        for (final categoryId in categoryList) ...[
          _buildGroupHeader(categoryId, categories[categoryId]!.length),
          ...categories[categoryId]!.map((note) => _buildNoteCard(note)),
          const SizedBox(height: 10),
        ],
      ],
    );
  }

  Widget _buildGroupHeader(int? categoryId, int count) {
    final color = _categoryColor(categoryId);
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, top: 4),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            _categoryTitle(categoryId),
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: ink,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$count note${count == 1 ? '' : 's'}',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          const Spacer(),
          const Text(
            'Plus recentes',
            style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: muted),
          ),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: muted),
        ],
      ),
    );
  }

  Widget _buildNoteCard(Note note) {
    final category = _findCategoryFromFuture(note.categoryId);
    final categoryColor = _categoryColor(note.categoryId);
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
                if (category != null) ...[
                  _buildNoteBadge(category.name, categoryColor),
                  const Spacer(),
                ] else
                  const Spacer(),
                IconButton(
                  tooltip: 'Modifier',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _openNoteEditorForNote(note),
                  icon: const Icon(Icons.edit_outlined, size: 18, color: muted),
                ),
                IconButton(
                  tooltip: 'Supprimer',
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _deleteNote(note),
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: muted,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    note.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: ink,
                    ),
                  ),
                ),
                if (note.isImportant)
                  const Icon(Icons.push_pin_outlined, size: 16, color: muted),
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
            Row(
              children: [
                Text(
                  _formatDateLabel(note.updatedAt),
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: Color(0xFF94A3B8),
                  ),
                ),
                const Spacer(),
                if (note.isImportant) ...[
                  const SizedBox(width: 8),
                  const Icon(Icons.push_pin_outlined, size: 13, color: muted),
                  const SizedBox(width: 3),
                  const Text(
                    'Epingle',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 10,
                      color: muted,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5,
            height: 5,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return _buildMessageState(
      icon: Icons.note_alt_outlined,
      title: searchController.text.isEmpty && selectedCategoryId == null
          ? 'Aucune note pour le moment'
          : 'Aucun resultat',
      message: searchController.text.isEmpty && selectedCategoryId == null
          ? 'Commencez par capturer une idee.'
          : 'Essayez une autre recherche ou categorie.',
    );
  }

  Widget _buildMessageState({
    required IconData icon,
    required String title,
    required String message,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 34, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: line),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: const Color(0xFF94A3B8)),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: ink,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13,
              color: muted,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshContent() async {
    final refreshedNotes = _loadNotes();
    final refreshedCategories = _loadCategories();
    refreshedCategories.then((loaded) {
      if (mounted) setState(() => categorySnapshot = loaded);
    });
    setState(() {
      notesFuture = refreshedNotes;
      categoriesFuture = refreshedCategories;
    });
    await Future.wait([refreshedNotes, refreshedCategories]);
  }

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

  Category? _findCategory(List<Category>? categories, int? id) {
    for (final category in categories ?? const <Category>[]) {
      if (category.id == id) return category;
    }
    return null;
  }

  Category? _findCategoryFromFuture(int? id) {
    return _findCategory(categorySnapshot, id);
  }

  String _categoryTitle(int? id) {
    return _findCategory(categorySnapshot, id)?.name ?? 'Sans categorie';
  }

  Color _categoryColor(int? id) {
    final category = _findCategory(categorySnapshot, id);
    return category == null ? muted : _parseColor(category.color);
  }

  Future<void> _deleteNote(Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      barrierColor: const Color(0x990F172A),
      builder: (dialogContext) {
        final category = _findCategoryFromFuture(note.categoryId);
        final categoryColor = _categoryColor(note.categoryId);
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 24,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFFE4E1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.delete_forever_rounded,
                      color: Color(0xFFB91C1C),
                      size: 25,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Supprimer cette note ?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      text:
                          'Etes-vous sur de vouloir supprimer definitivement\nla note ',
                      children: [
                        TextSpan(
                          text: '« ${note.title} »',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        const TextSpan(
                          text:
                              ' ?\nCette action est irreversible et supprimera\negalement les donnees du stockage local SQLite.',
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 11,
                      height: 1.55,
                      color: muted,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F3FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (category != null)
                              _buildNoteBadge(category.name, categoryColor),
                            const Spacer(),
                            Text(
                              _formatTime(note.updatedAt),
                              style: const TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 10,
                                color: muted,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          note.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            height: 1.4,
                            color: muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFFE9EDFF),
                              foregroundColor: muted,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Annuler',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: FilledButton.icon(
                            onPressed: () => Navigator.pop(dialogContext, true),
                            icon: const Icon(
                              Icons.delete_outline_rounded,
                              size: 16,
                            ),
                            label: const Text(
                              'Supprimer',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              backgroundColor: const Color(0xFFB91C1C),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    if (confirmed != true || note.id == null) return;
    final userId = SessionService.currentUser?.id;
    if (userId == null) return;
    await noteService.delete(note.id!, userId);
    if (mounted) {
      setState(() => notesFuture = _loadNotes());
    }
  }

  Color _parseColor(String? value) {
    if (value == null || value.isEmpty) return primary;
    final hex = value.replaceFirst('#', '');
    final normalized = hex.length == 6 ? 'FF$hex' : hex;
    return Color(int.tryParse(normalized, radix: 16) ?? primary.toARGB32());
  }

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  String _formatDateLabel(DateTime date) {
    final today = DateTime.now();
    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return "Aujourd'hui, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";
    }
    return _formatDate(date);
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
