class Report {
  final String reportId;
  final String reporterUserId;
  final bool isPostReport;
  final bool isCommentReport;
  final bool isUserReport;
  final String? postId;
  final String? commentId;
  final String? reportedUserId;
  final String reportContent;   
  final DateTime reportTime;
  final String
  reportStatus; // 'pending', 'under_review', 'resolved', 'rejected'
  final String? adminFeedback;

  Report({
    required this.reportId,
    required this.reporterUserId,
    required this.isPostReport,
    required this.isCommentReport,
    required this.isUserReport,
    this.postId,
    this.commentId,
    this.reportedUserId,
    required this.reportContent,
    required this.reportTime,
    required this.reportStatus,
    this.adminFeedback,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      reportId: json['report_id']?.toString() ?? '',
      reporterUserId: json['reporter_user_id']?.toString() ?? '',
      isPostReport: json['is_post_report'] ?? false,
      isCommentReport: json['is_comment_report'] ?? false,
      isUserReport: json['is_user_report'] ?? false,
      postId: json['post_id']?.toString(),
      commentId: json['comment_id']?.toString(),
      reportedUserId: json['user_id']?.toString(),
      reportContent: json['report_content'] ?? '',
      reportTime:
          json['report_time'] != null
              ? DateTime.parse(json['report_time'])
              : DateTime.now(),
      reportStatus: json['report_status'] ?? 'Pending',
      adminFeedback: json['admin_feedback'],
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'reportId': reportId,
      'reporterUserId': reporterUserId,
      'isPostReport': isPostReport,
      'isCommentReport': isCommentReport,
      'isUserReport': isUserReport,
      'postId': postId,
      'commentId': commentId,
      'reportedUserId': reportedUserId,
      'reportContent': reportContent,
      'reportTime': reportTime.toIso8601String(),
      'reportStatus': reportStatus,
      'adminFeedback': adminFeedback,
    };
  }

  // Get report type as string for display
  String get reportType {
    if (isPostReport) return 'Post';
    if (isCommentReport) return 'Comment';
    if (isUserReport) return 'User';
    return 'Unknown';
  }
}
