import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

// Import all screens
import '../../features/dashboard/data/providers/shift_provider.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/catalog/presentation/main_pos_screen.dart';
import '../../features/catalog/presentation/product_form_screen.dart';
import '../../features/catalog/presentation/ingredient_management_screen.dart';
import '../../features/catalog/presentation/topping_management_screen.dart';
import '../../features/catalog/presentation/menu_management_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/inventory/presentation/inventory_screen.dart';
import '../../features/inventory/presentation/batch_restock_screen.dart';
import '../../features/inventory/presentation/stock_history_screen.dart';
import '../../features/orders/presentation/order_history_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/dashboard/presentation/shift_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/printer_setup_screen.dart';
import 'app_shell.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

part 'app_router.g.dart';

@riverpod
Stream<AuthState> authState(Ref ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
}

@riverpod
GoRouter appRouter(Ref ref) {
  final authState = ref.watch(authStateProvider);
  final isAuthenticated = authState.value?.session != null;
  final shiftState = ref.watch(shiftProvider);

  return GoRouter(
    initialLocation: '/pos',
    redirect: (context, state) {
      // While loading the initial auth state, don't redirect yet
      if (authState.isLoading) return null;

      final isLoggingIn = state.uri.path == '/login';

      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }
      if (isAuthenticated && isLoggingIn) {
        return '/pos';
      }

      if (isAuthenticated) {
        final isPosRoute = state.uri.path == '/pos' || state.uri.path.startsWith('/pos/');
        if (isPosRoute && !shiftState.isLoading) {
          if (shiftState.value == null) {
            // No active shift, lock POS screen
            return '/shift';
          }
        }
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/shift', builder: (context, state) => const ShiftScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          // Tab 1: POS / Order
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/pos',
                builder: (context, state) => const MainPosScreen(),
                routes: [
                  GoRoute(
                    path: 'cart',
                    builder: (context, state) => const CartScreen(),
                  ),
                  GoRoute(
                    path: 'checkout',
                    builder: (context, state) => const CheckoutScreen(),
                  ),
                ],
              ),
            ],
          ),
          // Tab 2: Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          // Tab 3: Menu Management
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/menu',
                builder: (context, state) => const MenuManagementScreen(),
                routes: [
                  GoRoute(
                    path: 'add',
                    builder: (context, state) => const ProductFormScreen(),
                  ),
                  GoRoute(
                    path: ':id/edit',
                    builder: (context, state) => ProductFormScreen(
                      productId: state.pathParameters['id'],
                    ),
                  ),
                  GoRoute(
                    path: ':id/ingredients',
                    builder: (context, state) => IngredientManagementScreen(
                      productId: state.pathParameters['id']!,
                    ),
                  ),
                  GoRoute(
                    path: ':id/toppings',
                    builder: (context, state) => ToppingManagementScreen(
                      productId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Tab 4: Inventory
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/inventory',
                builder: (context, state) => const InventoryScreen(),
                routes: [
                  GoRoute(
                    path: 'batch-restock',
                    builder: (context, state) => const BatchRestockScreen(),
                  ),
                  GoRoute(
                    path: ':id/history',
                    builder: (context, state) => StockHistoryScreen(
                      productId: state.pathParameters['id']!,
                    ),
                  ),
                ],
              ),
            ],
          ),
          // Tab 5: Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
                routes: [
                  GoRoute(
                    path: 'printer',
                    builder: (context, state) => const PrinterSetupScreen(),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrderHistoryScreen(),
      ),
    ],
  );
}
