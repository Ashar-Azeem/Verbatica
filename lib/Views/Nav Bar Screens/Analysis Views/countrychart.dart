import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Countrychart extends StatefulWidget {
  const Countrychart({
    required this.countryData,
    required this.numberOfComments,
    required this.countries,
    super.key,
  });

  final int numberOfComments;
  final List<BarChartGroupData> countryData;
  final List<String> countries;

  @override
  State<Countrychart> createState() => _CountrychartState();
}

class _CountrychartState extends State<Countrychart>
    with TickerProviderStateMixin {
  int? _touchedIndex;
  late AnimationController _chartController;
  late Animation<double> _chartScaleAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Chart entrance animation
    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();

    _chartScaleAnimation = CurvedAnimation(
      parent: _chartController,
      curve: Curves.easeOutBack,
    );

    // Pulse animation for touch effect
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _chartController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  double _calculateInterval(double maxValue) {
    if (maxValue <= 50) return 10;
    if (maxValue <= 200) return 20;
    if (maxValue <= 500) return 50;
    return 100;
  }

  List<BarChartGroupData> _getBarGroups() {
    final theme = Theme.of(context);
    return widget.countryData.map((barGroup) {
      final isTouched = barGroup.x == _touchedIndex;
      final color = _getColor(barGroup.x);

      return BarChartGroupData(
        x: barGroup.x,
        barRods: [
          BarChartRodData(
            toY: barGroup.barRods.first.toY,
            width: isTouched ? _pulseAnimation.value * 22 : 18,
            color: isTouched ? theme.colorScheme.secondary : color,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(6),
              topRight: Radius.circular(6),
            ),
          ),
        ],
        showingTooltipIndicators: isTouched ? [0] : [],
      );
    }).toList();
  }

  Color _getColor(int index) {
    final colors = [
      const Color(0xFF3366CC),
      const Color(0xFFDC3912),
      const Color(0xFFFF9900),
      const Color(0xFF109618),
      const Color(0xFF990099),
      const Color(0xFF0099C6),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ScaleTransition(
      scale: _chartScaleAnimation,
      child: SizedBox(
        height: 300, // Increased height for better spacing
        child: Card(
          elevation: 8,
          shadowColor: theme.shadowColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: theme.cardColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 16),

                  // Main chart area
                  Expanded(
                    child: BarChart(
                      BarChartData(
                        maxY: widget.numberOfComments.toDouble(),
                        barGroups: _getBarGroups(),
                        alignment: BarChartAlignment.spaceAround,
                        groupsSpace: 12,
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: _calculateInterval(
                            widget.numberOfComments.toDouble(),
                          ),
                          getDrawingHorizontalLine:
                              (value) => FlLine(
                                color: theme.dividerColor.withOpacity(0.3),
                                strokeWidth: 1,
                                dashArray: [4, 4],
                              ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: _calculateInterval(
                                widget.numberOfComments.toDouble(),
                              ),
                              getTitlesWidget:
                                  (value, _) => Text(
                                    value.toInt().toString(),
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.textTheme.bodySmall?.color
                                          ?.withOpacity(0.7),
                                    ),
                                  ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    value.toInt() < widget.countries.length
                                        ? widget.countries[value.toInt()]
                                        : '',
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.textTheme.bodySmall?.color
                                          ?.withOpacity(0.7),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                        ),
                        barTouchData: BarTouchData(
                          enabled: true,
                          touchCallback: (FlTouchEvent event, response) {
                            if (event.isInterestedForInteractions &&
                                response != null &&
                                response.spot != null) {
                              setState(() {
                                _touchedIndex =
                                    response.spot!.touchedBarGroupIndex;
                                if (!_pulseController.isAnimating) {
                                  _pulseController.repeat(reverse: true);
                                }
                              });
                            } else {
                              setState(() {
                                _touchedIndex = null;
                                _pulseController.stop();
                                _pulseController.reset();
                              });
                            }
                          },
                          touchTooltipData: BarTouchTooltipData(
                            tooltipMargin: 12,
                            // tooltipBgColor: theme.colorScheme.surface,
                            getTooltipItem: (group, groupIndex, rod, rodIndex) {
                              return BarTooltipItem(
                                '${widget.countries[group.x]}\n',
                                TextStyle(
                                  color: theme.textTheme.bodyLarge?.color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                children: [
                                  TextSpan(
                                    text:
                                        '${rod.toY.toStringAsFixed(0)} comments',
                                    style: TextStyle(
                                      color: theme.textTheme.bodyMedium?.color
                                          ?.withOpacity(0.7),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
