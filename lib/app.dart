import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/navigation/app_shell.dart';
import 'package:mesk_islamic_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/settings/presentation/providers/settings_provider.dart';

class MeskApp extends ConsumerWidget {
  const MeskApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localeCode = ref.watch(settingsProvider.select((s) => s.language));
    final isDarkMode = ref.watch(settingsProvider.select((s) => s.isDarkMode));

    return MaterialApp(
      title: 'Mesk Islamic App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      locale: Locale(localeCode),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      home: const AppShell(),
    );
  }
}
