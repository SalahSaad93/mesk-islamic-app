import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/clay_shadows.dart';
import '../../../../core/widgets/clay_card.dart';
import '../../domain/entities/thikr_entity.dart';
import '../providers/athkar_provider.dart';
import '../widgets/celebration_animation.dart';
import 'athkar_detail_screen.dart';

class AthkarListScreen extends ConsumerStatefulWidget {
  final String category;
  final String title;
  const AthkarListScreen({
    super.key,
    required this.category,
    required this.title,
  });

  @override
  ConsumerState<AthkarListScreen> createState() => _AthkarListScreenState();
}

class _AthkarListScreenState extends ConsumerState<AthkarListScreen> {
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final athkarAsync = ref.watch(athkarByCategoryProvider(widget.category));
    final progressNotifier = ref.read(
      athkarProgressProvider(widget.category).notifier,
    );
    final progress = ref.watch(athkarProgressProvider(widget.category));

    final isAllDone = ref.watch(athkarCompletionProvider(widget.category));

    ref.listen(athkarCompletionProvider(widget.category), (previous, next) {
      if (next == true && previous != true) {
        _confettiController.play();
      }
    });

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppColors.surface,
          appBar: AppBar(
            title: Text(widget.title),
            backgroundColor: AppColors.surface,
            elevation: 0,
          ),
          body: athkarAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primaryAccent),
            ),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (athkar) {
              progressNotifier.initProgress(athkar);
              final completedCount = athkar
                  .where((t) => progressNotifier.isDone(t.id))
                  .length;
              final totalCount = athkar.length;

              return Column(
                children: [
                  _buildProgressBar(completedCount, totalCount),
                  Expanded(
                    child: RefreshIndicator(
                      color: AppColors.primaryAccent,
                      onRefresh: () async => progressNotifier.reset(athkar),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: athkar.length,
                        itemBuilder: (context, index) {
                          final thikr = athkar[index];
                          final remaining =
                              progress[thikr.id] ?? thikr.repeatCount;
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
                  ),
                ],
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirection: pi / 2, // falls straight down
            maxBlastForce: 5,
            minBlastForce: 2,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            gravity: 1,
          ),
        ),
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Center(child: CelebrationAnimation(isVisible: isAllDone)),
        ),
      ],
    );
  }

  Widget _buildProgressBar(int completed, int total) {
    final percent = total > 0 ? completed / total : 0.0;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      color: AppColors.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Progress', style: AppTextStyles.labelSmall),
              Text(
                '$completed / $total completed',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.primaryAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              backgroundColor: AppColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryAccent,
              ),
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
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 360;
    
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: ClayCard(
          shadowLevel: ClayShadowLevel.surface,
          backgroundColor: isDone
              ? AppColors.primaryAccent.withValues(alpha: 0.05)
              : AppColors.surface,
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
                            ? AppColors.textTertiary
                            : AppColors.textPrimary,
                        fontSize: isCompact ? 18 : 20,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      maxLines: null,
                      softWrap: true,
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
                  color: AppColors.textSecondary,
                ),
                maxLines: isCompact ? 2 : 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 6),
              Text(
                thikr.source,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textTertiary,
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
          color: AppColors.primaryAccent,
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
        border: Border.all(color: AppColors.primaryAccent, width: 2),
      ),
      child: Center(
        child: Text(
          '$remaining',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.primaryAccent,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
