import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/language_notifier.dart';
import '../sync/connectivity_service.dart';
import '../../features/inventory/data/providers/inventory_providers.dart';

class AppShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AppShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(languageProvider);
    final lang = locale.languageCode;
    final lowStockCount = ref.watch(lowStockCountProvider).value ?? 0;
    final isOnline = ref.watch(isOnlineProvider).value ?? true;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.point_of_sale_outlined),
            selectedIcon: const Icon(Icons.point_of_sale),
            label: lang == 'en' ? 'Order' : 'Pesanan',
          ),
          NavigationDestination(
            icon: const Icon(Icons.restaurant_menu_outlined),
            selectedIcon: const Icon(Icons.restaurant_menu),
            label: 'Menu',
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
        ],
      ),
    );
  }
}
