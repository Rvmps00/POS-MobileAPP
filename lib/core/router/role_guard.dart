import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/data/providers/auth_provider.dart';

class RoleGuard extends ConsumerWidget {
  final List<String> allowedRoles;
  final Widget child;
  final Widget fallback;

  const RoleGuard({
    super.key,
    required this.allowedRoles,
    required this.child,
    this.fallback = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeStaff = ref.watch(activeStaffProvider);

    if (activeStaff == null) {
      return fallback;
    }

    if (allowedRoles.contains(activeStaff.role)) {
      return child;
    }

    return fallback;
  }
}
