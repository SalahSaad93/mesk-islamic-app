import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mesk_islamic_app/l10n/app_localizations.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/constants/clay_shadows.dart';
import '../../../../core/widgets/clay_card.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildHeader()),
            SliverToBoxAdapter(child: _buildLanguageSection()),
            SliverToBoxAdapter(child: _buildSunnahSection()),
            SliverToBoxAdapter(child: _buildRemindersSection()),
            SliverToBoxAdapter(child: _buildAppSettingsSection()),
            SliverToBoxAdapter(child: _buildAccountSection()),
            SliverToBoxAdapter(child: _buildSupportSection()),
            SliverToBoxAdapter(child: _buildAppInfo()),
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
          Text(
            AppLocalizations.of(context)!.moreTab,
            style: AppTextStyles.sectionTitle,
          ),
          Text(
            AppLocalizations.of(context)!.settingsAndPreferences,
            style: AppTextStyles.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection() {
    return _section(
      title: AppLocalizations.of(context)!.languageSettings,
      icon: Icons.language_outlined,
      iconColor: AppColors.primaryAccent,
      children: [
        _SettingsTile(
          title: AppLocalizations.of(context)!.appLanguage,
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ref.watch(settingsProvider.select((s) => s.language)) == 'ar'
                    ? 'العربية'
                    : 'English',
                style: AppTextStyles.bodyMedium,
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.textTertiary,
              ),
            ],
          ),
          onTap: () => _showLanguagePicker(),
        ),
      ],
    );
  }

  Widget _buildSunnahSection() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isCompact = screenWidth < 400;
    
    final sunnah = [
      (
        'Surat Al-Kahf',
        '110 verses',
        'كهف',
        'Recite every Friday',
        '✨ Protection from Dajjal',
        const Color(0xFF4CAF50),
      ),
      (
        'Before Sleep',
        '30 verses',
        'ملك',
        'Recite before sleep',
        '✨ Protection in the grave',
        const Color(0xFF2196F3),
      ),
      (
        'Surat Al-Baqarah',
        '286 verses',
        'بقرة',
        'The longest chapter',
        '✨ Barakah and protection',
        const Color(0xFFF59E0B),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Row(
              children: [
                const Icon(
                  Icons.menu_book_outlined,
                  size: 18,
                  color: AppColors.primaryAccent,
                ),
                const SizedBox(width: 8),
                Text('Sunnan Quranieh', style: AppTextStyles.cardTitle),
                if (!isCompact)
                  const SizedBox(width: 8),
                if (!isCompact)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Recommended Surahs',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primaryAccent,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          ...sunnah.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ClayCard(
                shadowLevel: ClayShadowLevel.surface,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: s.$6.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              s.$3,
                              style: AppTextStyles.arabicSmall.copyWith(
                                fontSize: 12,
                                color: s.$6,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(s.$1, style: AppTextStyles.cardTitle),
                              Text(s.$2, style: AppTextStyles.bodySmall),
                              Text(s.$4, style: AppTextStyles.bodySmall),
                              Text(
                                s.$5,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.warning,
                                ),
                              ),
                            ],
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

  Widget _buildRemindersSection() {
    return _section(
      title: 'Islamic Reminders',
      icon: Icons.notifications_outlined,
      iconColor: AppColors.warning,
      children: [
        _SettingsToggle(
          title: 'Morning Dhikr',
          subtitle: 'Daily morning remembrance',
          value: ref.watch(settingsProvider).morningDhikr,
          onChanged: (v) =>
              ref.read(settingsProvider.notifier).toggleMorningDhikr(v),
        ),
        const Divider(height: 1),
        _SettingsToggle(
          title: 'Evening Dhikr',
          subtitle: 'Daily evening remembrance',
          value: ref.watch(settingsProvider).eveningDhikr,
          onChanged: (v) =>
              ref.read(settingsProvider.notifier).toggleEveningDhikr(v),
        ),
        const Divider(height: 1),
        _SettingsToggle(
          title: 'Surat Al-Mulk',
          subtitle: 'Before sleep protection',
          value: ref.watch(settingsProvider).surahKahf,
          onChanged: (v) =>
              ref.read(settingsProvider.notifier).toggleSurahKahf(v),
        ),
        const Divider(height: 1),
        _SettingsToggle(
          title: 'Surat Al-Baqarah',
          subtitle: 'Weekly recitation',
          value: ref.watch(settingsProvider).surahBaqarah,
          onChanged: (v) =>
              ref.read(settingsProvider.notifier).toggleSurahBaqarah(v),
        ),
      ],
    );
  }

  Widget _buildAppSettingsSection() {
    return _section(
      title: 'App Settings',
      icon: Icons.settings_outlined,
      iconColor: AppColors.textSecondary,
      children: [
        _SettingsTile(
          leading: const Icon(
            Icons.language_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
          title: 'Language',
          onTap: () => _showLanguagePicker(),
        ),
        const Divider(height: 1),
        _SettingsTile(
          leading: const Icon(
            Icons.volume_up_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
          title: 'Audio Settings',
          onTap: () {},
        ),
        const Divider(height: 1),
        _SettingsTile(
          leading: const Icon(
            Icons.download_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
          title: 'Download Quran',
          onTap: () {},
        ),
        const Divider(height: 1),
        _SettingsToggle(
          leading: const Icon(
            Icons.dark_mode_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
          title: 'Dark Mode',
          value: ref.watch(settingsProvider).isDarkMode,
          onChanged: (v) =>
              ref.read(settingsProvider.notifier).toggleDarkMode(v),
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return _section(
      title: 'Account & Data',
      icon: Icons.person_outline,
      iconColor: AppColors.textSecondary,
      children: [
        _SettingsTile(
          leading: const Icon(
            Icons.person_outline,
            color: AppColors.textSecondary,
            size: 20,
          ),
          title: 'Profile',
          onTap: () {},
        ),
        const Divider(height: 1),
        _SettingsTile(
          leading: const Icon(
            Icons.favorite_border,
            color: AppColors.textSecondary,
            size: 20,
          ),
          title: 'Favorites',
          onTap: () {},
        ),
        const Divider(height: 1),
        _SettingsTile(
          leading: const Icon(
            Icons.bookmark_border,
            color: AppColors.textSecondary,
            size: 20,
          ),
          title: 'Bookmarks',
          onTap: () {},
        ),
        const Divider(height: 1),
        _SettingsTile(
          leading: const Icon(
            Icons.bar_chart,
            color: AppColors.textSecondary,
            size: 20,
          ),
          title: 'Reading Progress',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildSupportSection() {
    return _section(
      title: 'Support',
      icon: Icons.help_outline,
      iconColor: AppColors.textSecondary,
      children: [
        _SettingsTile(
          leading: const Icon(
            Icons.help_outline,
            color: AppColors.textSecondary,
            size: 20,
          ),
          title: 'Help & FAQ',
          onTap: () {},
        ),
        const Divider(height: 1),
        _SettingsTile(
          leading: const Icon(
            Icons.email_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
          title: 'Contact Us',
          onTap: () {},
        ),
        const Divider(height: 1),
        _SettingsTile(
          leading: const Icon(
            Icons.share_outlined,
            color: AppColors.textSecondary,
            size: 20,
          ),
          title: 'Share App',
          onTap: () {},
        ),
        const Divider(height: 1),
        _SettingsTile(
          leading: const Icon(
            Icons.star_border,
            color: AppColors.textSecondary,
            size: 20,
          ),
          title: 'Rate App',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildAppInfo() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.primaryAccent.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.menu_book,
                color: AppColors.primaryAccent,
                size: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text('Islamic Companion', style: AppTextStyles.headlineMedium),
            const SizedBox(height: 4),
            Text('Version 1.0.0', style: AppTextStyles.bodySmall),
            const SizedBox(height: 4),
            Text(
              'Made with ❤ for the Muslim Ummah',
              style: AppTextStyles.bodySmall,
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.security,
                  size: 14,
                  color: AppColors.primaryAccent,
                ),
                const SizedBox(width: 4),
                Text(
                  'Privacy Protected',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primaryAccent,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _section({
    required String title,
    required IconData icon,
    required Color iconColor,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 12),
            child: Row(
              children: [
                Icon(icon, size: 18, color: iconColor),
                const SizedBox(width: 8),
                Text(title, style: AppTextStyles.cardTitle),
              ],
            ),
          ),
          ClayCard(
            shadowLevel: ClayShadowLevel.surface,
            padding: EdgeInsets.zero,
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker() {
    final currentLang = ref.read(settingsProvider).language;
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children:
            [
              {'name': 'English', 'code': 'en'},
              {'name': 'العربية', 'code': 'ar'},
            ].map((langObj) {
              final langName = langObj['name']!;
              final langCode = langObj['code']!;
              return ListTile(
                title: Text(langName),
                trailing: currentLang == langCode
                    ? const Icon(Icons.check, color: AppColors.primaryAccent)
                    : null,
                onTap: () {
                  ref.read(settingsProvider.notifier).setLanguage(langCode);
                  Navigator.pop(context);
                },
              );
            }).toList(),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    this.leading,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title, style: AppTextStyles.bodyLarge),
      trailing:
          trailing ??
          const Icon(Icons.chevron_right, color: AppColors.textTertiary),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}

class _SettingsToggle extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsToggle({
    this.leading,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title, style: AppTextStyles.bodyLarge),
      subtitle: subtitle != null
          ? Text(subtitle!, style: AppTextStyles.bodySmall)
          : null,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.primaryAccent,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
