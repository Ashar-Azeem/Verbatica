import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Analysis%20Views/TrendGraph.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Analysis%20Views/countrychart.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Analysis%20Views/emotional.dart';

class ClusterDetailScreen extends StatefulWidget {
  final String clusterTitle;
  final int postId;
  final int numberOfComments;

  const ClusterDetailScreen({
    super.key,
    required this.clusterTitle,
    required this.numberOfComments,
    required this.postId,
  });

  @override
  State<ClusterDetailScreen> createState() => _ClusterDetailScreenState();
}

class _ClusterDetailScreenState extends State<ClusterDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late AnimationController _chartController;
  bool isLoading = true;
  AnalyticsData? analytics;

  @override
  void initState() {
    super.initState();

    // Main screen animations
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

    // Chart-specific animations
    _chartController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    fetchAnalytics(widget.postId, widget.clusterTitle);
  }

  void fetchAnalytics(int postId, String cluster) async {
    AnalyticsData fetchAnalytics = await ApiService().fetchClusterAnalytics(
      postId,
      cluster,
    );
    setState(() {
      analytics = fetchAnalytics;
      isLoading = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
      _chartController.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _chartController.dispose();
    super.dispose();
  }

  Widget _buildHeaderSection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final containerColor = colorScheme.surface;

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, -0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      ),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Card(
          color: containerColor,
          elevation: 4,
          shadowColor: colorScheme.shadow.withOpacity(0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.clusterTitle,
                  style: TextStyle(
                    color: textTheme.titleLarge?.color ?? colorScheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.comment_rounded,
                      color: colorScheme.primary,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.numberOfComments.toInt()} comments',
                      style: TextStyle(
                        color:
                            textTheme.bodyMedium?.color ??
                            colorScheme.onSurfaceVariant,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(-0.5, 0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
        ),
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Text(
            title,
            style: TextStyle(
              color: textTheme.titleMedium?.color ?? colorScheme.onSurface,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> generateCountryData() {
    final countries = analytics!.countries.map((c) => c.country).toList();
    final counts = analytics!.countries.map((c) => c.count.toDouble()).toList();

    // If no countries or all counts are 0, return default small bars
    if (counts.isEmpty || counts.every((c) => c == 0)) {
      return List.generate(countries.length, (index) {
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: 1.0,
              color: _getColor(index),
              width: 16,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
        );
      });
    }

    return List.generate(countries.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: counts[index],
            color: _getColor(index),
            width: 16,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    });
  }

  Color _getColor(int index) {
    final colors = [
      const Color(0xFF4285F4),
      const Color(0xFF34A853),
      const Color(0xFFFBBC05),
      const Color(0xFFEA4335),
      const Color(0xFF673AB7),
      const Color(0xFFFF6D00),
      const Color(0xFF00ACC1),
      const Color(0xFF8BC34A),
    ];
    return colors[index % colors.length];
  }

  List<double> calculateEmotionPercentagesWithTotal(
    AnalyticsData analytics,
    List<String> emotionalTitles,
    int totalComments,
  ) {
    if (totalComments == 0) return List.filled(emotionalTitles.length, 0.0);

    return emotionalTitles.map((title) {
      final emotion = analytics.emotions.firstWhere(
        (e) => e.emotion == title,
        orElse: () => EmotionStat(emotion: title, count: 0),
      );
      return (emotion.count / totalComments) * 100;
    }).toList();
  }

  List<double> calculateGenderPercentagesWithTotal(
    AnalyticsData analytics,
    List<String> genderTitle,
    int totalComments,
  ) {
    if (totalComments == 0) return List.filled(genderTitle.length, 0.0);

    return genderTitle.map((title) {
      final emotion = analytics.genders.firstWhere(
        (e) => e.gender == title,
        orElse: () => GenderStat(gender: title, count: 0),
      );
      return (emotion.count / totalComments) * 100;
    }).toList();
  }

  List<String> getCountryLabels() {
    return analytics!.countries.map((c) => c.country).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final containerColor = colorScheme.surface;
    List<String> emotionalTitles = ['Happy', 'Sad', 'Angry', 'Neutral'];
    List<String> genderTitles = ['Male', 'Female'];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Cluster Analytics', style: TextStyle()),
        centerTitle: true,
        backgroundColor: containerColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
      ),
      body:
          isLoading
              ? Center(
                child: LoadingAnimationWidget.dotsTriangle(
                  color: Theme.of(context).colorScheme.primary,
                  size: 13.w,
                ),
              )
              : FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeaderSection(),
                        const SizedBox(height: 24),

                        _buildSectionTitle('📊 Emotional Analysis'),
                        const SizedBox(height: 8),
                        EmotionalChart(
                          emotionValues: calculateEmotionPercentagesWithTotal(
                            analytics!,
                            emotionalTitles,
                            widget.numberOfComments.toInt(),
                          ),
                          dataforgraph: emotionalTitles,
                          index: 1,
                        ),

                        const SizedBox(height: 24),

                        _buildSectionTitle('📈 Cluster Engagement Trend'),
                        const SizedBox(height: 8),
                        ClusterTrendChart(data: analytics!.trends),

                        const SizedBox(height: 24),

                        _buildSectionTitle('🌍 Country-Based Distribution'),
                        const SizedBox(height: 8),
                        Countrychart(
                          countries: getCountryLabels(),
                          countryData: generateCountryData(),
                          numberOfComments: widget.numberOfComments,
                        ),
                        const SizedBox(height: 24),

                        _buildSectionTitle('🚻 Gender Analysis'),
                        const SizedBox(height: 8),
                        EmotionalChart(
                          emotionValues: calculateGenderPercentagesWithTotal(
                            analytics!,
                            genderTitles,
                            widget.numberOfComments.toInt(),
                          ),
                          dataforgraph: genderTitles,
                          index: 2,
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}

class AnalyticsData {
  final int postId;
  final List<EmotionStat> emotions;
  final List<CountryStat> countries;
  final List<GenderStat> genders;
  final Map<DateTime, int> trends;

  AnalyticsData({
    required this.trends,
    required this.postId,
    required this.emotions,
    required this.countries,
    required this.genders,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      postId: json['postId'] as int,
      emotions:
          (json['emotions'] as List<dynamic>)
              .map((e) => EmotionStat.fromJson(e))
              .toList(),
      countries:
          (json['countries'] as List<dynamic>)
              .map((e) => CountryStat.fromJson(e))
              .toList(),
      genders:
          (json['genders'] as List<dynamic>)
              .map((e) => GenderStat.fromJson(e))
              .toList(),
      trends:
          (() {
            final Map<DateTime, int> trendMap = {};
            if (json['clusterTrend'] != null && json['clusterTrend'] is Map) {
              (json['clusterTrend'] as Map<String, dynamic>).forEach((
                key,
                value,
              ) {
                trendMap[DateTime.parse(key).toLocal()] = value as int;
              });
            }
            return trendMap;
          })(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'postId': postId,
      'emotions': emotions.map((e) => e.toJson()).toList(),
      'countries': countries.map((e) => e.toJson()).toList(),
      'genders': genders.map((e) => e.toJson()).toList(),
    };
  }
}

class EmotionStat {
  final String emotion;
  final int count;

  EmotionStat({required this.emotion, required this.count});

  factory EmotionStat.fromJson(Map<String, dynamic> json) {
    return EmotionStat(
      emotion: json['emotion'] as String,
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'emotion': emotion, 'count': count};
  }
}

class CountryStat {
  final String country;
  final int count;

  CountryStat({required this.country, required this.count});

  factory CountryStat.fromJson(Map<String, dynamic> json) {
    return CountryStat(
      country: json['country'] as String,
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'country': country, 'count': count};
  }
}

class GenderStat {
  final String gender;
  final int count;

  GenderStat({required this.gender, required this.count});

  factory GenderStat.fromJson(Map<String, dynamic> json) {
    return GenderStat(
      gender: json['gender'] as String,
      count: json['count'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'gender': gender, 'count': count};
  }
}
