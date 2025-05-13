import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String postId;
  final String text;
  final String author;
  final String profile;
  final String? parentId;
  final List<Comment> allReplies;
  final DateTime uploadTime;
  final List<String> upVoteUserIds;
  final List<String> downVoteUserIds;
  final String? cluster;

  const Comment({
    required this.id,
    required this.postId,
    required this.text,
    required this.author,
    required this.profile,
    this.parentId,
    this.allReplies = const [],
    required this.uploadTime,
    this.upVoteUserIds = const [],
    this.downVoteUserIds = const [],
    this.cluster,
  });

  int get totalUpVotes => upVoteUserIds.length;
  int get totalDownVotes => downVoteUserIds.length;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId,
      'text': text,
      'author': author,
      'profile': profile,
      'parentId': parentId,
      'allReplies': allReplies.map((e) => e.toJson()).toList(),
      'uploadTime': uploadTime.toIso8601String(),
      'upVoteUserIds': upVoteUserIds,
      'downVoteUserIds': downVoteUserIds,
      'cluster': cluster,
    };
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'],
      text: json['text'],
      author: json['author'],
      profile: json['profile'],
      parentId: json['parentId'],
      allReplies:
          (json['allReplies'] as List).map((e) => Comment.fromJson(e)).toList(),
      uploadTime: DateTime.parse(json['uploadTime']),
      upVoteUserIds: List<String>.from(json['upVoteUserIds'] ?? []),
      downVoteUserIds: List<String>.from(json['downVoteUserIds'] ?? []),
      cluster: json['cluster'],
    );
  }

  Comment copyWith({
    String? id,
    String? postId,
    String? text,
    String? author,
    String? profile,
    String? parentId,
    List<Comment>? allReplies,
    DateTime? uploadTime,
    List<String>? upVoteUserIds,
    List<String>? downVoteUserIds,
    String? cluster,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      text: text ?? this.text,
      author: author ?? this.author,
      profile: profile ?? this.profile,
      parentId: parentId ?? this.parentId,
      allReplies: allReplies ?? this.allReplies,
      uploadTime: uploadTime ?? this.uploadTime,
      upVoteUserIds: upVoteUserIds ?? this.upVoteUserIds,
      downVoteUserIds: downVoteUserIds ?? this.downVoteUserIds,
      cluster: cluster ?? this.cluster,
    );
  }

  List<Comment> getPaginatedReplies(int page, int pageSize) {
    int startIndex = page * pageSize;
    int endIndex =
        (startIndex + pageSize) > allReplies.length
            ? allReplies.length
            : startIndex + pageSize;
    return allReplies.sublist(startIndex, endIndex);
  }

  @override
  List<Object?> get props => [
    id,
    postId,
    text,
    author,
    profile,
    parentId,
    allReplies,
    uploadTime,
    upVoteUserIds,
    downVoteUserIds,
    cluster,
  ];
}
