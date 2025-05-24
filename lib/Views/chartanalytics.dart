import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/Views/chartanalyticsDetail.dart';
import 'package:verbatica/model/Post.dart';

class ChartsAnalyticsScreen extends StatefulWidget {
  final List<Cluster> clusters;

  const ChartsAnalyticsScreen({super.key, required this.clusters});

  @override
  State<ChartsAnalyticsScreen> createState() => _ChartsAnalyticsScreenState();
}

class _ChartsAnalyticsScreenState extends State<ChartsAnalyticsScreen>
    with TickerProviderStateMixin {
  late List<double> _fixedRandomValues;
  final random = Random();
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fixedRandomValues = List.generate(
      widget.clusters.length,
      (index) => random.nextDouble() * 100,
    );

    // Initialize animations
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    // Start animations after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<ClusterData> _getClusterData() {
    return List.generate(widget.clusters.length, (index) {
      return ClusterData(
        title: widget.clusters[index].title,
        commentCount: _fixedRandomValues[index].round(),
      );
    });
  }

  Color _getColor(int index) {
    final colors = [
      const Color(0xFF4285F4), // Google Blue
      const Color(0xFF34A853), // Google Green
      const Color(0xFFFBBC05), // Google Yellow
      const Color(0xFFEA4335), // Google Red
      const Color(0xFF673AB7), // Deep Purple
      const Color(0xFFFF6D00), // Orange
      const Color(0xFF00ACC1), // Cyan
      const Color(0xFF8BC34A), // Light Green
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    Color containerColor = Color.fromARGB(255, 21, 28, 32);
    final total = _fixedRandomValues.reduce((a, b) => a + b);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : const Color(0xFF2D3748);
    final secondaryTextColor = isDarkMode ? Colors.grey[400] : Colors.grey[600];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cluster Analytics',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
        centerTitle: true,
        backgroundColor: containerColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Container(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Animated Header Card
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, -0.5),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Card(
                        color: containerColor,
                        elevation: 8,
                        shadowColor: Colors.black26,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.only(bottom: 20),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 24.0,
                            horizontal: 16.0,
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.comment_rounded,
                                    color: primaryColor,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Total Comments',
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              AnimatedCount(
                                count: total.round(),
                                duration: const Duration(milliseconds: 1500),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Pie Chart with entry animation
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(-0.5, 0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: containerColor,
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(
                                'Distribution',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: textColor,
                                ),
                              ),
                            ),
                            Center(
                              child: SizedBox(
                                width: 80.w,
                                height: 38.h,
                                child: PieChartWithClusterInfo(
                                  clusters: _getClusterData(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Animated Cluster Legend
                  SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _controller,
                        curve: Curves.easeOutCubic,
                      ),
                    ),
                    child: Card(
                      elevation: 4,
                      shadowColor: Colors.black12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      color: containerColor,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 16.0,
                              top: 16.0,
                              bottom: 8.0,
                            ),
                            child: Text(
                              'Clusters',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                            ),
                          ),
                          ListView.separated(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 8.0,
                            ),
                            itemCount: widget.clusters.length,
                            separatorBuilder:
                                (_, __) => Divider(
                                  color: Color.fromARGB(255, 30, 38, 45),
                                  height: 1,
                                  indent: 16,
                                  endIndent: 16,
                                ),
                            itemBuilder: (context, index) {
                              final cluster = widget.clusters[index];
                              final percentage =
                                  ((_fixedRandomValues[index] / total) * 100)
                                      .round();
                              final count = _fixedRandomValues[index].round();

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ClusterDetailScreen(
                                            clusterTitle: cluster.title,
                                            numberOfComments:
                                                percentage / 100 * total,
                                          ),
                                    ),
                                  );
                                },
                                child: AnimatedListItem(
                                  index: index,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      vertical: 4.0,
                                      horizontal: 8.0,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Color.fromARGB(255, 29, 39, 45),
                                    ),
                                    child: ListTile(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 16.0,
                                            vertical: 10.0,
                                          ),
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: _getColor(
                                            index,
                                          ).withOpacity(0.2),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Container(
                                            width: 24,
                                            height: 24,
                                            decoration: BoxDecoration(
                                              color: _getColor(index),
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: _getColor(
                                                    index,
                                                  ).withOpacity(0.3),
                                                  blurRadius: 8,
                                                  offset: const Offset(0, 2),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      title: Text(
                                        cluster.title,
                                        style: TextStyle(
                                          color: textColor,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Row(
                                        children: [
                                          Icon(
                                            Icons.comment_outlined,
                                            size: 14,
                                            color: secondaryTextColor,
                                          ),
                                          const SizedBox(width: 4),
                                          AnimatedCount(
                                            count: count,
                                            duration: const Duration(
                                              milliseconds: 800,
                                            ),
                                            style: TextStyle(
                                              color: secondaryTextColor,
                                              fontSize: 14,
                                            ),
                                            prefix: '',
                                            suffix: ' comments',
                                          ),
                                        ],
                                      ),
                                      trailing: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: _getColor(
                                            index,
                                          ).withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: AnimatedCount(
                                          count: percentage,
                                          duration: const Duration(
                                            milliseconds: 1000,
                                          ),
                                          style: TextStyle(
                                            color: _getColor(index),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                          suffix: '%',
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ClusterData {
  final String title;
  final int commentCount;

  ClusterData({required this.title, required this.commentCount});
}

class PieChartWithClusterInfo extends StatefulWidget {
  final List<ClusterData> clusters;

  const PieChartWithClusterInfo({super.key, required this.clusters});

  @override
  State<PieChartWithClusterInfo> createState() =>
      _PieChartWithClusterInfoState();
}

class _PieChartWithClusterInfoState extends State<PieChartWithClusterInfo>
    with TickerProviderStateMixin {
  int touchedIndex = -1;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ScaleTransition(
        scale: _scaleAnimation,
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
                      pieTouchResponse.touchedSection!.touchedSectionIndex;
                });
              },
            ),
            borderData: FlBorderData(show: false),
            sectionsSpace: 3,
            centerSpaceRadius: 7.h,
            sections: showingSections(),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    final total = widget.clusters.fold<double>(
      0,
      (sum, cluster) => sum + cluster.commentCount,
    );

    return List.generate(widget.clusters.length, (i) {
      final isTouched = i == touchedIndex;
      final cluster = widget.clusters[i];
      final percentage = (cluster.commentCount / total * 100).round();
      final fontSize = isTouched ? 16.0 : 14.0;
      final radius = isTouched ? 75.0 : 65.0;
      final badgeSize = isTouched ? 55.0 : 45.0;

      return PieChartSectionData(
        color: _getClusterColor(i),
        value: cluster.commentCount.toDouble(),
        title: '$percentage%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black45, blurRadius: 2)],
        ),
        badgeWidget: _ClusterBadge(
          title: cluster.title,
          commentCount: cluster.commentCount,
          color: _getClusterColor(i),
          size: badgeSize * 0.8,
          isTouched: isTouched,
        ),
        badgePositionPercentageOffset: 1.2,
      );
    });
  }

  Color _getClusterColor(int index) {
    final colors = [
      const Color(0xFF4285F4), // Google Blue
      const Color(0xFF34A853), // Google Green
      const Color(0xFFFBBC05), // Google Yellow
      const Color(0xFFEA4335), // Google Red
      const Color(0xFF673AB7), // Deep Purple
      const Color(0xFFFF6D00), // Orange
      const Color(0xFF00ACC1), // Cyan
      const Color(0xFF8BC34A), // Light Green
    ];
    return colors[index % colors.length];
  }
}

class _ClusterBadge extends StatelessWidget {
  final String title;
  final int commentCount;
  final Color color;
  final double size;
  final bool isTouched;

  const _ClusterBadge({
    required this.title,
    required this.commentCount,
    required this.color,
    required this.size,
    required this.isTouched,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: color, width: isTouched ? 3 : 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.2),
            blurRadius: 8,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(size * 0.1),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Comment count - always visible
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  commentCount.toString(),
                  style: TextStyle(
                    fontSize: isTouched ? 14 : 12,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // Flexible space between count and title
              SizedBox(height: size * 0.05),
              // Cluster title - flexible and responsive
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: isTouched ? 10 : 8,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Custom widget for animated counting numbers
class AnimatedCount extends ImplicitlyAnimatedWidget {
  final int count;
  final TextStyle style;
  final String prefix;
  final String suffix;

  const AnimatedCount({
    super.key,
    required this.count,
    required this.style,
    required super.duration,
    this.prefix = '',
    this.suffix = '',
  });

  @override
  ImplicitlyAnimatedWidgetState<ImplicitlyAnimatedWidget> createState() =>
      _AnimatedCountState();
}

class _AnimatedCountState extends AnimatedWidgetBaseState<AnimatedCount> {
  IntTween? _countTween;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _countTween =
        visitor(
              _countTween,
              widget.count,
              (dynamic value) => IntTween(begin: value as int),
            )
            as IntTween?;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.prefix}${_countTween?.evaluate(animation) ?? 0}${widget.suffix}',
      style: widget.style,
    );
  }
}

// Custom widget for staggered list item animations
class AnimatedListItem extends StatelessWidget {
  final int index;
  final Widget child;

  const AnimatedListItem({super.key, required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    final animation = ModalRoute.of(context)!.animation!;
    final intervalStart = 0.3 + (0.05 * index);
    final intervalEnd = intervalStart + 0.4;

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: animation,
          curve: Interval(intervalStart, intervalEnd, curve: Curves.easeOut),
        ),
      ),
      child: FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Interval(intervalStart, intervalEnd, curve: Curves.easeIn),
        ),
        child: child,
      ),
    );
  }
}
