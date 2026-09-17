import 'package:flutter/material.dart';

import '../../models/category.dart';
import '../../models/note.dart';
import '../../services/category_service.dart';
import '../../services/note_service.dart';
import '../../services/session_service.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({this.note, super.key});

  final Note? note;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  static const background = Color(0xFFF8FAFC);
  static const ink = Color(0xFF0F172A);
  static const muted = Color(0xFF64748B);
  static const primary = Color(0xFF2563EB);
  static const line = Color(0xFFE2E8F0);

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final noteService = NoteService();
  final categoryService = CategoryService();
  late Future<List<Category>> categoriesFuture;
  int? selectedCategoryId;
  bool isImportant = false;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    final note = widget.note;
    titleController.text = note?.title ?? '';
    contentController.text = note?.content ?? '';
    selectedCategoryId = note?.categoryId;
    isImportant = note?.isImportant ?? false;
    categoriesFuture = _loadCategories();
  }

  Future<List<Category>> _loadCategories() {
    final userId = SessionService.currentUser?.id;
    return userId == null
        ? Future.value(const [])
        : categoryService.getAll(userId);
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(
          widget.note == null ? 'Nouvelle note' : 'Modifier la note',
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: ink,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() => isImportant = !isImportant),
            icon: Icon(
              isImportant ? Icons.push_pin_rounded : Icons.push_pin_outlined,
              color: isImportant ? primary : muted,
            ),
          ),
        ],
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
          children: [
            TextFormField(
              controller: titleController,
              textInputAction: TextInputAction.next,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: ink,
              ),
              decoration: const InputDecoration(
                hintText: 'Titre de la note',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF94A3B8),
                ),
                border: InputBorder.none,
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Ajoutez un titre'
                  : null,
            ),
            const Divider(height: 20, color: line),
            TextFormField(
              controller: contentController,
              minLines: 12,
              maxLines: null,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                height: 1.55,
                color: ink,
              ),
              decoration: const InputDecoration(
                hintText: 'Commencez a ecrire...',
                hintStyle: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  color: Color(0xFF94A3B8),
                ),
                border: InputBorder.none,
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Ajoutez du contenu'
                  : null,
            ),
            const SizedBox(height: 20),
            _buildCategorySelector(),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: FilledButton.icon(
                onPressed: isSaving ? null : _save,
                icon: isSaving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.check_rounded),
                label: Text(
                  isSaving ? 'Enregistrement...' : 'Enregistrer',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return FutureBuilder<List<Category>>(
      future: categoriesFuture,
      builder: (context, snapshot) {
        final categories = snapshot.data ?? const <Category>[];
        return DropdownButtonFormField<int?>(
          initialValue: selectedCategoryId,
          decoration: InputDecoration(
            labelText: 'Categorie',
            prefixIcon: const Icon(Icons.folder_outlined, color: muted),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: line),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: line),
            ),
          ),
          items: [
            const DropdownMenuItem<int?>(
              value: null,
              child: Text('Sans categorie'),
            ),
            ...categories.map(
              (category) => DropdownMenuItem<int?>(
                value: category.id,
                child: Text(category.name),
              ),
            ),
          ],
          onChanged: (value) => setState(() => selectedCategoryId = value),
        );
      },
    );
  }

  Future<void> _save() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    final user = SessionService.currentUser;
    if (user?.id == null) return;
    setState(() => isSaving = true);
    final now = DateTime.now();
    final note = Note(
      id: widget.note?.id,
      userId: user!.id!,
      categoryId: selectedCategoryId,
      title: titleController.text.trim(),
      content: contentController.text.trim(),
      isImportant: isImportant,
      createdAt: widget.note?.createdAt ?? now,
      updatedAt: now,
    );
    try {
      if (widget.note == null) {
        await noteService.create(note);
      } else {
        await noteService.update(note);
      }
      if (mounted) Navigator.pop(context, true);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible d enregistrer la note.')),
        );
      }
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }
}
