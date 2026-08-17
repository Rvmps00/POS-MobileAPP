import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            tooltip: 'Order History',
            onPressed: () => context.push('/orders'),
          ),
          IconButton(
            icon: const Icon(Icons.storefront),
            tooltip: 'Shift Management',
            onPressed: () => context.push('/shift'),
          ),
        ],
      ),
      body: shiftState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, st) => Center(child: Text('Error: $err')),
        data: (shift) {
          if (shift == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_clock, size: 64, color: colorScheme.outline),
                  const SizedBox(height: 16),
                  const Text('No active shift. Please start a shift first.'),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: () => context.push('/shift'),
                    child: const Text('Start Shift'),
                  ),
                ],
              ),
            );
          }

          return metricsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, st) => Center(child: Text('Error: $err')),
            data: (metrics) {
              return RefreshIndicator(
                onRefresh: () async {
                  ref.invalidate(dashboardMetricsProvider);
                  await ref.read(dashboardMetricsProvider(null).future);
                },
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    // Metrics Grid
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.5,
                      children: [
                        _MetricCard(
                          title: 'Revenue',
                          value: currencyFormatter.format(metrics.revenue),
                          icon: Icons.attach_money,
                          color: Colors.green,
                        ),
                        _MetricCard(
                          title: 'Orders',
                          value: '${metrics.orderCount}',
                          icon: Icons.receipt_long,
                          color: Colors.blue,
                        ),
                        _MetricCard(
                          title: 'Avg Order',
                          value: currencyFormatter.format(metrics.averageOrderValue),
                          icon: Icons.analytics,
                          color: Colors.orange,
                        ),
                        _MetricCard(
                          title: 'Items Sold',
                          value: '${metrics.itemsSold}',
                          icon: Icons.shopping_basket,
                          color: Colors.purple,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // placeholder for charts
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hourly Sales (Mock)', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 24),
                            SizedBox(
                              height: 200,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  maxY: 20,
                                  barGroups: [
                                    BarChartGroupData(x: 10, barRods: [BarChartRodData(toY: 8, color: colorScheme.primary)]),
                                    BarChartGroupData(x: 11, barRods: [BarChartRodData(toY: 10, color: colorScheme.primary)]),
                                    BarChartGroupData(x: 12, barRods: [BarChartRodData(toY: 14, color: colorScheme.primary)]),
                                    BarChartGroupData(x: 13, barRods: [BarChartRodData(toY: 15, color: colorScheme.primary)]),
                                    BarChartGroupData(x: 14, barRods: [BarChartRodData(toY: 13, color: colorScheme.primary)]),
                                    BarChartGroupData(x: 15, barRods: [BarChartRodData(toY: 10, color: colorScheme.primary)]),
                                  ],
                                  titlesData: const FlTitlesData(
                                    leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: color.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 20, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: color.withOpacity(0.8),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
