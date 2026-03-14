import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/clay_shadows.dart';
import '../../../../core/widgets/clay_card.dart';
import '../../domain/entities/surah_entity.dart';
import '../providers/quran_provider.dart';
import 'bookmarks_screen.dart';
import 'juz_index_screen.dart';
import 'quran_reader_screen.dart';
import 'quran_search_screen.dart';
import 'surah_index_screen.dart';

class QuranHomeScreen extends ConsumerWidget {
  const QuranHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final surahsAsync = ref.watch(surahsProvider);
    final readerState = ref.watch(quranReaderProvider);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: surahsAsync.when(
          loading: () => const Center(
            child: CircularProgressIndicator(color: AppColors.primaryAccent),
          ),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (surahs) => _QuranContent(
            surahs: surahs,
            currentPage: readerState.currentPage,
          ),
        ),
      ),
    );
  }
}

class _QuranContent extends ConsumerWidget {
  final List<SurahEntity> surahs;
  final int currentPage;

  const _QuranContent({required this.surahs, required this.currentPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSurah = surahs.isNotEmpty
        ? surahs.firstWhere(
            (s) => s.startPage <= currentPage && currentPage <= s.endPage,
            orElse: () => surahs.first,
          )
        : null;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeader(currentSurah)),
        SliverToBoxAdapter(child: _buildTabBar(context, surahs, currentSurah)),
        SliverToBoxAdapter(
          child: _buildReadingStats(currentPage, surahs.length),
        ),
        SliverToBoxAdapter(child: _buildBrowseSection(context, surahs)),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }

  Widget _buildHeader(SurahEntity? currentSurah) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            currentSurah?.nameEnglish ?? 'Al-Quran',
            style: AppTextStyles.sectionTitle,
          ),
          if (currentSurah != null)
            Text(
              currentSurah.nameArabic,
              style: AppTextStyles.arabicSmall,
              textDirection: TextDirection.rtl,
            ),
          if (currentSurah != null)
            Text(
              'Surah ${currentSurah.number} • ${currentSurah.versesCount} verses • ${currentSurah.revelationType}',
              style: AppTextStyles.bodySmall,
            ),
        ],
      ),
    );
  }

  Widget _buildTabBar(
    BuildContext context,
    List<SurahEntity> surahs,
    SurahEntity? currentSurah,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: const TabBar(
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.format_list_bulleted, size: 16),
                        SizedBox(width: 6),
                        Text('Verses'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.picture_as_pdf_outlined, size: 16),
                        SizedBox(width: 6),
                        Text('Mushaf PDF'),
                      ],
                    ),
                  ),
                ],
                indicator: BoxDecoration(
                  color: AppColors.primaryAccent,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                dividerColor: Colors.transparent,
              ),
            ),
            SizedBox(
              height: 280,
              child: TabBarView(
                children: [
                  // Verses tab
                  _buildVersesTab(context, currentSurah),
                  // Mushaf PDF tab
                  _buildMushafPdfTab(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersesTab(BuildContext context, SurahEntity? surah) {
    final verses = _getVersesList(surah);
    return Column(
      children: [
        const SizedBox(height: 12),
        // Audio controls
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.skip_previous_outlined),
              onPressed: () {},
              color: AppColors.textSecondary,
            ),
            Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: AppColors.primaryAccent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 28,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.skip_next_outlined),
              onPressed: () {},
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                side: const BorderSide(color: AppColors.border),
              ),
              child: const Text('Tafsir'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Verses
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDE7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFE082)),
            ),
            child: SingleChildScrollView(
              child: Text(
                verses,
                style: AppTextStyles.arabicBody.copyWith(fontSize: 20),
                textDirection: TextDirection.rtl,
                textAlign: TextAlign.right,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMushafPdfTab(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        // Page navigation
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: () {},
              color: AppColors.textSecondary,
            ),
            Text('Page $currentPage of 604', style: AppTextStyles.cardTitle),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {},
              color: AppColors.textSecondary,
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const QuranBookmarksScreen(),
                  ),
                );
              },
              color: AppColors.textSecondary,
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const QuranSearchScreen()),
                );
              },
              color: AppColors.textSecondary,
            ),
          ],
        ),
        // Search
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search in Quran...',
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.textTertiary,
                size: 18,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 10,
              ),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Mushaf page display
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFDE7),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFFE082)),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryAccent,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '$currentPage',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'الْقُرْآنُ الْكَرِيمُ',
                    style: AppTextStyles.arabicHeading,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const QuranReaderScreen(),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFFFE082)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getPageContent(currentPage),
                        style: AppTextStyles.arabicBody.copyWith(fontSize: 18),
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadingStats(int currentPage, int totalSurahs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ClayCard(
        shadowLevel: ClayShadowLevel.surface,
        child: Row(
          children: [
            _StatItem(
              icon: Icons.menu_book_outlined,
              label: 'Last Page',
              value: '$currentPage',
            ),
            _StatDivider(),
            _StatItem(
              icon: Icons.local_fire_department_outlined,
              label: 'Streak',
              value: '3 days',
            ),
            _StatDivider(),
            _StatItem(
              icon: Icons.bar_chart,
              label: 'Progress',
              value: '${((currentPage / 604) * 100).toStringAsFixed(1)}%',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBrowseSection(BuildContext context, List<SurahEntity> surahs) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 400;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Browse Quran', style: AppTextStyles.cardTitle),
          const SizedBox(height: 12),
          if (isCompact)
            Column(
              children: [
                ClayCard(
                  shadowLevel: ClayShadowLevel.surface,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SurahIndexScreen(surahs: surahs),
                    ),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccent.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.format_list_numbered,
                          color: AppColors.primaryAccent,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('By Surah', style: AppTextStyles.cardTitle),
                            Text('114 Surahs', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                ClayCard(
                  shadowLevel: ClayShadowLevel.surface,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const JuzIndexScreen()),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: AppColors.primaryAccent.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.grid_view,
                          color: AppColors.primaryAccent,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('By Juz', style: AppTextStyles.cardTitle),
                            Text('30 Juz', style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Row(
              children: [
                Expanded(
                  child: ClayCard(
                    shadowLevel: ClayShadowLevel.surface,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SurahIndexScreen(surahs: surahs),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.format_list_numbered,
                            color: AppColors.primaryAccent,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text('By Surah', style: AppTextStyles.cardTitle),
                        Text('114 Surahs', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClayCard(
                    shadowLevel: ClayShadowLevel.surface,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const JuzIndexScreen()),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: AppColors.primaryAccent.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.grid_view,
                            color: AppColors.primaryAccent,
                            size: 24,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text('By Juz', style: AppTextStyles.cardTitle),
                        Text('30 Juz', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _getVersesList(SurahEntity? surah) {
    if (surah == null || surah.number == 1) {
      return 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n\nالْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ\n\nالرَّحْمَٰنِ الرَّحِيمِ\n\nمَالِكِ يَوْمِ الدِّينِ\n\nإِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ\n\nاهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ\n\nصِرَاطَ الَّذِينَ أَنْعَمْتَ عَلَيْهِمْ غَيْرِ الْمَغْضُوبِ عَلَيْهِمْ وَلَا الضَّالِّينَ';
    }
    return 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n\nآياتٌ من سورة ${surah.nameArabic}...';
  }

  String _getPageContent(int page) {
    if (page == 1) {
      return 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ\n\nالْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ\n\nالرَّحْمَٰنِ الرَّحِيمِ\n\nمَالِكِ يَوْمِ الدِّينِ\n\nإِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ\n\nاهْدِنَا الصِّرَاطَ الْمُسْتَقِيمَ';
    }
    return 'صفحة $page من المصحف الكريم\n\n...';
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: AppColors.primaryAccent, size: 20),
          const SizedBox(height: 4),
          Text(value, style: AppTextStyles.cardTitle),
          Text(label, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 40, color: AppColors.divider);
  }
}
