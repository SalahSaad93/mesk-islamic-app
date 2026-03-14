import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/tasbih_session.dart';
import '../providers/tasbih_provider.dart';

class TasbihScreen extends ConsumerStatefulWidget {
  const TasbihScreen({super.key});

  @override
  ConsumerState<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends ConsumerState<TasbihScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  final List<_DhikrItem> _dhikrList = const [
    _DhikrItem('سُبْحَانَ اللَّهِ', 'SubhanAllah', 33),
    _DhikrItem('الْحَمْدُ لِلَّهِ', 'Alhamdulillah', 33),
    _DhikrItem('اللَّهُ أَكْبَرُ', 'Allahu Akbar', 34),
    _DhikrItem('لَا إِلَهَ إِلَّا اللَّهُ', 'La Ilaha IllAllah', 100),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _increment() async {
    final tasbih = ref.read(tasbihProvider);
    if (tasbih.count >= tasbih.target) return;
    HapticFeedback.lightImpact();
    await _animController.forward();
    await _animController.reverse();
    ref.read(tasbihProvider.notifier).increment();
    final updated = ref.read(tasbihProvider);
    if (updated.count == updated.target) {
      HapticFeedback.heavyImpact();
      _showCompletionSnackBar(updated);
    }
  }

  void _showCompletionSnackBar(TasbihState tasbih) {
    final dhikr = _dhikrList[tasbih.selectedDhikrIndex];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Mashallah! ${dhikr.arabic} completed ${tasbih.target} times!',
          style: const TextStyle(fontFamily: 'Amiri'),
        ),
        backgroundColor: AppColors.primaryAccent,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final tasbih = ref.watch(tasbihProvider);
    final progress = tasbih.target > 0
        ? (tasbih.count / tasbih.target).clamp(0.0, 1.0)
        : 0.0;
    final dhikr = _dhikrList[tasbih.selectedDhikrIndex];

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCounter(progress, tasbih),
                  const SizedBox(height: 32),
                  _buildDhikrText(dhikr),
                  const SizedBox(height: 32),
                  _buildDhikrSelector(tasbih),
                  const SizedBox(height: 24),
                  _buildControls(tasbih, dhikr),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          Text('Tasbih Counter', style: AppTextStyles.sectionTitle),
          const Spacer(),
          IconButton(
            icon: const Icon(
              Icons.history_outlined,
              color: AppColors.textSecondary,
            ),
            onPressed: _showHistorySheet,
          ),
        ],
      ),
    );
  }

  Widget _buildCounter(double progress, TasbihState tasbih) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 360;
    final counterSize = isCompact ? 200.0 : 260.0;
    
    return GestureDetector(
      onTap: _increment,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: SizedBox(
          width: counterSize,
          height: counterSize,
          child: CustomPaint(
            painter: _CounterRingPainter(
              progress: progress,
              primaryColor: AppColors.primaryAccent,
              goldColor: AppColors.goldAccent,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, anim) =>
                        ScaleTransition(scale: anim, child: child),
                    child: Text(
                      '${tasbih.count}',
                      key: ValueKey(tasbih.count),
                      style: TextStyle(
                        fontSize: isCompact ? 48 : 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  Text(
                    '/ ${tasbih.target}',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDhikrText(_DhikrItem dhikr) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          Text(
            dhikr.arabic,
            style: AppTextStyles.arabicLarge.copyWith(
              color: AppColors.primaryAccent,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(dhikr.transliteration, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildDhikrSelector(TasbihState tasbih) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_dhikrList.length, (i) {
            final isSelected = i == tasbih.selectedDhikrIndex;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => ref
                    .read(tasbihProvider.notifier)
                    .selectDhikr(i, _dhikrList[i].target),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryAccent
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryAccent
                          : AppColors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _dhikrList[i].arabic.split(' ').first,
                        style: AppTextStyles.arabicSmall.copyWith(
                          color:
                              isSelected ? Colors.white : AppColors.textPrimary,
                          fontSize: 14,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      Text(
                        '${_dhikrList[i].target}x',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isSelected
                              ? Colors.white70
                              : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildControls(TasbihState tasbih, _DhikrItem dhikr) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: () => ref.read(tasbihProvider.notifier).reset(),
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Reset'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textSecondary,
            side: const BorderSide(color: AppColors.border),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: tasbih.count > 0
              ? () {
                  ref
                      .read(tasbihProvider.notifier)
                      .saveSession(
                        arabic: dhikr.arabic,
                        transliteration: dhikr.transliteration,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Session saved successfully!'),
                      backgroundColor: AppColors.primaryAccent,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              : null,
          icon: const Icon(Icons.save_outlined, size: 18),
          label: const Text('Save Session'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryAccent,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.border,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  void _showHistorySheet() {
    final sessions = ref.read(tasbihProvider).sessions;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.55,
        maxChildSize: 0.9,
        minChildSize: 0.3,
        builder: (_, controller) => Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text('Session History', style: AppTextStyles.headlineMedium),
                  const Spacer(),
                  Text(
                    '${sessions.length} sessions',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (sessions.isEmpty)
                const Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 48,
                          color: AppColors.textTertiary,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No sessions yet.\nTap "Save Session" after counting.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.textTertiary),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Expanded(
                  child: ListView.separated(
                    controller: controller,
                    itemCount: sessions.length,
                    separatorBuilder: (_, i) => const Divider(height: 1),
                    itemBuilder: (_, i) => _buildSessionTile(sessions[i]),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSessionTile(TasbihSession session) {
    final dateStr = _formatDate(session.timestamp);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: CircleAvatar(
        backgroundColor: AppColors.primaryAccent.withValues(alpha: 0.1),
        child: Text(
          '${session.count}',
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.primaryAccent,
            fontSize: 13,
          ),
        ),
      ),
      title: Text(
        session.arabic,
        style: AppTextStyles.arabicSmall.copyWith(fontSize: 16),
        textDirection: TextDirection.rtl,
      ),
      subtitle: Text(session.transliteration, style: AppTextStyles.bodySmall),
      trailing: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${session.count}/${session.target}',
            style: AppTextStyles.labelSmall,
          ),
          Text(dateStr, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _DhikrItem {
  final String arabic;
  final String transliteration;
  final int target;
  const _DhikrItem(this.arabic, this.transliteration, this.target);
}

class _CounterRingPainter extends CustomPainter {
  final double progress;
  final Color primaryColor;
  final Color goldColor;

  _CounterRingPainter({
    required this.progress,
    required this.primaryColor,
    required this.goldColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [primaryColor.withValues(alpha: 0.9), primaryColor],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bgPaint);

    final trackPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius - 4, trackPaint);

    final progressPaint = Paint()
      ..color = goldColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 4),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CounterRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
