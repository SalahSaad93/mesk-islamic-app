import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/islamic_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _morningDhikr = true;
  bool _eveningDhikr = false;
  bool _surahKahf = false;
  bool _surahBaqarah = false;
  bool _darkMode = false;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
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
          Text('More', style: AppTextStyles.headlineLarge),
          Text('Settings and preferences', style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildLanguageSection() {
    return _section(
      title: 'Language Settings',
      icon: Icons.language_outlined,
      iconColor: AppColors.primaryGreen,
      children: [
        _SettingsTile(
          title: 'App Language',
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_language, style: AppTextStyles.bodyMedium),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down,
                  color: AppColors.textLight),
            ],
          ),
          onTap: () => _showLanguagePicker(),
        ),
      ],
    );
  }

  Widget _buildSunnahSection() {
    final sunnah = [
      (
        'Surat Al-Kahf',
        '110 verses',
        'كهف',
        'Recite every Friday',
        '✨ Protection from Dajjal',
        const Color(0xFF4CAF50)
      ),
      (
        'Before Sleep',
        '30 verses',
        'ملك',
        'Recite before sleep',
        '✨ Protection in the grave',
        const Color(0xFF2196F3)
      ),
      (
        'Surat Al-Baqarah',
        '286 verses',
        'بقرة',
        'The longest chapter',
        '✨ Barakah and protection',
        const Color(0xFFF59E0B)
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
                const Icon(Icons.menu_book_outlined,
                    size: 18, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Text('Sunnan Quranieh', style: AppTextStyles.headlineSmall),
                const SizedBox(width: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Recommended Surahs',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.primaryGreen),
                  ),
                ),
              ],
            ),
          ),
          ...sunnah.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: IslamicCard(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: s.$6.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            s.$3,
                            style: AppTextStyles.arabicSmall
                                .copyWith(fontSize: 12, color: s.$6),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s.$1, style: AppTextStyles.headlineSmall),
                            Text(s.$2, style: AppTextStyles.bodySmall),
                            Text(s.$4, style: AppTextStyles.bodySmall),
                            Text(
                              s.$5,
                              style: AppTextStyles.bodySmall
                                  .copyWith(color: AppColors.goldAccent),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildRemindersSection() {
    return _section(
      title: 'Islamic Reminders',
      icon: Icons.notifications_outlined,
      iconColor: AppColors.goldAccent,
      children: [
        _SettingsToggle(
          title: 'Morning Dhikr',
          subtitle: 'Daily morning remembrance',
          value: _morningDhikr,
          onChanged: (v) => setState(() => _morningDhikr = v),
        ),
        const Divider(height: 1),
        _SettingsToggle(
          title: 'Evening Dhikr',
          subtitle: 'Daily evening remembrance',
          value: _eveningDhikr,
          onChanged: (v) => setState(() => _eveningDhikr = v),
        ),
        const Divider(height: 1),
        _SettingsToggle(
          title: 'Surat Al-Mulk',
          subtitle: 'Before sleep protection',
          value: _surahKahf,
          onChanged: (v) => setState(() => _surahKahf = v),
        ),
        const Divider(height: 1),
        _SettingsToggle(
          title: 'Surat Al-Baqarah',
          subtitle: 'Weekly recitation',
          value: _surahBaqarah,
          onChanged: (v) => setState(() => _surahBaqarah = v),
        ),
      ],
    );
  }

  Widget _buildAppSettingsSection() {
    return _section(
      title: 'App Settings',
      icon: Icons.settings_outlined,
      iconColor: AppColors.textMedium,
      children: [
        _SettingsTile(
          leading: const Icon(Icons.language_outlined,
              color: AppColors.textMedium, size: 20),
          title: 'Language',
          onTap: () {},
        ),
        const Divider(height: 1),
        _SettingsTile(
          leading: const Icon(Icons.volume_up_outlined,
              color: AppColors.textMedium, size: 20),
          title: 'Audio Settings',
          onTap: () {},
        ),
        const Divider(height: 1),
        _SettingsTile(
          leading: const Icon(Icons.download_outlined,
              color: AppColors.textMedium, size: 20),
          title: 'Download Quran',
          onTap: () {},
        ),
        const Divider(height: 1),
        _SettingsToggle(
          leading: const Icon(Icons.dark_mode_outlined,
              color: AppColors.textMedium, size: 20),
          title: 'Dark Mode',
          value: _darkMode,
          onChanged: (v) => setState(() => _darkMode = v),
        ),
      ],
    );
  }

  Widget _buildAccountSection() {
    return _section(
      title: 'Account & Data',
      icon: Icons.person_outline,
      iconColor: AppColors.textMedium,
      children: [
        _SettingsTile(
          leading: const Icon(Icons.person_outline,
              color: AppColors.textMedium, size: 20),
          title: 'Profile',
          onTap: () {},
        ),
        const Divider(height: 1),
        _SettingsTile(
          leading: const Icon(Icons.favorite_border,
              color: AppColors.textMedium, size: 20),
          title: 'Favorites',
          onTap: () {},
        ),
        const Divider(height: 1),
        _SettingsTile(
          leading: const Icon(Icons.bookmark_border,
              color: AppColors.textMedium, size: 20),
          title: 'Bookmarks',
          onTap: () {},
        ),
        const Divider(height: 1),
        _SettingsTile(
          leading: const Icon(Icons.bar_chart,
              color: AppColors.textMedium, size: 20),
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
      iconColor: AppColors.textMedium,
      children: [
        _SettingsTile(
          leading: const Icon(Icons.help_outline,
              color: AppColors.textMedium, size: 20),
          title: 'Help & FAQ',
          onTap: () {},
        ),
        const Divider(height: 1),
        _SettingsTile(
          leading: const Icon(Icons.email_outlined,
              color: AppColors.textMedium, size: 20),
          title: 'Contact Us',
          onTap: () {},
        ),
        const Divider(height: 1),
        _SettingsTile(
          leading: const Icon(Icons.share_outlined,
              color: AppColors.textMedium, size: 20),
          title: 'Share App',
          onTap: () {},
        ),
        const Divider(height: 1),
        _SettingsTile(
          leading: const Icon(Icons.star_border,
              color: AppColors.textMedium, size: 20),
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
                color: AppColors.primaryGreen.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.menu_book,
                  color: AppColors.primaryGreen, size: 32),
            ),
            const SizedBox(height: 12),
            Text('Islamic Companion',
                style: AppTextStyles.headlineMedium),
            const SizedBox(height: 4),
            Text('Version 1.0.0', style: AppTextStyles.bodySmall),
            const SizedBox(height: 4),
            Text('Made with ❤ for the Muslim Ummah',
                style: AppTextStyles.bodySmall),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.security, size: 14, color: AppColors.primaryGreen),
                const SizedBox(width: 4),
                Text(
                  'Privacy Protected',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.primaryGreen),
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
                Text(title, style: AppTextStyles.headlineSmall),
              ],
            ),
          ),
          IslamicCard(
            padding: EdgeInsets.zero,
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: ['English', 'Arabic', 'French', 'Urdu'].map((lang) {
          return ListTile(
            title: Text(lang),
            trailing: _language == lang
                ? const Icon(Icons.check, color: AppColors.primaryGreen)
                : null,
            onTap: () {
              setState(() => _language = lang);
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
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: leading,
      title: Text(title, style: AppTextStyles.bodyLarge),
      subtitle: subtitle != null
          ? Text(subtitle!, style: AppTextStyles.bodySmall)
          : null,
      trailing: trailing ??
          const Icon(Icons.chevron_right, color: AppColors.textLight),
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
        activeColor: AppColors.primaryGreen,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
