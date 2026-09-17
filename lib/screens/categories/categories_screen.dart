import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../services/category_service.dart';
import '../../services/session_service.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  static const background = Color(0xFFF8FAFC);
  static const ink = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const primary = Color(0xFF2563EB);
  static const line = Color(0xFFE2E8F0);

  final service = CategoryService();
  late Future<List<Category>> categoriesFuture;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  void _refresh() {
    final userId = SessionService.currentUser?.id;
    categoriesFuture = userId == null
        ? Future.value(const [])
        : service.getAll(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        title: const Text(
          'Categories',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: ink,
          ),
        ),
      ),
      body: FutureBuilder<List<Category>>(
        future: categoriesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            );
          }
          final categories = snapshot.data ?? const <Category>[];
          if (categories.isEmpty) return _buildEmptyState();
          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
            itemCount: categories.length,
            separatorBuilder: (_, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) =>
                _buildCategoryTile(categories[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'categories-add-category',
        onPressed: _showCategoryDialog,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add_rounded),
        label: const Text(
          'Ajouter',
          style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  Widget _buildCategoryTile(Category category) {
    final color = _parseColor(category.color);
    return ListTile(
      tileColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: line),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: CircleAvatar(
        radius: 20,
        backgroundColor: color.withValues(alpha: 0.14),
        child: Icon(Icons.folder_rounded, color: color, size: 21),
      ),
      title: Text(
        category.name,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: ink,
        ),
      ),
      subtitle: const Text(
        'Categorie personnelle',
        style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: muted),
      ),
      trailing: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'delete') _delete(category);
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'delete', child: Text('Supprimer')),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.folder_open_rounded,
              size: 48,
              color: Color(0xFF94A3B8),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aucune categorie',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: ink,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Creez des categories pour organiser vos notes.',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: 'Inter', fontSize: 14, color: muted),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _showCategoryDialog,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Creer une categorie'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showCategoryDialog() async {
    final name = await showDialog<String>(
      context: context,
      builder: (_) => const _CategoryDialog(),
    );
    final userId = SessionService.currentUser?.id;
    if (name == null || name.isEmpty || userId == null) return;
    await service.create(
      Category(userId: userId, name: name, color: '#2563EB'),
    );
    if (mounted) setState(_refresh);
  }

  Future<void> _delete(Category category) async {
    final userId = SessionService.currentUser?.id;
    if (category.id == null || userId == null) return;
    await service.delete(category.id!, userId);
    if (mounted) setState(_refresh);
  }

  Color _parseColor(String? value) {
    if (value == null) return primary;
    final hex = value.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}

class _CategoryDialog extends StatefulWidget {
  const _CategoryDialog();

  @override
  State<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<_CategoryDialog> {
  final controller = TextEditingController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouvelle categorie'),
      content: TextField(
        controller: controller,
        autofocus: true,
        textInputAction: TextInputAction.done,
        onSubmitted: (_) => _submit(),
        decoration: const InputDecoration(
          labelText: 'Nom',
          hintText: 'Ex: Travail',
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Ajouter')),
      ],
    );
  }

  void _submit() {
    final name = controller.text.trim();
    if (name.isNotEmpty) {
      Navigator.pop(context, name);
    }
  }
}
