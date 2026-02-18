import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/garden_palette.dart';
import '../../home/models/daily_content.dart';
import '../../home/providers/home_providers.dart';
import '../services/admin_repository.dart';

class AdminInspirationScreen extends ConsumerStatefulWidget {
  const AdminInspirationScreen({super.key});

  @override
  ConsumerState<AdminInspirationScreen> createState() => _AdminInspirationScreenState();
}

class _AdminInspirationScreenState extends ConsumerState<AdminInspirationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _sourceController = TextEditingController();
  ContentType _selectedType = ContentType.quran;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _sourceController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(adminRepositoryProvider);
      await repo.createInspiration({
        'id': const Uuid().v4(),
        'type': _selectedType.name,
        'title': _titleController.text.trim(),
        'body': _bodyController.text.trim(),
        'source': _sourceController.text.trim(),
        'is_active': true, // New ones are active by default
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Inspiráció sikeresen hozzáadva!')),
        );
        _titleController.clear();
        _bodyController.clear();
        _sourceController.clear();
        ref.invalidate(inspirationsProvider);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hiba: $e'), backgroundColor: GardenPalette.errorRed),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final inspirationsAsync = ref.watch(inspirationsProvider);

    return Scaffold(
      backgroundColor: GardenPalette.obsidian,
      appBar: AppBar(
        title: Text('Inspirációk kezelése', style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Form Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Material(
              color: GardenPalette.midnightForest,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownMenu<ContentType>(
                              initialSelection: _selectedType,
                              width: double.infinity,
                              textStyle: const TextStyle(color: Colors.white),
                              inputDecorationTheme: const InputDecorationTheme(
                                filled: true,
                                fillColor: Colors.transparent,
                                labelStyle: TextStyle(color: Colors.grey),
                              ),
                              dropdownMenuEntries: ContentType.values.map((type) {
                                return DropdownMenuEntry<ContentType>(
                                  value: type,
                                  label: type.name.toUpperCase(),
                                );
                              }).toList(),
                              onSelected: (v) => setState(() => _selectedType = v!),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: TextFormField(
                              controller: _titleController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(labelText: 'Cím/Hivatkozás', labelStyle: TextStyle(color: Colors.grey)),
                              validator: (v) => v == null || v.isEmpty ? 'Keresünk egy címet' : null,
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: _bodyController,
                        maxLines: 3,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'Szöveg', labelStyle: TextStyle(color: Colors.grey)),
                        validator: (v) => v == null || v.isEmpty ? 'A tartalom nem lehet üres' : null,
                      ),
                      TextFormField(
                        controller: _sourceController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(labelText: 'Forrás', labelStyle: TextStyle(color: Colors.grey)),
                        validator: (v) => v == null || v.isEmpty ? 'Ki mondta?' : null,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: GardenPalette.emeraldTeal,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _isSubmitting 
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Hozzáadás & Aktiválás'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // List Section
          Expanded(
            child: inspirationsAsync.when(
              data: (items) => ListView.builder(
                itemCount: items.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isActive = item['is_active'] == true;
                  return Card(
                    color: GardenPalette.midnightForest.withValues(alpha: 0.5),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(item['title'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      subtitle: Text(item['body'], maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.grey)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isActive)
                            const Icon(Icons.check_circle, color: GardenPalette.emeraldTeal),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, color: GardenPalette.warningRed),
                            onPressed: () => _delete(item['id']),
                          ),
                        ],
                      ),
                      onTap: () => _toggleActive(item['id'], !isActive),
                    ),
                  );
                },
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Hiba: $e', style: const TextStyle(color: Colors.white))),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Törlés'),
        content: const Text('Biztosan törölni szeretnéd ezt az inspirációt?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Mégse')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Törlés', style: TextStyle(color: GardenPalette.warningRed))),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(adminRepositoryProvider).deleteInspiration(id);
      ref.invalidate(inspirationsProvider);
    }
  }

  Future<void> _toggleActive(String id, bool active) async {
    await ref.read(adminRepositoryProvider).updateInspiration(id, {'is_active': active});
    ref.invalidate(inspirationsProvider);
    ref.invalidate(dailyContentProvider);
  }
}
