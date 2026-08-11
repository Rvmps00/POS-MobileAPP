import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Import all screens
import '../../features/auth/presentation/login_screen.dart';
import '../../features/catalog/presentation/main_pos_screen.dart';
import '../../features/cart/presentation/cart_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/inventory/presentation/inventory_screen.dart';
import '../../features/orders/presentation/order_history_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/settings/presentation/printer_setup_screen.dart';

part 'app_router.g.dart';

// Placeholder auth state for now until Supabase is fully wired
@riverpod
bool authState(AuthStateRef ref) {
  return false; // Assuming unauthenticated for now
}

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final isAuthenticated = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/pos',
    redirect: (context, state) {
      final isLoggingIn = state.uri.path == '/login';
      
      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }
      if (isAuthenticated && isLoggingIn) {
        return '/pos';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/pos',
        builder: (context, state) => const MainPosScreen(),
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartScreen(),
      ),
      GoRoute(
        path: '/checkout',
        builder: (context, state) => const CheckoutScreen(),
      ),
      GoRoute(
        path: '/inventory',
        builder: (context, state) => const InventoryScreen(),
      ),
      GoRoute(
        path: '/orders',
        builder: (context, state) => const OrderHistoryScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(
            path: 'printer',
            builder: (context, state) => const PrinterSetupScreen(),
          ),
        ]
      ),
    ],
  );
}
