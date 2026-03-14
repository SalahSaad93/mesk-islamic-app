import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../domain/entities/reading_preferences_entity.dart';

class ReadingModeToggle extends StatelessWidget {
  final ReadingMode currentMode;
  final ValueChanged<ReadingMode> onModeChanged;

  const ReadingModeToggle({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Switch reading mode',
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildOption(
              mode: ReadingMode.fullQuranMode,
              label: 'Mushaf',
              icon: Icons.menu_book_outlined,
            ),
            _buildOption(
              mode: ReadingMode.verseMode,
              label: 'Verse',
              icon: Icons.format_quote,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required ReadingMode mode,
    required String label,
    required IconData icon,
  }) {
    final isSelected = currentMode == mode;

    return GestureDetector(
      onTap: () => onModeChanged(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryAccent : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : AppColors.textSecondary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Colors.white : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
