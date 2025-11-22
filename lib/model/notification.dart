class AppNotification {
  final String notificationId;
  final String? postId;
  final String? commentId;
  final String senderUsername;
  final String receiverUsername;
  final bool isPostNotification;
  final bool isCommentNotification;
  final bool isUpvoteNotification;
  final bool isReplyNotification;
  final String title;
  final String description;
  final DateTime createdAt;
  final bool isRead;
  final int avatarId;

  AppNotification({

    required this.notificationId,
    required this.postId,
    this.commentId,
    required this.senderUsername,
    required this.receiverUsername,
    required this.isPostNotification,
    required this.isCommentNotification,
    required this.isUpvoteNotification,
    required this.isReplyNotification,
    required this.title,
    required this.description,
    required this.createdAt,
    this.isRead = false,
    required this.avatarId, // Added to constructor
  });

  // Update toJson and fromJson to include avatarId
  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'postId': postId,
      'commentId': commentId,
      'senderUsername': senderUsername,
      'receiverUsername': receiverUsername,
      'isPostNotification': isPostNotification,
      'isCommentNotification': isCommentNotification,
      'isUpvoteNotification': isUpvoteNotification,
      'isReplyNotification': isReplyNotification,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'isRead': isRead,
      'avatarId': avatarId,
    };
  }

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      notificationId: json['notification_id']?.toString() ?? '',
      postId: json['post_id']?.toString(),
      commentId: json['comment_id']?.toString(),
      senderUsername: json['sender_username'] ?? json['senderUserName'] ?? '',
      receiverUsername:
          json['receiver_username'] ?? json['receiverUserName'] ?? '',
      isPostNotification: json['is_post_notification'] ?? false,
      isCommentNotification: json['is_comment_notification'] ?? false,
      isUpvoteNotification: json['is_upvote_notification'] ?? false,
      isReplyNotification: json['is_reply_notification'] ?? false,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
      isRead: json['is_read'] ?? false,
      avatarId:
          json['avatarId'] ??
          json['avatar_id'] ??
          1, // fallback to default avatar
    );
  }

  // Update copyWith to include avatarId
  // --- In AppNotification Class ---
AppNotification copyWith({
  String? notificationId,
  String? postId,
  String? commentId,
  String? senderUsername,
  String? receiverUsername,
  bool? isPostNotification,
  bool? isCommentNotification,
  bool? isUpvoteNotification,
  bool? isReplyNotification,
  String? title,
  String? description,
  DateTime? createdAt,
  // This is the variable you'll most often use to trigger the state change
  bool? isRead, 
  int? avatarId,
}) {
  return AppNotification(
    notificationId: notificationId ?? this.notificationId,
    postId: postId ?? this.postId,
    commentId: commentId ?? this.commentId,
    senderUsername: senderUsername ?? this.senderUsername,
    receiverUsername: receiverUsername ?? this.receiverUsername,
    isPostNotification: isPostNotification ?? this.isPostNotification,
    isCommentNotification:
        isCommentNotification ?? this.isCommentNotification,
    isUpvoteNotification: isUpvoteNotification ?? this.isUpvoteNotification,
    isReplyNotification: isReplyNotification ?? this.isReplyNotification,
    title: title ?? this.title,
    description: description ?? this.description,
    createdAt: createdAt ?? this.createdAt,
    // When marking a single notification, you'd call copyWith(isRead: true)
    isRead: isRead ?? this.isRead, 
    avatarId: avatarId ?? this.avatarId,
  );
}
}
