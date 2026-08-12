import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/theme_notifier.dart';
import '../../../core/l10n/language_notifier.dart';
import '../../../core/settings/tax_notifier.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(languageProvider);
    // Note: Once localization is fully translated, use l10n strings.
    // final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.dark_mode_outlined),
              title: const Text('Dark Mode'),
              trailing: Switch(
                value: themeMode == ThemeMode.dark,
                onChanged: (_) {
                  ref.read(themeProvider.notifier).toggleTheme();
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.language),
              title: const Text('Language'),
              trailing: DropdownButton<String>(
                value: locale.languageCode,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(
                    value: 'id',
                    child: Text('Bahasa Indonesia'),
                  ),
                ],
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    ref.read(languageProvider.notifier).setLanguage(newValue);
                  }
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.receipt_long),
              title: Text(
                locale.languageCode == 'en'
                    ? 'Enable Tax (10%)'
                    : 'Aktifkan Pajak (10%)',
              ),
              trailing: Switch(
                value: ref.watch(taxEnabledProvider),
                onChanged: (value) {
                  ref.read(taxEnabledProvider.notifier).toggleTax(value);
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
            },
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
          ),
        ],
      ),
    );
  }
}
