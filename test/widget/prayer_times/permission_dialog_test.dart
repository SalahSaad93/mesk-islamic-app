import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mesk_islamic_app/core/widgets/location_permission_dialog.dart';
import 'package:mesk_islamic_app/l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  Widget createDialogWrapper({Locale locale = const Locale('ar')}) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      locale: locale,
      home: const Scaffold(body: LocationPermissionDialog()),
    );
  }

  testWidgets('LocationPermissionDialog shows correct Arabic text', (WidgetTester tester) async {
    await tester.pumpWidget(createDialogWrapper());
    await tester.pumpAndSettle();

    expect(find.text('الوصول إلى الموقع'), findsOneWidget);
    expect(find.text('سماح'), findsOneWidget);
    expect(find.text('إلغاء'), findsOneWidget);
  });
}
