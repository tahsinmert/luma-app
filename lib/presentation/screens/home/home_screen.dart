import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/glass_card.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../domain/entities/vault_entry.dart';
import '../../../domain/entities/entry_type.dart';
import '../../providers/vault_providers.dart';
import '../entry_detail/entry_detail_screen.dart';
import '../search/search_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(entriesProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundPrimary,
              AppColors.backgroundSecondary,
            ],
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.pagePadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Your Vault',
                                style: AppTypography.largeTitle,
                              ),
                              const SizedBox(height: AppSpacing.xxs),
                              Text(
                                DateFormat('EEEE, MMMM d').format(DateTime.now()),
                                style: AppTypography.subheadline,
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.search, size: 28),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const SearchScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      
                      // Primary CTA
                      PrimaryButton(
                        label: 'New Entry',
                        icon: Icons.add,
                        onPressed: () => _showNewEntryOptions(context, ref),
                      ),
                    ],
                  ),
                ),
              ),
              
              // Entries
              entriesAsync.when(
                data: (entries) {
                  if (entries.isEmpty) {
                    return SliverFillRemaining(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.auto_awesome_outlined,
                              size: 80,
                              color: AppColors.softGray,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              'Your vault is empty',
                              style: AppTypography.title2.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Text(
                              'Start by creating your first entry',
                              style: AppTypography.body.copyWith(
                                color: AppColors.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverPadding(
                    padding: const EdgeInsets.all(AppSpacing.pagePadding),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final entry = entries[index];
                          return _EntryCard(
                            entry: entry,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EntryDetailScreen(entry: entry),
                                ),
                              );
                            },
                          );
                        },
                        childCount: entries.length,
                      ),
                    ),
                  );
                },
                loading: () => const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation(AppColors.primaryBlue),
                    ),
                  ),
                ),
                error: (error, stack) => SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Error: $error',
                      style: AppTypography.body.copyWith(color: AppColors.error),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showNewEntryOptions(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLg)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EntryTypeOption(
              icon: Icons.edit_outlined,
              title: 'Journal Entry',
              onTap: () {
                Navigator.pop(context);
                _createEntry(context, ref, EntryType.journal);
              },
            ),
            _EntryTypeOption(
              icon: Icons.mic_outlined,
              title: 'Voice Note',
              onTap: () {
                Navigator.pop(context);
                _createEntry(context, ref, EntryType.voice);
              },
            ),
            _EntryTypeOption(
              icon: Icons.description_outlined,
              title: 'Document',
              onTap: () {
                Navigator.pop(context);
                _createEntry(context, ref, EntryType.document);
              },
            ),
            _EntryTypeOption(
              icon: Icons.photo_outlined,
              title: 'Photo',
              onTap: () {
                Navigator.pop(context);
                _createEntry(context, ref, EntryType.photo);
              },
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }

  void _createEntry(BuildContext context, WidgetRef ref, EntryType type) {
    final newEntry = VaultEntry(
      id: const Uuid().v4(),
      type: type,
      title: '',
      content: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EntryDetailScreen(entry: newEntry, isNew: true),
      ),
    );
  }
}

class _EntryCard extends StatelessWidget {
  final VaultEntry entry;
  final VoidCallback onTap;

  const _EntryCard({required this.entry, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
                child: Text(
                  entry.type.emoji,
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.title.isEmpty ? 'Untitled' : entry.title,
                      style: AppTypography.headline,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      DateFormat('MMM d, y · HH:mm').format(entry.createdAt),
                      style: AppTypography.caption1.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (entry.content.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              entry.content,
              style: AppTypography.body.copyWith(
                color: AppColors.textSecondary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (entry.tags.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Wrap(
              spacing: AppSpacing.xs,
              children: entry.tags.take(3).map((tag) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.softGray.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    tag,
                    style: AppTypography.caption2,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }
}

class _EntryTypeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _EntryTypeOption({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryBlue),
      title: Text(title, style: AppTypography.headline),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
    );
  }
}
