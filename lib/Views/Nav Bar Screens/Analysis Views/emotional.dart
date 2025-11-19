import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class EmotionalChart extends StatefulWidget {
  const EmotionalChart({
    required this.dataforgraph,
    required this.emotionValues,
    required this.index,
    super.key,
  });

  final List<double> emotionValues;
  final int index;
  final List<String> dataforgraph;

  @override
  State<EmotionalChart> createState() => _EmotionalChartState();
}

class _EmotionalChartState extends State<EmotionalChart>
    with TickerProviderStateMixin {
  late AnimationController _chartController;
  late AnimationController _indicatorsController;

  int touchedIndex = -1;

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
    final theme = Theme.of(context);
    final title =
        widget.index == 1
            ? 'Emotional Distribution Analysis'
            : 'Gender Distribution Analysis';
    final subtitle =
        widget.index == 1
            ? 'Distribution of emotions in comments'
            : 'Distribution of genders in comments';

    return LayoutBuilder(
      builder: (context, constraints) {
        return Card(
          elevation: 12,
          shadowColor: theme.shadowColor.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: theme.shadowColor.withOpacity(0.1),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title
                Column(
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color?.withOpacity(
                          0.7,
                        ),
                      ),
                    ),
                    Divider(
                      color: theme.dividerColor.withOpacity(0.3),
                      height: 24,
                    ),
                  ],
                ),

                // Pie Chart
                AspectRatio(
                  aspectRatio: 1.2,
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                response?.touchedSection == null) {
                              touchedIndex = -1;
                            } else {
                              touchedIndex =
                                  response!.touchedSection!.touchedSectionIndex;
                            }
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

                const SizedBox(height: 16),

                // Legend
                _buildIndicators(widget.dataforgraph),
              ],
            ),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _buildSections(List<String> emotions) {
    final theme = Theme.of(context);
    return List.generate(emotions.length, (index) {
      final double fontSize = 13;
      final double radius = 50;

      return PieChartSectionData(
        color: _getColor(index),
        value: widget.emotionValues[index],
        title: '${widget.emotionValues[index].toStringAsFixed(0)}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: theme.colorScheme.onPrimary,
        ),
        badgePositionPercentageOffset: 1.3,
      );
    });
  }

  Widget _buildIndicators(List<String> emotions) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child:
          emotions.length > 5
              ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    emotions.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: _buildIndicatorItem(emotions, index),
                    ),
                  ),
                ),
              )
              : Wrap(
                alignment: WrapAlignment.center,
                spacing: 14,
                runSpacing: 12,
                children: List.generate(
                  emotions.length,
                  (index) => _buildIndicatorItem(emotions, index),
                ),
              ),
    );
  }

  Widget _buildIndicatorItem(List<String> emotions, int index) {
    final theme = Theme.of(context);
    final isSelected = index == touchedIndex;
    final color = _getColor(index);

    return GestureDetector(
      onTap: () {},
      child: AnimatedContainer(
        width: 22.w,
        height: 4.h,
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? color.withOpacity(0.25)
                  : theme.colorScheme.surface.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : theme.dividerColor.withOpacity(0.3),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: isSelected ? 14 : 12,
                height: isSelected ? 14 : 12,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow:
                      isSelected
                          ? [
                            BoxShadow(
                              color: color.withOpacity(0.6),
                              blurRadius: 8,
                              spreadRadius: 1,
                            ),
                          ]
                          : [],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                emotions[index],
                style: TextStyle(
                  color:
                      isSelected
                          ? theme.textTheme.bodyLarge?.color
                          : theme.textTheme.bodyLarge?.color?.withOpacity(0.85),
                  fontSize: isSelected ? 13 : 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getColor(int index) {
    const colors = [
      Color(0xFF3498DB),
      Color(0xFFF39C12),
      Color(0xFFE74C3C),
      Color(0xFF2ECC71),
      Color(0xFF9B59B6),
      Color(0xFF1ABC9C),
      Color(0xFFE84393),
      Color(0xFFD35400),
      Color(0xFF27AE60),
    ];
    return colors[index % colors.length];
  }
}
