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
  final bool isSeenByModerator;
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
    required this.isSeenByModerator,
    required this.reportStatus,
    this.adminFeedback,
  });

  // Factory constructor from JSON
  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      reportId: json['reportId'],
      reporterUserId: json['reporterUserId'],
      isPostReport: json['isPostReport'],
      isCommentReport: json['isCommentReport'],
      isUserReport: json['isUserReport'],
      postId: json['postId'],
      commentId: json['commentId'],
      reportedUserId: json['reportedUserId'],
      reportContent: json['reportContent'],
      reportTime: DateTime.parse(json['reportTime']),
      isSeenByModerator: json['isSeenByModerator'],
      reportStatus: json['reportStatus'],
      adminFeedback: json['adminFeedback'],
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
      'isSeenByModerator': isSeenByModerator,
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
