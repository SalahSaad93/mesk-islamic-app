import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/islamic_card.dart';
import '../providers/athkar_provider.dart';
import 'athkar_list_screen.dart';

class AthkarHomeScreen extends ConsumerWidget {
  const AthkarHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(child: _buildCategories(context)),
            SliverToBoxAdapter(child: _buildAthkarList(context)),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Athkar & Duas', style: AppTextStyles.headlineLarge),
          Text('Supplications and remembrance of Allah',
              style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search athkar...',
          prefixIcon: const Icon(Icons.search, color: AppColors.textLight),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    final categories = [
      ('All', true),
      ('Morning', false),
      ('Evening', false),
      ('After Prayer', false),
      ('Night', false),
      ('General', false),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories.map((cat) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(cat.$1),
                selected: cat.$2,
                onSelected: (_) {},
                selectedColor: AppColors.primaryGreen,
                labelStyle: TextStyle(
                  color: cat.$2 ? Colors.white : AppColors.textMedium,
                  fontSize: 13,
                  fontWeight:
                      cat.$2 ? FontWeight.w600 : FontWeight.normal,
                ),
                backgroundColor: AppColors.backgroundWhite,
                side: const BorderSide(color: AppColors.border),
                checkmarkColor: Colors.white,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildAthkarList(BuildContext context) {
    final items = [
      _AthkarCategory(
        title: 'Morning Athkar',
        subtitle: 'Start your day with these blessed supplications',
        icon: Icons.wb_sunny_outlined,
        iconColor: const Color(0xFFF59E0B),
        duration: '10 min',
        count: 15,
        tag: 'morning',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AthkarListScreen(category: 'morning'),
          ),
        ),
      ),
      _AthkarCategory(
        title: 'Evening Athkar',
        subtitle: 'End your day with protection and gratitude',
        icon: Icons.nightlight_outlined,
        iconColor: const Color(0xFF6366F1),
        duration: '8 min',
        count: 12,
        tag: 'evening',
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AthkarListScreen(category: 'evening'),
          ),
        ),
      ),
      _AthkarCategory(
        title: 'After Fajr Prayer',
        subtitle: 'Supplications after dawn prayer',
        icon: Icons.access_alarm_outlined,
        iconColor: const Color(0xFF14B8A6),
        duration: '5 min',
        count: 8,
        tag: 'after_fajr',
        onTap: () {},
      ),
      _AthkarCategory(
        title: 'Before Sleep',
        subtitle: 'Protective duas for the night',
        icon: Icons.bedtime_outlined,
        iconColor: const Color(0xFF8B5CF6),
        duration: '7 min',
        count: 10,
        tag: 'sleep',
        onTap: () {},
      ),
      _AthkarCategory(
        title: 'Ayat Al-Kursi',
        subtitle: 'The greatest verse in the Quran',
        icon: Icons.menu_book_outlined,
        iconColor: const Color(0xFF10B981),
        duration: '2 min',
        count: 1,
        tag: 'ayat_kursi',
        onTap: () {},
      ),
      _AthkarCategory(
        title: 'Istighfar',
        subtitle: 'Seeking forgiveness from Allah',
        icon: Icons.favorite_border,
        iconColor: const Color(0xFFEF4444),
        duration: '15 min',
        count: 100,
        tag: 'istighfar',
        onTap: () {},
      ),
      _AthkarCategory(
        title: 'Tasbih (SubhanAllah)',
        subtitle: 'Glorifying Allah',
        icon: Icons.radio_button_checked_outlined,
        iconColor: AppColors.primaryGreen,
        duration: '5 min',
        count: 33,
        tag: 'tasbih',
        onTap: () {},
      ),
      _AthkarCategory(
        title: 'After Maghrib Prayer',
        subtitle: 'Supplications after sunset prayer',
        icon: Icons.wb_twilight_outlined,
        iconColor: const Color(0xFFF97316),
        duration: '4 min',
        count: 6,
        tag: 'after_maghrib',
        onTap: () {},
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text('All Athkar (${items.length})',
                style: AppTextStyles.headlineSmall),
          ),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: IslamicCard(
                  onTap: item.onTap,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: item.iconColor.withOpacity(0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(item.icon,
                            color: item.iconColor, size: 22),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.title,
                                style: AppTextStyles.headlineSmall),
                            const SizedBox(height: 2),
                            Text(item.subtitle,
                                style: AppTextStyles.bodySmall),
                            const SizedBox(height: 6),
                            Text(
                              _getArabicPreview(item.tag),
                              style: AppTextStyles.arabicSmall
                                  .copyWith(fontSize: 14),
                              textDirection: TextDirection.rtl,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(item.duration,
                              style: AppTextStyles.bodySmall),
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.primaryGreen.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${item.count} times',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  String _getArabicPreview(String tag) {
    switch (tag) {
      case 'morning':
        return 'أَصْبَحْنَا وَأَصْبَحَ الْمُلْكُ لِلَّهِ...';
      case 'evening':
        return 'أَمْسَيْنَا وَأَمْسَى الْمُلْكُ لِلَّهِ...';
      case 'after_fajr':
        return 'لَا إِلَهَ إِلَّا اللَّهُ وَحْدَهُ...';
      case 'sleep':
        return 'بِاسْمِكَ اللَّهُمَّ أَمُوتُ وَأَحْيَا...';
      case 'ayat_kursi':
        return 'اللَّهُ لَا إِلَٰهَ إِلَّا هُوَ الْحَيُّ الْقَيُّومُ...';
      case 'istighfar':
        return 'أَسْتَغْفِرُ اللَّهَ...';
      case 'tasbih':
        return 'سُبْحَانَ اللَّهِ...';
      case 'after_maghrib':
        return 'أَعُوذُ بِاللَّهِ مِنَ الشَّيْطَانِ...';
      default:
        return 'بِسْمِ اللَّهِ...';
    }
  }
}

class _AthkarCategory {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final String duration;
  final int count;
  final String tag;
  final VoidCallback onTap;

  const _AthkarCategory({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.duration,
    required this.count,
    required this.tag,
    required this.onTap,
  });
}
