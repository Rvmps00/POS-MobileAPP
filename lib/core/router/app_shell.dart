import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/language_notifier.dart';
import '../sync/connectivity_service.dart';
import '../../features/inventory/data/providers/inventory_providers.dart';
import '../../features/auth/data/providers/auth_provider.dart';

class AppShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);
    final lang = locale.languageCode;
    final lowStockCount = ref.watch(lowStockCountProvider).value ?? 0;
    final isOnline = ref.watch(isOnlineProvider).value ?? true;
    
    final activeStaff = ref.watch(activeStaffProvider);
    final isCashier = activeStaff?.role == 'CASHIER';

    // Map visible tab indices to branch indices
    final List<int> visibleBranches = isCashier ? [0, 5] : [0, 1, 2, 3, 4, 5];
    
    final allDestinations = [
      NavigationDestination(
        icon: const Icon(Icons.point_of_sale_outlined),
        selectedIcon: const Icon(Icons.point_of_sale),
        label: lang == 'en' ? 'Order' : 'Pesanan',
      ),
      NavigationDestination(
        icon: const Icon(Icons.dashboard_outlined),
        selectedIcon: const Icon(Icons.dashboard),
        label: lang == 'en' ? 'Dashboard' : 'Dasbor',
      ),
      NavigationDestination(
        icon: const Icon(Icons.restaurant_menu_outlined),
        selectedIcon: const Icon(Icons.restaurant_menu),
        label: lang == 'en' ? 'Menu' : 'Menu',
      ),
      NavigationDestination(
        icon: Badge(
          isLabelVisible: lowStockCount > 0,
          label: Text('$lowStockCount'),
          child: const Icon(Icons.inventory_2_outlined),
        ),
        selectedIcon: Badge(
          isLabelVisible: lowStockCount > 0,
          label: Text('$lowStockCount'),
          child: const Icon(Icons.inventory_2),
        ),
        label: lang == 'en' ? 'Inventory' : 'Stok',
      ),
      NavigationDestination(
        icon: const Icon(Icons.account_balance_wallet_outlined),
        selectedIcon: const Icon(Icons.account_balance_wallet),
        label: lang == 'en' ? 'Expenses' : 'Pengeluaran',
      ),
      NavigationDestination(
        icon: Badge(
          isLabelVisible: !isOnline,
          smallSize: 10,
          backgroundColor: Colors.red,
          child: const Icon(Icons.settings_outlined),
        ),
        selectedIcon: Badge(
          isLabelVisible: !isOnline,
          smallSize: 10,
          backgroundColor: Colors.red,
          child: const Icon(Icons.settings),
        ),
        label: lang == 'en' ? 'Settings' : 'Pengaturan',
      ),
    ];

    final destinations = visibleBranches.map((idx) => allDestinations[idx]).toList();
    final visibleIndex = visibleBranches.indexOf(navigationShell.currentIndex);
    final selectedIndex = visibleIndex != -1 ? visibleIndex : 0;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          height: 68,
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.4,
              );
            }
            return const TextStyle(
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.4,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: (index) {
            final targetBranch = visibleBranches[index];
            navigationShell.goBranch(
              targetBranch,
              initialLocation: targetBranch == navigationShell.currentIndex,
            );
          },
          destinations: destinations,
        ),
      ),
    );
  }
}
