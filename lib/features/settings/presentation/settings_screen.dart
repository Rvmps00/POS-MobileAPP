import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/theme_notifier.dart';
import '../../../core/l10n/language_notifier.dart';
import '../../../core/settings/tax_notifier.dart';
import 'printer_setup_screen.dart';
import 'restaurant_info_screen.dart';
import 'staff_management_screen.dart';
import '../../auth/data/providers/auth_provider.dart';
import '../../../core/printer/printer_providers.dart';
import '../../../core/router/role_guard.dart';
import '../../../core/database/app_database.dart';
import '../../catalog/data/providers/catalog_providers.dart';

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
          Card(
            child: ListTile(
              leading: const Icon(Icons.print),
              title: const Text('Printer Setup'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PrinterSetupScreen()),
                );
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.storefront),
              title: const Text('Restaurant Info'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RestaurantInfoScreen()),
                );
              },
            ),
          ),
          RoleGuard(
            allowedRoles: const ['OWNER'],
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.people),
                title: const Text('Staff Management'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const StaffManagementScreen()),
                  );
                },
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.numbers),
              title: const Text('Reset Queue Number'),
              subtitle: const Text('Reset the receipt queue to 0'),
              trailing: const Icon(Icons.restore),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Reset Queue?'),
                    content: const Text('Are you sure you want to reset the queue number? The next order will be Antrian: 001.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('CANCEL')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('RESET')),
                    ],
                  ),
                );
                if (confirm == true) {
                  final prefs = ref.read(sharedPreferencesProvider);
                  await prefs.setInt('queue_sequence', 0);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Queue number reset to 0.'), backgroundColor: Colors.green),
                    );
                  }
                }
              },
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              final db = ref.read(appDatabaseProvider);
              final activeStaffNotifier = ref.read(activeStaffProvider.notifier);
              
              // Wipe local DB to prevent data leaks across accounts
              await db.clearAllData();
              // Clear active staff
              activeStaffNotifier.clearActiveStaff();
              
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
