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

  // Modern gradient background
  final LinearGradient _backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      const Color.fromARGB(255, 67, 118, 138).withOpacity(0.9),
      const Color.fromARGB(255, 67, 118, 138).withOpacity(0.6),
    ],
    stops: const [0.2, 0.9],
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
    final String title =
        widget.index == 1
            ? 'Emotional Distribution Analysis'
            : 'Gender Distribution Analysis';
    final String subtitle =
        widget.index == 1
            ? 'Distribution of emotions in comments'
            : 'Distribution of genders in comments';

    return SizedBox(
      height: 480, // Increased height to prevent overlapping
      child: Card(
        elevation: 12,
        shadowColor: Colors.black38,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: _backgroundGradient,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title Section with improved styling
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Enhanced Chart with better spacing
                Expanded(
                  flex: 2,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (FlTouchEvent event, pieTouchResponse) {
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
                      sectionsSpace: 2.5,
                      centerSpaceRadius: 65,
                      sections: _buildSections(widget.dataforgraph),
                    ),
                  ),
                ),

                // Improved legend with better scrolling and indicators
                SizedBox(
                  height: 120, // Increased height to ensure enough space
                  child: _buildIndicators(widget.dataforgraph),
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
      final double fontSize = isTouched ? 15 : 13;
      final double radius = isTouched ? 65 : 50;

      // Only enlarge the section when touched, no movement animation
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
                    const BoxShadow(
                      color: Colors.black45,
                      blurRadius: 8,
                      spreadRadius: 0,
                    ),
                  ]
                  : [],
        ),
        badgeWidget: isTouched ? _buildBadge(emotions[index]) : null,
        badgePositionPercentageOffset:
            1.3, // Moved further out to avoid overlap
      );
    });
  }

  Widget _buildBadge(String label) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 1,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  Widget _buildIndicators(List<String> emotions) {
    if (emotions.length > 5) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(emotions.length, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: _buildIndicatorItem(emotions, index),
                );
              }),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 14,
        runSpacing: 12,
        children: List.generate(emotions.length, (index) {
          return _buildIndicatorItem(emotions, index);
        }),
      ),
    );
  }

  Widget _buildIndicatorItem(List<String> emotions, int index) {
    final isSelected = index == touchedIndex;

    return GestureDetector(
      onTap: () {
        setState(() {
          touchedIndex = isSelected ? -1 : index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? _getColor(index).withOpacity(0.25)
                  : Colors.black.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isSelected ? _getColor(index) : Colors.white.withOpacity(0.15),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: _getColor(index).withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                  : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: isSelected ? 14 : 12,
              height: isSelected ? 14 : 12,
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
            const SizedBox(width: 8),
            Text(
              emotions[index],
              style: TextStyle(
                color:
                    isSelected ? Colors.white : Colors.white.withOpacity(0.85),
                fontSize: isSelected ? 13 : 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColor(int index) {
    // Enhanced color palette with better contrast and vibrancy
    final colors = [
      const Color(0xFF3498DB), // Blue
      const Color(0xFFE74C3C), // Red
      const Color(0xFFF39C12), // Orange
      const Color(0xFF2ECC71), // Green
      const Color(0xFF9B59B6), // Purple
      const Color(0xFF1ABC9C), // Teal
      const Color(0xFFE84393), // Pink
      const Color(0xFFD35400), // Dark Orange
      const Color(0xFF27AE60), // Emerald
      const Color(0xFF8E44AD), // Violet
    ];
    return colors[index % colors.length];
  }
}
