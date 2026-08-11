import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'core/theme/app_theme.dart';
import 'core/theme/theme_notifier.dart';
import 'core/l10n/language_notifier.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  // TODO: Replace with actual Supabase URL and Anon Key when provided by the user
  await Supabase.initialize(
    url: 'https://placeholder-url.supabase.co',
    anonKey: 'placeholder-anon-key',
  );

  runApp(const ProviderScope(child: LesehanSuryaApp()));
}

class LesehanSuryaApp extends ConsumerWidget {
  const LesehanSuryaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeNotifierProvider);
    final locale = ref.watch(languageNotifierProvider);
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Lesehan Surya POS',
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      locale: locale,
      localizationsDelegates: const [
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
