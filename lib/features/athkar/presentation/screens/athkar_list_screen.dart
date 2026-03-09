import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/islamic_card.dart';
import '../providers/athkar_provider.dart';
import '../../domain/entities/thikr_entity.dart';
import 'athkar_detail_screen.dart';

class AthkarListScreen extends ConsumerWidget {
  final String category;
  const AthkarListScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final athkarAsync = category == 'morning'
        ? ref.watch(morningAthkarProvider)
        : ref.watch(eveningAthkarProvider);

    final progressNotifier = category == 'morning'
        ? ref.read(morningProgressProvider.notifier)
        : ref.read(eveningProgressProvider.notifier);

    final progress = category == 'morning'
        ? ref.watch(morningProgressProvider)
        : ref.watch(eveningProgressProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(category == 'morning' ? 'Morning Athkar' : 'Evening Athkar'),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
      ),
      body: athkarAsync.when(
        loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primaryGreen)),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (athkar) {
          progressNotifier.initProgress(athkar);
          final completedCount =
              athkar.where((t) => progressNotifier.isDone(t.id)).length;
          final totalCount = athkar.length;

          return Column(
            children: [
              _buildProgressBar(completedCount, totalCount),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: athkar.length,
                  itemBuilder: (context, index) {
                    final thikr = athkar[index];
                    final remaining = progress[thikr.id] ?? thikr.repeatCount;
                    final isDone = remaining == 0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _ThikrCard(
                        thikr: thikr,
                        remaining: remaining,
                        isDone: isDone,
                        onTap: () {
                          if (!isDone) {
                            progressNotifier.decrement(thikr.id);
                          }
                        },
                        onLongPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AthkarDetailScreen(thikr: thikr),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressBar(int completed, int total) {
    final percent = total > 0 ? completed / total : 0.0;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      color: AppColors.backgroundWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progress', style: AppTextStyles.labelMedium),
              Text('$completed / $total completed',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.primaryGreen)),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: AppColors.border,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ThikrCard extends StatelessWidget {
  final ThikrEntity thikr;
  final int remaining;
  final bool isDone;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _ThikrCard({
    required this.thikr,
    required this.remaining,
    required this.isDone,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: IslamicCard(
          backgroundColor:
              isDone ? AppColors.primaryGreen.withOpacity(0.05) : null,
          borderColor:
              isDone ? AppColors.primaryGreen.withOpacity(0.3) : AppColors.border,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      thikr.arabic,
                      style: AppTextStyles.arabicBody.copyWith(
                        color: isDone
                            ? AppColors.textLight
                            : AppColors.textDark,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildCounter(),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                thikr.translation,
                style: AppTextStyles.bodySmall.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.textMedium,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                thikr.source,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCounter() {
    if (isDone) {
      return Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.primaryGreen,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, color: Colors.white, size: 20),
      );
    }

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryGreen,
          width: 2,
        ),
      ),
      child: Center(
        child: Text(
          '$remaining',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.primaryGreen,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
