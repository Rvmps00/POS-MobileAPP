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
import '../../catalog/data/providers/catalog_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);
    final locale = ref.watch(languageProvider);
    final lang = locale.languageCode;

    return Scaffold(
      appBar: AppBar(title: Text(lang == 'en' ? 'Settings' : 'Pengaturan')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: ListView(
            padding: const EdgeInsets.all(16.0),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.dark_mode_outlined),
              title: Text(lang == 'en' ? 'Dark Mode' : 'Mode Gelap'),
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
              title: Text(lang == 'en' ? 'Language' : 'Bahasa'),
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
                lang == 'en'
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
              title: Text(lang == 'en' ? 'Printer Setup' : 'Pengaturan Printer'),
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
              title: Text(lang == 'en' ? 'Restaurant Info' : 'Informasi Restoran'),
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
                title: Text(lang == 'en' ? 'Staff Management' : 'Manajemen Staf'),
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
              title: Text(lang == 'en' ? 'Reset Queue Number' : 'Reset Nomor Antrian'),
              subtitle: Text(
                lang == 'en'
                    ? 'Reset the receipt queue to 0'
                    : 'Reset nomor antrian struk ke 0',
              ),
              trailing: const Icon(Icons.restore),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text(lang == 'en' ? 'Reset Queue?' : 'Reset Antrian?'),
                    content: Text(
                      lang == 'en'
                          ? 'Are you sure you want to reset the queue number? The next order will be Antrian: 001.'
                          : 'Apakah Anda yakin ingin mereset nomor antrian? Pesanan berikutnya akan menjadi Antrian: 001.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: Text(lang == 'en' ? 'CANCEL' : 'BATAL'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, true),
                        child: Text(lang == 'en' ? 'RESET' : 'RESET'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  final prefs = ref.read(sharedPreferencesProvider);
                  await prefs.setInt('queue_sequence', 0);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          lang == 'en'
                              ? 'Queue number reset to 0.'
                              : 'Nomor antrian berhasil direset ke 0.',
                        ),
                        backgroundColor: Colors.green,
                      ),
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
            label: Text(lang == 'en' ? 'Logout' : 'Keluar'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
          ),
        ],
          ),
        ),
      ),
    );
  }
}
