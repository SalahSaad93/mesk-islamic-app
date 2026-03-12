import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/quran_provider.dart';
import '../providers/user_data_provider.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text('My Notes', style: AppTextStyles.cardTitle),
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: AppColors.divider, height: 1.0),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(notesProvider);
          await ref.read(notesProvider.future);
        },
        color: AppColors.primaryAccent,
        child: notesAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primaryAccent),
          ),
          error: (e, st) => Center(child: Text('Error: $e')),
          data: (notes) {
            if (notes.isEmpty) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  height: MediaQuery.of(context).size.height - 200,
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.note_alt_outlined,
                        size: 64,
                        color: AppColors.divider,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No notes yet',
                        style: AppTextStyles.cardTitle.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              itemCount: notes.length,
              padding: const EdgeInsets.symmetric(vertical: 16),
              physics: const AlwaysScrollableScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final note = notes[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Card(
                    color: AppColors.surface,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: AppColors.divider),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '${note.surahName}, Ayah ${note.ayahNumber}',
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryAccent,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.edit_outlined,
                                      size: 20,
                                    ),
                                    onPressed: () =>
                                        _editNote(context, ref, note),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                  ),
                                  const SizedBox(width: 12),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      size: 20,
                                    ),
                                    onPressed: () =>
                                        _deleteNote(context, ref, note),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    color: AppColors.secondaryAccent,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(note.text, style: AppTextStyles.bodyMedium),
                          const SizedBox(height: 12),
                          Text(
                            _formatDate(note.updatedAt),
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textTertiary,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  void _editNote(BuildContext context, WidgetRef ref, note) {
    final controller = TextEditingController(text: note.text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Note'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          maxLength: 2000,
          decoration: const InputDecoration(
            hintText: 'Enter your reflections...',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(notesProvider.notifier)
                  .saveNote(
                    note.copyWith(
                      text: controller.text,
                      updatedAt: DateTime.now(),
                    ),
                  );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteNote(BuildContext context, WidgetRef ref, note) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Note'),
        content: const Text('Are you sure you want to delete this note?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(notesProvider.notifier).deleteNote(note.id);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.secondaryAccent),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year} • ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
  }
}
