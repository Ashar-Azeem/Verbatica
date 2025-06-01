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
      appBar: AppBar(title: const Text('My Reports'), elevation: 0),
      body: BlocBuilder<ReportBloc, ReportState>(
        builder: (context, state) {
          if (state is ReportLoading) {
            return _buildShimmerLoading(context);
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
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No reports submitted yet',
                      style: TextStyle(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withOpacity(0.6),
                        fontSize: 18,
                      ),
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
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            );
          }

          return Center(
            child: Text(
              'No data available',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerLoading(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDarkMode ? const Color(0xFF262626) : const Color(0xFFE0E0E0),
      highlightColor:
          isDarkMode ? const Color(0xFF333333) : const Color(0xFFF5F5F5),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5,
        itemBuilder:
            (_, __) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
      ),
    );
  }

  Widget _buildReportCard(BuildContext context, Report report) {
    // Enhanced status colors that work well in both light and dark themes
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final Map<String, Color> statusColors = {
      'pending': isDarkMode ? const Color(0xFF78909C) : const Color(0xFF5F7C8A),
      'under_review':
          isDarkMode ? const Color(0xFFFFB74D) : const Color(0xFFFF9800),
      'resolved':
          isDarkMode ? const Color(0xFF4CAF50) : const Color(0xFF388E3C),
      'rejected':
          isDarkMode ? const Color(0xFFEF5350) : const Color(0xFFD32F2F),
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
    final statusColor =
        statusColors[report.reportStatus] ??
        Theme.of(context).colorScheme.onSurface.withOpacity(0.6);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      color: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: statusColor, width: 0.8),
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
                    Icon(
                      typeIcon,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${report.reportType} Report',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
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
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),

            Divider(color: Theme.of(context).dividerColor, height: 24),

            // Report content
            Text(
              'Reason:',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              report.reportContent,
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyLarge?.color,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 16),

            // Status chip - enhanced for better visibility
            Row(
              children: [
                Text(
                  'Status: ',
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 14,
                  ),
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
                      color:
                          Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : statusColor,
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
                  color:
                      Theme.of(context).brightness == Brightness.dark
                          ? const Color.fromARGB(255, 26, 39, 49)
                          : Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(8),
                  border:
                      Theme.of(context).brightness == Brightness.light
                          ? Border.all(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          )
                          : null,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.feedback_outlined,
                          color: statusColor,
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          'Admin Feedback',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      report.adminFeedback!,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontSize: 14,
                      ),
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
