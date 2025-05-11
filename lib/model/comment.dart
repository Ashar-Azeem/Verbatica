import 'package:equatable/equatable.dart';

class Comment extends Equatable {
  final String id;
  final String text;
  final String author;
  final String profile;
  final String? parentId;
  final List<Comment> allReplies; // Store all replies, regardless of pagination
  final DateTime uploadTime; // Upload time field
  final int upVotes; // Number of upvotes
  final int downVotes; // Number of downvotes

  // Constructor
  Comment({
    required this.id,
    required this.text,
    required this.author,
    required this.profile,
    this.parentId,
    this.allReplies = const [],
    required this.uploadTime, // Initialize upload time
    required this.upVotes, // Initialize upvotes
    required this.downVotes, // Initialize downvotes
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'profile': profile,
      'parentId': parentId,
      'allReplies': allReplies.map((e) => e.toJson()).toList(),
      'uploadTime':
          uploadTime.toIso8601String(), // Save upload time as ISO string
      'upVotes': upVotes,
      'downVotes': downVotes,
    };
  }

  // Create from JSON
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      text: json['text'],
      author: json['author'],
      profile: json['profile'],
      parentId: json['parentId'],
      allReplies:
          (json['allReplies'] as List).map((e) => Comment.fromJson(e)).toList(),
      uploadTime: DateTime.parse(
        json['uploadTime'],
      ), // Parse upload time from ISO string
      upVotes: json['upVotes'],
      downVotes: json['downVotes'],
    );
  }

  // Paginate replies: Returns a limited set of replies
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
