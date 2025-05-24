import 'dart:math';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/Views/countrychart.dart';
import 'package:verbatica/Views/emotional.dart';

class ClusterDetailScreen extends StatefulWidget {
  final String clusterTitle;
  final double numberOfComments;

  const ClusterDetailScreen({
    super.key,
    required this.clusterTitle,
    required this.numberOfComments,
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
  final Random _random = Random();
  Color containerColor = Color.fromARGB(255, 21, 28, 32);

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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.clusterTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.comment_rounded, color: primaryColor, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.numberOfComments.toInt()} comments',
                      style: TextStyle(color: Colors.grey[300], fontSize: 14),
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
    return SlideTransition(
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
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateCountryData() {
    final countries = ['USA', 'India', 'UK', 'Canada', 'Australia', 'Germany'];
    final maxComments = widget.numberOfComments.toDouble();

    // Ensure we have at least 1 comment per country
    if (maxComments < countries.length) {
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

    // Distribute comments more evenly
    final values = List<double>.filled(countries.length, 0);
    double remaining = maxComments;

    // First pass - give each country at least 1 comment
    for (int i = 0; i < countries.length; i++) {
      values[i] = 1.0;
      remaining -= 1.0;
    }

    // Distribute remaining comments randomly
    while (remaining > 0) {
      final index = _random.nextInt(countries.length);
      final increment = _random.nextInt(5) + 1; // Add 1-5 comments at a time
      values[index] += increment.toDouble();
      remaining -= increment;
      if (remaining < 0) {
        values[index] += remaining; // Adjust if we went over
        remaining = 0;
      }
    }

    return List.generate(countries.length, (index) {
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: values[index],
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

  @override
  Widget build(BuildContext context) {
    final value = _random.nextDouble() * 30 + 10;
    final countryChartData = _generateCountryData();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cluster Analytics'),
        centerTitle: true,
        backgroundColor: containerColor,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderSection(),
                const SizedBox(height: 24),

                _buildSectionTitle('📊 Emotional Analysis'),
                const SizedBox(height: 8),
                EmotionalChart(
                  value: value,
                  dataforgraph: ['Happy', 'Sad', 'Angry', 'Neutral', 'Excited'],
                  index: 1,
                ),

                const SizedBox(height: 24),

                _buildSectionTitle('🌍 Country-Based Distribution'),
                const SizedBox(height: 8),
                Countrychart(
                  countryData: countryChartData,
                  numberOfComments: widget.numberOfComments,
                ),
                const SizedBox(height: 24),

                _buildSectionTitle('🚻 Gender Analysis'),
                const SizedBox(height: 8),
                EmotionalChart(
                  value: value,
                  dataforgraph: ['Male', 'Female', 'Other'],
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
