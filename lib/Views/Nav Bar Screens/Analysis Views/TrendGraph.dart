// cluster_trend_chart.dart
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sizer/sizer.dart';

class ClusterTrendChart extends StatelessWidget {
  final Map<DateTime, int> data;

  const ClusterTrendChart({super.key, required this.data});

  String _monthName(int month) {
    const names = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return names[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (data.isEmpty) {
      return const Center(child: Text('No data available'));
    }

    // Sort the data by date
    final sortedKeys = data.keys.toList()..sort();

    // Determine aggregation interval
    final totalDays = sortedKeys.length;
    Map<DateTime, int> aggregatedData = {};
    // ignore: unused_local_variable
    String xLabelType = 'day';

    if (totalDays <= 14) {
      aggregatedData = data;
      xLabelType = 'day';
    } else if (totalDays <= 90) {
      for (var entry in data.entries) {
        final weekStart = entry.key.subtract(
          Duration(days: entry.key.weekday - 1),
        );
        aggregatedData.update(
          weekStart,
          (value) => value + entry.value,
          ifAbsent: () => entry.value,
        );
      }
      xLabelType = 'week';
    } else {
      for (var entry in data.entries) {
        final monthStart = DateTime(entry.key.year, entry.key.month, 1);
        aggregatedData.update(
          monthStart,
          (value) => value + entry.value,
          ifAbsent: () => entry.value,
        );
      }
      xLabelType = 'month';
    }

    final aggKeys = aggregatedData.keys.toList()..sort();
    final minY = 0;
    final maxY =
        (aggregatedData.values.isNotEmpty
            ? aggregatedData.values.reduce((a, b) => a > b ? a : b)
            : 10) +
        2;

    final yInterval = maxY <= 5 ? 1 : (maxY / 5).ceilToDouble();

    // X-axis points: maximum 5 labels
    final xLabelsCount = 4;
    final step =
        aggKeys.length <= xLabelsCount
            ? 1
            : (aggKeys.length / (xLabelsCount - 1)).floor();
    final xLabelIndexes = List.generate(
      xLabelsCount,
      (i) => (i * step).clamp(0, aggKeys.length - 1),
    );

    return Center(
      child: SizedBox(
        width: 100.w, // 90% of screen width
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 4,
          // Removed margin to utilize full 90% width
          child: Padding(
            padding: const EdgeInsets.only(
              left: 2,
              top: 20,
              bottom: 12,
              right: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40.h,
                  child: Center(
                    child: LineChart(
                      LineChartData(
                        minY: minY.toDouble(),
                        maxY: maxY.toDouble(),
                        gridData: FlGridData(
                          horizontalInterval: yInterval.toDouble(),
                        ),
                        titlesData: FlTitlesData(
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 36,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                int index = value.toInt();

                                if (index < 0 || index >= aggKeys.length)
                                  return const SizedBox.shrink();
                                if (!xLabelIndexes.contains(index))
                                  return const SizedBox.shrink();

                                DateTime date = aggKeys[index];
                                String label = "";

                                // Check if all data entries are within the same month
                                bool sameMonth = aggKeys.every(
                                  (d) =>
                                      d.year == aggKeys.first.year &&
                                      d.month == aggKeys.first.month,
                                );

                                // ---- LABEL LOGIC ----
                                if (sameMonth) {
                                  // Example: 12 Nov
                                  label =
                                      "${date.day} ${_monthName(date.month)}";
                                } else {
                                  // Example: Nov 2025
                                  label =
                                      "${_monthName(date.month)} ${date.year}";
                                }

                                return SideTitleWidget(
                                  meta: meta,
                                  space: 8,
                                  fitInside:
                                      SideTitleFitInsideData.fromTitleMeta(
                                        meta,
                                        distanceFromEdge: 0,
                                      ),

                                  child: Text(
                                    label,
                                    style: TextStyle(
                                      color: colorScheme.onSurface,
                                      fontSize: 12,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: yInterval.toDouble(),
                              reservedSize: 32,
                              getTitlesWidget: (value, meta) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    top: value == maxY ? 0 : 0,
                                    bottom: value == minY ? 0 : 0,
                                    right: 2.w,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      value.toInt().toString(),
                                      style: TextStyle(
                                        color: colorScheme.onSurface,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                          show: true,
                          border: Border(
                            left: BorderSide(
                              color: colorScheme.onSurface.withOpacity(0.2),
                            ),
                            bottom: BorderSide(
                              color: colorScheme.onSurface.withOpacity(0.2),
                            ),
                            top: BorderSide(color: Colors.transparent),
                            right: BorderSide(color: Colors.transparent),
                          ),
                        ),
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(
                              aggKeys.length,
                              (index) => FlSpot(
                                index.toDouble(),
                                aggregatedData[aggKeys[index]]!.toDouble(),
                              ),
                            ),
                            isCurved: true,
                            barWidth: 3,
                            color: colorScheme.primary,
                            dotData: FlDotData(show: true),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
