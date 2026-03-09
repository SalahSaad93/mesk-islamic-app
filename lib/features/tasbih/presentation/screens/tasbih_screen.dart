import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/islamic_card.dart';

class TasbihScreen extends StatefulWidget {
  const TasbihScreen({super.key});

  @override
  State<TasbihScreen> createState() => _TasbihScreenState();
}

class _TasbihScreenState extends State<TasbihScreen>
    with SingleTickerProviderStateMixin {
  int _count = 0;
  int _target = 33;
  int _selectedDhikr = 0;
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
    if (_count >= _target) return;
    HapticFeedback.lightImpact();
    await _animController.forward();
    await _animController.reverse();
    setState(() {
      _count++;
      if (_count == _target) {
        HapticFeedback.heavyImpact();
        _showCompletionSnackBar();
      }
    });
  }

  void _reset() {
    setState(() => _count = 0);
  }

  void _showCompletionSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Mashallah! ${_dhikrList[_selectedDhikr].arabic} completed $_target times!',
          style: const TextStyle(fontFamily: 'Amiri'),
        ),
        backgroundColor: AppColors.primaryGreen,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = _target > 0 ? (_count / _target).clamp(0.0, 1.0) : 0.0;
    final dhikr = _dhikrList[_selectedDhikr];

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCounter(progress, dhikr),
                  const SizedBox(height: 32),
                  _buildDhikrText(dhikr),
                  const SizedBox(height: 32),
                  _buildDhikrSelector(),
                  const SizedBox(height: 24),
                  _buildControls(),
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
          Text('Tasbih Counter', style: AppTextStyles.headlineLarge),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.history_outlined,
                color: AppColors.textMedium),
            onPressed: _showHistorySheet,
          ),
        ],
      ),
    );
  }

  Widget _buildCounter(double progress, _DhikrItem dhikr) {
    return GestureDetector(
      onTap: _increment,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: SizedBox(
          width: 260,
          height: 260,
          child: CustomPaint(
            painter: _CounterRingPainter(
              progress: progress,
              primaryColor: AppColors.primaryGreen,
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
                      '$_count',
                      key: ValueKey(_count),
                      style: const TextStyle(
                        fontSize: 64,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                  Text(
                    '/ $_target',
                    style: AppTextStyles.bodyLarge
                        .copyWith(color: Colors.white70),
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
              color: AppColors.primaryGreen,
            ),
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            dhikr.transliteration,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildDhikrSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(_dhikrList.length, (i) {
            final isSelected = i == _selectedDhikr;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() {
                  _selectedDhikr = i;
                  _target = _dhikrList[i].target;
                  _count = 0;
                }),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primaryGreen
                        : AppColors.backgroundWhite,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primaryGreen
                          : AppColors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _dhikrList[i].arabic.split(' ').first,
                        style: AppTextStyles.arabicSmall.copyWith(
                          color: isSelected
                              ? Colors.white
                              : AppColors.textDark,
                          fontSize: 14,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      Text(
                        '${_dhikrList[i].target}x',
                        style: AppTextStyles.bodySmall.copyWith(
                          color:
                              isSelected ? Colors.white70 : AppColors.textLight,
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

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          onPressed: _reset,
          icon: const Icon(Icons.refresh, size: 18),
          label: const Text('Reset'),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.textMedium,
            side: const BorderSide(color: AppColors.border),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
        const SizedBox(width: 16),
        ElevatedButton.icon(
          onPressed: () => _saveSession(),
          icon: const Icon(Icons.save_outlined, size: 18),
          label: const Text('Save Session'),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ],
    );
  }

  void _showHistorySheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Session History', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 16),
            const Center(
              child: Text('No sessions yet',
                  style: TextStyle(color: AppColors.textLight)),
            ),
          ],
        ),
      ),
    );
  }

  void _saveSession() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Session saved: ${_dhikrList[_selectedDhikr].arabic} x $_count'),
        backgroundColor: AppColors.primaryGreen,
      ),
    );
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

    // Background circle (gradient fill)
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          primaryColor.withOpacity(0.9),
          primaryColor,
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bgPaint);

    // Track ring
    final trackPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius - 4, trackPaint);

    // Progress ring
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
