import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../providers/quran_khatma_provider.dart';

class KhatmaProgressWidget extends ConsumerWidget {
  const KhatmaProgressWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final khatmaState = ref.watch(khatmaProvider);

    if (khatmaState.highestPage == 0 && !khatmaState.isCompleted) {
      return const SizedBox.shrink();
    }

    return Semantics(
      label: 'Khatma progress ${khatmaState.percentage.toStringAsFixed(0)} percent',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 16),
          if (khatmaState.isCompleted) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryAccent, Color(0xFFFF6B6B)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryAccent.withOpacity(0.4),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.celebration, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Khatma Complete! 🎉',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.refresh, color: Colors.white, size: 20),
                    onPressed: () async {
                      await ref.read(khatmaProvider.notifier).resetKhatma();
                    },
                    tooltip: 'Start new Khatma',
                  ),
                ],
              ),
            ),
          ] else ...[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timeline,
                      color: AppColors.primaryAccent,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${khatmaState.percentage.toStringAsFixed(1)}%',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: khatmaState.percentage / 100,
                    minHeight: 6,
                    backgroundColor: AppColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        khatmaState.percentage >= 50
                            ? AppColors.primaryAccent
                            : AppColors.secondaryAccent,
                      ),
                  ),
                ),
                if (khatmaState.highestPage > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${khatmaState.highestPage} / 604 pages',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ],
          const Spacer(),
        ],
      ),
    );
  }
}
