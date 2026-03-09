import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/islamic_card.dart';
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

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          widget.thikr.category == 'morning'
              ? 'Morning Athkar'
              : 'Evening Athkar',
        ),
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(20),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.thikr.category == 'morning'
                  ? 'Start your day with these blessed supplications'
                  : 'End your day with protection and gratitude',
              style: AppTextStyles.bodySmall,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Counter circle
            IslamicCard(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      children: [
                        SizedBox.expand(
                          child: CircularProgressIndicator(
                            value: progress,
                            strokeWidth: 6,
                            backgroundColor: AppColors.border,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              isComplete
                                  ? AppColors.primaryGreen
                                  : AppColors.primaryGreen,
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '$_count',
                                style: GoogleFontsWorkaround.counter,
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
                          foregroundColor: AppColors.textMedium,
                          side: const BorderSide(color: AppColors.border),
                        ),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton.icon(
                        onPressed: _showSetTargetDialog,
                        icon: const Icon(Icons.tune, size: 16),
                        label: const Text('Set Target'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.textMedium,
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
            IslamicCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Text('Dhikr Text',
                          style: AppTextStyles.headlineSmall),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.volume_up_outlined,
                            color: AppColors.textMedium),
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.play_circle_outline,
                            color: AppColors.primaryGreen),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.thikr.arabic,
                      style: AppTextStyles.arabicBody,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _infoSection('Translation',
                      '"${widget.thikr.translation}"',
                      isItalic: true),
                  const SizedBox(height: 12),
                  _infoSection('Transliteration',
                      widget.thikr.transliteration),
                  const SizedBox(height: 12),
                  _infoSection('Source', widget.thikr.source,
                      valueColor: AppColors.textMedium),
                  const SizedBox(height: 12),
                  _infoSection('Reference', widget.thikr.reference,
                      valueColor: AppColors.textLight),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _increment,
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _infoSection(String label, String value,
      {bool isItalic = false, Color? valueColor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: AppTextStyles.labelLarge
                .copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
            color: valueColor ?? AppColors.textMedium,
          ),
        ),
      ],
    );
  }

  void _showSetTargetDialog() {
    final controller =
        TextEditingController(text: _target.toString());
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
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _target = int.tryParse(controller.text) ?? _target;
              });
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen),
            child:
                const Text('Set', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Workaround to avoid importing google_fonts in this file
class GoogleFontsWorkaround {
  static final counter = TextStyle(
    fontSize: 44,
    fontWeight: FontWeight.bold,
    color: AppColors.primaryGreen,
    fontFamily: 'Roboto',
  );
}
