import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'core/l10n/app_localizations.dart';
import 'core/printer/printer_providers.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'core/l10n/language_notifier.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://iggafrwzriteftslmneb.supabase.co',
    publishableKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlnZ2Fmcnd6cml0ZWZ0c2xtbmViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODY0MzAzNDksImV4cCI6MjEwMjAwNjM0OX0.rJZxPFCei76-eVEePa-tPgHZOa0yDSzal8PUPVQxGio',
  );

  // Initialize dotenv
  await dotenv.load(fileName: ".env");

  final prefs = await SharedPreferences.getInstance();

  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: const LesehanSuryaApp(),
  ));
}

class LesehanSuryaApp extends ConsumerWidget {
  const LesehanSuryaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(languageProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Lesehan Surya POS',
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      locale: locale,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''), // English
        Locale('id', ''), // Indonesian
      ],
      routerConfig: router,
    );
  }
}
