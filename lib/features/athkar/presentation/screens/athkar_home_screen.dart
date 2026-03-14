import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/clay_shadows.dart';
import '../../../../core/widgets/clay_card.dart';
import 'athkar_list_screen.dart';

/// All 8 categories with metadata
const _kAllCategories = [
  _AthkarCategory(
    title: 'Morning Athkar',
    subtitle: 'Start your day with these blessed supplications',
    icon: Icons.wb_sunny_outlined,
    iconColor: Color(0xFFF59E0B),
    duration: '10 min',
    count: 15,
    tag: 'morning',
  ),
  _AthkarCategory(
    title: 'Evening Athkar',
    subtitle: 'End your day with protection and gratitude',
    icon: Icons.nightlight_outlined,
    iconColor: Color(0xFF6366F1),
    duration: '8 min',
    count: 12,
    tag: 'evening',
  ),
  _AthkarCategory(
    title: 'After Fajr Prayer',
    subtitle: 'Supplications after dawn prayer',
    icon: Icons.access_alarm_outlined,
    iconColor: Color(0xFF14B8A6),
    duration: '5 min',
    count: 8,
    tag: 'after_fajr',
  ),
  _AthkarCategory(
    title: 'Before Sleep',
    subtitle: 'Protective duas for the night',
    icon: Icons.bedtime_outlined,
    iconColor: Color(0xFF8B5CF6),
    duration: '7 min',
    count: 10,
    tag: 'sleep',
  ),
  _AthkarCategory(
    title: 'Ayat Al-Kursi',
    subtitle: 'The greatest verse in the Quran',
    icon: Icons.menu_book_outlined,
    iconColor: Color(0xFF10B981),
    duration: '2 min',
    count: 1,
    tag: 'ayat_kursi',
  ),
  _AthkarCategory(
    title: 'Istighfar',
    subtitle: 'Seeking forgiveness from Allah',
    icon: Icons.favorite_border,
    iconColor: Color(0xFFEF4444),
    duration: '15 min',
    count: 100,
    tag: 'istighfar',
  ),
  _AthkarCategory(
    title: 'Tasbih',
    subtitle: 'Glorifying Allah',
    icon: Icons.radio_button_checked_outlined,
    iconColor: AppColors.primaryAccent,
    duration: '5 min',
    count: 33,
    tag: 'tasbih',
  ),
  _AthkarCategory(
    title: 'After Maghrib Prayer',
    subtitle: 'Supplications after sunset prayer',
    icon: Icons.wb_twilight_outlined,
    iconColor: Color(0xFFF97316),
    duration: '4 min',
    count: 6,
    tag: 'after_maghrib',
  ),
];

const _kFilterChips = [
  'All',
  'Morning',
  'Evening',
  'Night',
  'Prayer',
  'General',
];

const _kCategoryFilterMap = {
  'All': null,
  'Morning': ['morning', 'after_fajr'],
  'Evening': ['evening', 'after_maghrib'],
  'Night': ['sleep'],
  'Prayer': ['after_fajr', 'after_maghrib'],
  'General': ['ayat_kursi', 'istighfar', 'tasbih'],
};

class AthkarHomeScreen extends ConsumerStatefulWidget {
  const AthkarHomeScreen({super.key});

  @override
  ConsumerState<AthkarHomeScreen> createState() => _AthkarHomeScreenState();
}

class _AthkarHomeScreenState extends ConsumerState<AthkarHomeScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_AthkarCategory> get _filteredCategories {
    var items = _kAllCategories.toList();

    // Apply filter chip
    final allowed = _kCategoryFilterMap[_selectedFilter];
    if (allowed != null) {
      items = items.where((c) => allowed.contains(c.tag)).toList();
    }

    // Apply search
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      items = items
          .where(
            (c) =>
                c.title.toLowerCase().contains(q) ||
                c.subtitle.toLowerCase().contains(q),
          )
          .toList();
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(child: _buildFilterChips()),
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
          Text('Athkar & Duas', style: AppTextStyles.sectionTitle),
          Text(
            'Supplications and remembrance of Allah',
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v.trim()),
        decoration: InputDecoration(
          hintText: 'Search athkar...',
          prefixIcon: const Icon(Icons.search, color: AppColors.textTertiary),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textTertiary),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _kFilterChips.map((filter) {
            final isSelected = filter == _selectedFilter;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(filter),
                selected: isSelected,
                onSelected: (_) => setState(() {
                  _selectedFilter = filter;
                }),
                selectedColor: AppColors.primaryAccent,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                backgroundColor: AppColors.surface,
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
    final items = _filteredCategories;

    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            children: [
              const Icon(
                Icons.search_off,
                color: AppColors.textTertiary,
                size: 48,
              ),
              const SizedBox(height: 12),
              Text(
                'No results for "$_searchQuery"',
                style: AppTextStyles.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              'All Athkar (${items.length})',
              style: AppTextStyles.cardTitle,
            ),
          ),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ClayCard(
                shadowLevel: ClayShadowLevel.surface,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AthkarListScreen(category: item.tag, title: item.title),
                  ),
                ),
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: item.iconColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(item.icon, color: item.iconColor, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item.title, style: AppTextStyles.cardTitle),
                          const SizedBox(height: 2),
                          Text(item.subtitle, style: AppTextStyles.bodySmall),
                          const SizedBox(height: 6),
                          Text(
                            _getArabicPreview(item.tag),
                            style: AppTextStyles.arabicSmall.copyWith(
                              fontSize: 14,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(item.duration, style: AppTextStyles.bodySmall),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent.withValues(
                              alpha: 0.1,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${item.count} times',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.primaryAccent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
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

  const _AthkarCategory({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.duration,
    required this.count,
    required this.tag,
  });
}
