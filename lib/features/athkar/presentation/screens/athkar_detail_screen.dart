import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/clay_shadows.dart';
import '../../../../core/widgets/clay_card.dart';
import '../../domain/entities/thikr_entity.dart';

class AthkarDetailScreen extends StatefulWidget {
  final ThikrEntity thikr;
  const AthkarDetailScreen({super.key, required this.thikr});

  @override
  State<AthkarDetailScreen> createState() => _AthkarDetailScreenState();
}

class _AthkarDetailScreenState extends State<AthkarDetailScreen> {
  int _count = 0;
  int _target = 0;

  @override
  void initState() {
    super.initState();
    _target = widget.thikr.repeatCount;
  }

  void _increment() {
    HapticFeedback.lightImpact();
    if (_count < _target) {
      setState(() => _count++);
    }
  }

  void _reset() {
    setState(() => _count = 0);
  }

    @override
  Widget build(BuildContext context) {
    final progress = _target > 0 ? _count / _target : 0.0;
    final isComplete = _count >= _target;
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 360;
    final counterSize = isCompact ? 120.0 : 140.0;
    final titleFontSize = isCompact ? 36.0 : 44.0;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          widget.thikr.category == 'morning'
              ? 'Morning Athkar'
              : 'Evening Athkar',
          style: TextStyle(fontSize: isCompact ? 18.0 : 20.0),
        ),
        backgroundColor: AppColors.surface,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.thikr.category == 'morning'
                  ? 'Start your day with these blessed supplications'
                  : 'End your day with protection and gratitude',
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: isCompact ? 12 : 14,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Counter circle
            ClayCard(
              shadowLevel: ClayShadowLevel.surface,
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(
                    width: counterSize,
                    height: counterSize,
                    child: Stack(
                      children: [
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 6,
                            backgroundColor: AppColors.border,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isComplete
                                  ? AppColors.primaryAccent
                                  : AppColors.primaryAccent,
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$_count',
                                style: AppTextStyles.sectionTitle.copyWith(
                                  fontSize: titleFontSize,
                                  color: AppColors.primaryAccent,
                                ),
                              ),
                              Text(
                                '/ $_target',
                                style: AppTextStyles.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        onPressed: _reset,
                        icon: const Icon(Icons.refresh, size: 16),
                        label: const Text('Reset'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.border),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: _showSetTargetDialog,
                        icon: const Icon(Icons.tune, size: 16),
                        label: const Text('Set Target'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          side: const BorderSide(color: AppColors.border),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Dhikr card
            ClayCard(
              shadowLevel: ClayShadowLevel.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text('Dhikr Text', style: AppTextStyles.cardTitle),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(
                          Icons.volume_up_outlined,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.play_circle_outline,
                          color: AppColors.primaryAccent,
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccent.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.thikr.arabic,
                      style: AppTextStyles.arabicBody.copyWith(
                        fontSize: isCompact ? 24 : 28,
                      ),
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _infoSection(
                    'Translation',
                    '"${widget.thikr.translation}"',
                    isItalic: true,
                  ),
                  const SizedBox(height: 12),
                  _infoSection('Transliteration', widget.thikr.transliteration),
                  const SizedBox(height: 12),
                  _infoSection(
                    'Source',
                    widget.thikr.source,
                    valueColor: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 12),
                  _infoSection(
                    'Reference',
                    widget.thikr.reference,
                    valueColor: AppColors.textTertiary,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        backgroundColor: AppColors.primaryAccent,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _infoSection(
    String label,
    String value, {
    bool isItalic = false,
    Color? valueColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            color: valueColor ?? AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  void _showSetTargetDialog() {
    final controller = TextEditingController(text: _target.toString());
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Set Target'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Target count'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _target = int.tryParse(controller.text) ?? _target;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryAccent,
            ),
            child: const Text('Set', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
