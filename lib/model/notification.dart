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
    this.postId,
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
      notificationId: json['notificationId'] as String,
      postId: json['postId'] as String,
      commentId: json['commentId'] as String,
      senderUsername: json['senderUsername'] as String,
      receiverUsername: json['receiverUsername'] as String,
      isPostNotification: json['isPostNotification'] as bool,
      isCommentNotification: json['isCommentNotification'] as bool,
      isUpvoteNotification: json['isUpvoteNotification'] as bool,
      isReplyNotification: json['isReplyNotification'] as bool,
      title: json['title'] as String,
      description: json['description'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['isRead'] as bool,
      avatarId: json['avatarId'] as int,
    );
  }

  // Update copyWith to include avatarId
  AppNotificationcopyWith({
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
      isRead: isRead ?? this.isRead,
      avatarId: avatarId ?? this.avatarId,
    );
  }
}
