import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:verbatica/BLOC/report/report_bloc.dart';
import 'package:verbatica/BLOC/report/report_state.dart';
import 'package:verbatica/model/report.dart';

class UserReportsScreen extends StatelessWidget {
  const UserReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('My Reports'),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 0,
      ),
      body: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          if (state is ReportLoading) {
            return _buildShimmerLoading();
          } else if (state is ReportLoaded) {
            final reports = state.reports;

            if (reports.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description_outlined,
                      size: 80,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No reports submitted yet',
                      style: TextStyle(color: Colors.grey[400], fontSize: 18),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: reports.length,
              itemBuilder: (context, index) {
                final report = reports[index];
                return _buildReportCard(context, report);
              },
            );
          } else if (state is ReportError) {
            return Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return const Center(
            child: Text(
              'No data available',
              style: TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFF262626),
      highlightColor: const Color(0xFF333333),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder:
            (_, __) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, Report report) {
    // Enhanced status colors with higher saturation and better visibility
    final Map<String, Color> statusColors = {
      'pending': const Color(0xFF78909C), // Blue-grey, more visible
      'under_review': const Color(0xFFFFB74D), // Brighter amber
      'resolved': const Color(0xFF4CAF50), // Brighter green
      'rejected': const Color(0xFFEF5350), // Brighter red
    };

    // Format date with timeago
    final timeAgoText = timeago.format(report.reportTime);

    // Keep the original date format for detailed display
    final dateFormatter = DateFormat('MMM d, yyyy - h:mm a');
    final formattedDate = dateFormatter.format(report.reportTime);

    // Determine report type icon
    IconData typeIcon;
    if (report.isPostReport) {
      typeIcon = Icons.article_outlined;
    } else if (report.isCommentReport) {
      typeIcon = Icons.comment_outlined;
    } else {
      typeIcon = Icons.person_outline;
    }

    // Status color for the current report
    final statusColor = statusColors[report.reportStatus] ?? Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      color: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: statusColor,
          width: 1.5, // Slightly thicker border for better visibility
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Report type and date row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(typeIcon, color: Colors.white70, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${report.reportType} Report',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                Tooltip(
                  message: formattedDate,
                  child: Text(
                    timeAgoText,
                    style: TextStyle(color: Colors.grey[400], fontSize: 12),
                  ),
                ),
              ],
            ),

            const Divider(color: Color(0xFF333333), height: 24),

            // Report content
            const Text(
              'Reason:',
              style: TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              report.reportContent,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),

            const SizedBox(height: 16),

            // Status chip - enhanced for better visibility
            Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: statusColor, width: 1),
                  ),
                  child: Text(
                    report.reportStatus.replaceAll('_', ' ').toUpperCase(),
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),

            // Admin feedback section - redesigned for better coherence
            if (report.adminFeedback != null &&
                report.adminFeedback!.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(
                    0xFF252525,
                  ), // Darker background that fits better with the theme
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: const Color(0xFF424242), // Subtle border
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.feedback_outlined,
                          color:
                              statusColor, // Match with the status color for coherence
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Admin Feedback',
                          style: TextStyle(
                            color: statusColor, // Match with the status color
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report.adminFeedback!,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
