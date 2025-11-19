import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String postId;
  final String titleOfThePost;
  final String text;
  final String author;
  final String profile;
  final String commenterGender;
  final String commenterCountry;
  final String? parentId;
  final List<Comment> allReplies;
  final DateTime uploadTime;
  final bool isUpvote;
  final bool isDownvote;
  final int totalUpvotes;
  final int totalDownvotes;
  final String? emotionalTone;
  final String? cluster;

  const Comment({
    required this.commenterGender,
    required this.commenterCountry,
    required this.id,
    required this.emotionalTone,
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

  Map<String, dynamic> toTextHierarchy() {
    return {
      'text': text,
      'allReplies': allReplies.map((reply) => reply.toTextHierarchy()).toList(),
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      emotionalTone: json['emotionalTone'],
      postId: json['postId'].toString(),
      titleOfThePost: json['titleOfThePost'],
      text: json['text'],
      author: json['author'],
      profile: json['profile'],
      commenterGender: json['commenterGender'],
      commenterCountry: json['commenterCountry'],
      parentId: json['parentId'],
      allReplies:
          (json['allReplies'] as List<dynamic>?)
              ?.map((e) => Comment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      uploadTime: DateTime.parse(json['uploadTime']).toLocal(),
      isUpvote: json['isUpVote'] ?? false,
      isDownvote: json['isDownVote'] ?? false,
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
    String? emotionalTone,
    String? gender,
    String? country,
    String? cluster,
  }) {
    return Comment(
      id: id ?? this.id,
      commenterCountry: country ?? commenterCountry,
      commenterGender: gender ?? commenterGender,
      postId: postId ?? this.postId,
      text: text ?? this.text,
      emotionalTone: emotionalTone ?? this.emotionalTone,
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
    emotionalTone,
    isDownvote,
    totalUpvotes,
    totalDownvotes,
    commenterCountry,
    commenterGender,
    cluster,
  ];
}
