import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String postId; // New required field
  final String text;
  final String author;
  final String profile;
  final String? parentId;
  final List<Comment> allReplies;
  final DateTime uploadTime;
  final int upVotes;
  final int downVotes;

  const Comment({
    required this.id,
    required this.postId, // Added here
    required this.text,
    required this.author,
    required this.profile,
    this.parentId,
    this.allReplies = const [],
    required this.uploadTime,
    required this.upVotes,
    required this.downVotes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'postId': postId, // Added here
      'text': text,
      'author': author,
      'profile': profile,
      'parentId': parentId,
      'allReplies': allReplies.map((e) => e.toJson()).toList(),
      'uploadTime': uploadTime.toIso8601String(),
      'upVotes': upVotes,
      'downVotes': downVotes,
    };
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
    int? upVotes,
    int? downVotes,
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
      upVotes: upVotes ?? this.upVotes,
      downVotes: downVotes ?? this.downVotes,
    );
  }

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      postId: json['postId'], // Added here
      text: json['text'],
      author: json['author'],
      profile: json['profile'],
      parentId: json['parentId'],
      allReplies:
          (json['allReplies'] as List).map((e) => Comment.fromJson(e)).toList(),
      uploadTime: DateTime.parse(json['uploadTime']),
      upVotes: json['upVotes'],
      downVotes: json['downVotes'],
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
    postId, // Added here
    text,
    author,
    profile,
    parentId,
    allReplies,
    uploadTime,
    upVotes,
    downVotes,
  ];
}
