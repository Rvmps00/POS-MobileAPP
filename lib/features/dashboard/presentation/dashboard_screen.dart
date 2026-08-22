import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/l10n/language_notifier.dart';
import '../../auth/data/providers/auth_provider.dart';
import '../data/providers/dashboard_provider.dart';
import '../data/providers/shift_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shiftState = ref.watch(shiftProvider);
    final metricsAsync = ref.watch(dashboardMetricsProvider(null));
    final colorScheme = Theme.of(context).colorScheme;
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final l10n = AppLocalizations.of(context)!;
    final activeStaff = ref.watch(activeStaffProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerHighest.withOpacity(0.3),
      appBar: AppBar(
        title: Text(l10n.dashboard, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: l10n.orders,
            onPressed: () => context.push('/orders'),
          ),
        ],
      ),
      body: metricsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (metrics) {
          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(dashboardMetricsProvider);
              await ref.read(dashboardMetricsProvider(null).future);
              ref.invalidate(shiftProvider);
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Text(
                    'Hello, ${activeStaff?.fullName ?? 'Owner'} 👋',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Shift Status Banner
                shiftState.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (shift) {
                    if (shift == null) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 24),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.errorContainer,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: colorScheme.onErrorContainer),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Text(
                                l10n.noActiveShift,
                                style: TextStyle(color: colorScheme.onErrorContainer, fontWeight: FontWeight.w600),
                              ),
                            ),
                            FilledButton(
                              onPressed: () => context.push('/shift'),
                              style: FilledButton.styleFrom(
                                backgroundColor: colorScheme.onErrorContainer,
                                foregroundColor: colorScheme.errorContainer,
                              ),
                              child: Text(l10n.startShift),
                            )
                          ],
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),

                // Metrics Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 1.3,
                  children: [
                    _MetricCard(
                      title: l10n.revenue,
                      value: currencyFormatter.format(metrics.revenue),
                      icon: Icons.account_balance_wallet,
                    ),
                    _MetricCard(
                      title: l10n.orderCount,
                      value: '${metrics.orderCount}',
                      icon: Icons.shopping_bag,
                    ),
                    _MetricCard(
                      title: l10n.averageOrderValue,
                      value: currencyFormatter.format(metrics.averageOrderValue),
                      icon: Icons.analytics,
                    ),
                    _MetricCard(
                      title: l10n.itemsSold,
                      value: '${metrics.itemsSold}',
                      icon: Icons.fastfood,
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),

                // End Shift Button (Only if shift is active)
                shiftState.maybeWhen(
                  data: (shift) {
                    if (shift != null) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: FilledButton.icon(
                            onPressed: () => context.push('/shift'),
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            icon: const Icon(Icons.stop_circle_outlined, size: 28),
                            label: Text(
                              l10n.endShift,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                  orElse: () => const SizedBox.shrink(),
                ),

                // Chart Placeholder
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                    side: BorderSide(color: colorScheme.outlineVariant.withOpacity(0.5)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hourly Sales', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 32),
                        SizedBox(
                          height: 200,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barGroups: metrics.hourlySales.entries
                                  .where((e) => e.value > 0)
                                  .map((e) => BarChartGroupData(
                                    x: e.key,
                                    barRods: [
                                      BarChartRodData(
                                        toY: e.value,
                                        color: colorScheme.primary,
                                        width: 12,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ],
                                  )).toList(),
                              titlesData: const FlTitlesData(
                                leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: _bottomTitles,
                                    reservedSize: 28,
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              gridData: const FlGridData(show: false),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Widget _bottomTitles(double value, TitleMeta meta) {
  const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12);
  return SideTitleWidget(
    meta: meta,
    child: Text('${value.toInt()}:00', style: style),
  );
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: Colors.white),
                ),
              ],
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
