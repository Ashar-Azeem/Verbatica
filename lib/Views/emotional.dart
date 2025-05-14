import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class EmotionalChart extends StatefulWidget {
  const EmotionalChart({
    required this.dataforgraph,
    required this.value,
    required this.index,
    super.key,
  });
  final double value;
  final int index;
  final List<String> dataforgraph;

  @override
  State<EmotionalChart> createState() => _EmotionalChartState();
}

class _EmotionalChartState extends State<EmotionalChart>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _chartController;
  late AnimationController _indicatorsController;

  int touchedIndex = -1;

  final LinearGradient _backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color.fromARGB(255, 67, 118, 138).withOpacity(0.9),
      const Color.fromARGB(255, 67, 118, 138).withOpacity(0.6),
    ],
  );

  @override
  void initState() {
    super.initState();

    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _indicatorsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
  }

  @override
  void dispose() {
    _chartController.dispose();
    _indicatorsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: Card(
        elevation: 8,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: _backgroundGradient,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.5),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _chartController,
                      curve: const Interval(
                        0.1,
                        0.6,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                  ),
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _chartController,
                        curve: const Interval(0.1, 0.6, curve: Curves.easeIn),
                      ),
                    ),
                    child: Text(
                      widget.index == 1
                          ? 'Emotional Distribution Analysis'
                          : 'Gender Distribution Analysis',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Chart with more space
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(
                          touchCallback: (
                            FlTouchEvent event,
                            pieTouchResponse,
                          ) {
                            setState(() {
                              if (!event.isInterestedForInteractions ||
                                  pieTouchResponse == null ||
                                  pieTouchResponse.touchedSection == null) {
                                touchedIndex = -1;
                                return;
                              }
                              touchedIndex =
                                  pieTouchResponse
                                      .touchedSection!
                                      .touchedSectionIndex;
                            });
                          },
                        ),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 2,
                        centerSpaceRadius: 70,
                        sections: _buildSections(widget.dataforgraph),
                      ),
                    ),
                  ),
                ),

                // Indicators with scroll if needed
                SizedBox(
                  height: 100,
                  child: _buildIndicators(widget.dataforgraph),
                ),

                // Caption
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.5),
                    end: Offset.zero,
                  ).animate(
                    CurvedAnimation(
                      parent: _chartController,
                      curve: const Interval(
                        0.3,
                        0.8,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                  ),
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _chartController,
                        curve: const Interval(0.3, 0.8, curve: Curves.easeIn),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        widget.index == 1
                            ? 'Distribution of emotions in comments'
                            : 'Distribution of genders in comments',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
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

  List<PieChartSectionData> _buildSections(List<String> emotions) {
    return List.generate(emotions.length, (index) {
      final isTouched = index == touchedIndex;
      final double fontSize = isTouched ? 14 : 12;
      final double radius =
          isTouched ? 60 : 45; // Fixed enlarged size when touched

      return PieChartSectionData(
        color: _getColor(index),
        value: widget.value * (0.8 + (math.Random().nextDouble() * 0.4)),
        title: '${widget.value.toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows:
              isTouched
                  ? [
                    const Shadow(
                      blurRadius: 8,
                      color: Colors.black26,
                      offset: Offset(0, 2),
                    ),
                  ]
                  : [],
        ),
        badgeWidget: isTouched ? _buildBadge(emotions[index]) : null,
        badgePositionPercentageOffset: 1.2,
      );
    });
  }

  Widget _buildBadge(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 2)),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildIndicators(List<String> emotions) {
    if (emotions.length > 5) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(emotions.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: _buildIndicatorItem(emotions, index),
            );
          }),
        ),
      );
    }

    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 8,
      children: List.generate(emotions.length, (index) {
        return _buildIndicatorItem(emotions, index);
      }),
    );
  }

  Widget _buildIndicatorItem(List<String> emotions, int index) {
    final isSelected = index == touchedIndex;
    final start = 0.3 + (0.7 / emotions.length * index);
    final end = start + (0.7 / emotions.length);

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _indicatorsController,
          curve: Interval(
            start.clamp(0.0, 1.0),
            end.clamp(0.0, 1.0),
            curve: Curves.easeOutCirc,
          ),
        ),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: _indicatorsController,
          curve: Interval(
            start.clamp(0.0, 1.0),
            end.clamp(0.0, 1.0),
            curve: Curves.easeIn,
          ),
        ),
        child: GestureDetector(
          onTap: () {
            setState(() {
              touchedIndex = isSelected ? -1 : index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? _getColor(index).withOpacity(0.2)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? _getColor(index) : Colors.white30,
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getColor(index),
                    shape: BoxShape.circle,
                    boxShadow:
                        isSelected
                            ? [
                              BoxShadow(
                                color: _getColor(index).withOpacity(0.6),
                                blurRadius: 8,
                                spreadRadius: 1,
                              ),
                            ]
                            : null,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  emotions[index],
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.white70,
                    fontSize: 12,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getColor(int index) {
    final colors = [
      const Color(0xFF3366CC),
      const Color(0xFFDC3912),
      const Color(0xFFFF9900),
      const Color(0xFF109618),
      const Color(0xFF990099),
      const Color(0xFF0099C6),
      const Color(0xFFDD4477),
      const Color(0xFF66AA00),
      const Color(0xFFB82E2E),
      const Color(0xFF316395),
    ];
    return colors[index % colors.length];
  }
}
