import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String postId;
  final String titleOfThePost;
  final String text;
  final String author;
  final String profile;
  final String? parentId;
  final List<Comment> allReplies;
  final DateTime uploadTime;
  final bool isUpvote;
  final bool isDownvote;
  final int totalUpvotes;
  final int totalDownvotes;
  final String? cluster;

  const Comment({
    required this.id,
    required this.postId,
    required this.titleOfThePost,
    required this.text,
    required this.author,
    required this.profile,
    this.parentId,
    this.allReplies = const [],
    required this.uploadTime,
    required this.isDownvote,
    required this.isUpvote,
    this.totalUpvotes = 0,
    this.totalDownvotes = 0,
    this.cluster,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'text': text,
      'postTitle': titleOfThePost,
      'author': author,
      'profile': profile,
      'parentId': parentId,
      'allReplies': allReplies.map((e) => e.toJson()).toList(),
      'uploadTime': uploadTime.toIso8601String(),
      'isUpvote': isUpvote,
      'isDownVote': isDownvote,
      'totalUpvotes': totalUpvotes,
      'totalDownvotes': totalDownvotes,
      'cluster': cluster,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      text: json['text'],
      titleOfThePost: json['postTitle'],
      author: json['author'],
      profile: json['profile'],
      parentId: json['parentId'],
      allReplies:
          (json['allReplies'] as List).map((e) => Comment.fromJson(e)).toList(),
      uploadTime: DateTime.parse(json['uploadTime']),
      isUpvote: json['isUpVote'],
      isDownvote: json['isDownVote'],
      totalUpvotes: json['totalUpvotes'] ?? 0,
      totalDownvotes: json['totalDownvotes'] ?? 0,
      cluster: json['cluster'],
    );
  }

  Comment copyWith({
    String? id,
    String? postId,
    String? text,
    String? author,
    String? titleOfThePost,
    String? profile,
    String? parentId,
    List<Comment>? allReplies,
    DateTime? uploadTime,
    bool? isUpvote,
    bool? isDownvote,
    int? totalUpvotes,
    int? totalDownvotes,
    String? cluster,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      text: text ?? this.text,
      titleOfThePost: titleOfThePost ?? this.titleOfThePost,
      author: author ?? this.author,
      profile: profile ?? this.profile,
      parentId: parentId ?? this.parentId,
      allReplies: allReplies ?? this.allReplies,
      uploadTime: uploadTime ?? this.uploadTime,
      isUpvote: isUpvote ?? this.isUpvote,
      isDownvote: isDownvote ?? this.isDownvote,
      totalUpvotes: totalUpvotes ?? this.totalUpvotes,
      totalDownvotes: totalDownvotes ?? this.totalDownvotes,
      cluster: cluster ?? this.cluster,
    );
  }

  @override
  List<Object?> get props => [
    id,
    postId,
    text,
    author,
    titleOfThePost,
    profile,
    parentId,
    allReplies,
    uploadTime,
    isUpvote,
    isDownvote,
    totalUpvotes,
    totalDownvotes,
    cluster,
  ];
}
