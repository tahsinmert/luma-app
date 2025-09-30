import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../domain/entities/vault_entry.dart';
import '../../providers/vault_providers.dart';
import 'package:intl/intl.dart';

class EntryDetailScreen extends ConsumerStatefulWidget {
  final VaultEntry entry;
  final bool isNew;

  const EntryDetailScreen({
    super.key,
    required this.entry,
    this.isNew = false,
  });

  @override
  ConsumerState<EntryDetailScreen> createState() => _EntryDetailScreenState();
}

class _EntryDetailScreenState extends ConsumerState<EntryDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.entry.title);
    _contentController = TextEditingController(text: widget.entry.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _saveEntry() async {
    setState(() => _isSaving = true);

    final updatedEntry = widget.entry.copyWith(
      title: _titleController.text,
      content: _contentController.text,
      updatedAt: DateTime.now(),
    );

    final repository = ref.read(vaultRepositoryProvider);
    
    try {
      if (widget.isNew) {
        await repository.addEntry(updatedEntry);
      } else {
        await repository.updateEntry(updatedEntry);
      }

      // Refresh entries list
      ref.invalidate(entriesProvider);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving entry: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (_isSaving)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(AppColors.primaryBlue),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _saveEntry,
              child: Text(
                'Save',
                style: AppTypography.headline.copyWith(
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.pagePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Entry type badge
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBlue.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(widget.entry.type.emoji),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          widget.entry.type.displayName,
                          style: AppTypography.footnote.copyWith(
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Text(
                    DateFormat('MMM d, y · HH:mm').format(widget.entry.createdAt),
                    style: AppTypography.caption1.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Title field
              TextField(
                controller: _titleController,
                style: AppTypography.largeTitle,
                decoration: const InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(color: AppColors.textTertiary),
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              // Content field
              TextField(
                controller: _contentController,
                style: AppTypography.body,
                decoration: const InputDecoration(
                  hintText: 'Start writing...',
                  hintStyle: TextStyle(color: AppColors.textTertiary),
                  border: InputBorder.none,
                ),
                maxLines: null,
                minLines: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
