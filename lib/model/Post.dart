// ignore_for_file: file_names

import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final String id;
  final String name;
  final int userId; // 👈 Added userId field
  final int avatar;
  final String title;
  final String description;
  final String? postImageLink;
  final String? postVideoLink;
  final bool isDebate;
  final int upvotes;
  final bool isUpVote;
  final bool isDownVote;
  final int downvotes;
  final int comments;
  final DateTime uploadTime;
  final List<String>? clusters;

  const Post({
    required this.id,
    required this.name,
    required this.userId, // 👈 Added to constructor
    required this.avatar,
    required this.title,
    required this.description,
    this.postImageLink,
    this.postVideoLink,
    required this.isDebate,
    required this.upvotes,
    required this.downvotes,
    required this.isUpVote,
    required this.isDownVote,
    required this.comments,
    required this.uploadTime,
    this.clusters,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'userId': userId,
      'avatar': avatar,
      'title': title,
      'description': description,
      'postImageLink': postImageLink,
      'postVideoLink': postVideoLink,
      'isDebate': isDebate,
      'upVote': upvotes,
      'downVotes': downvotes,
      'isUpVote': isUpVote,
      'isDownVote': isDownVote,
      'comments': comments,
      'uploadTime': uploadTime.toIso8601String(),
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      name: json['name'],
      userId: json['userId'],
      avatar: json['avatar'],
      title: json['title'],
      description: json['description'],
      postImageLink: json['postImageLink'],
      postVideoLink: json['postVideoLink'],
      isDebate: json['isDebate'] ?? false,
      upvotes: json['upvotes'] ?? 0,
      downvotes: json['downvotes'] ?? 0,
      isUpVote: json['isUpVote'],
      isDownVote: json['isDownVote'],
      comments: json['comments'] ?? 0,
      uploadTime: DateTime.parse(json['uploadTime']),
      clusters:
          (json['clusters'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );
  }

  Post copyWith({
    String? id,
    String? name,
    int? userId,
    int? avatar,
    String? title,
    String? description,
    String? postImageLink,
    String? postVideoLink,
    bool? isDebate,
    int? upvotes,
    int? downvotes,
    bool? isUpVote,
    bool? isDownVote,
    int? comments,
    DateTime? uploadTime,
  }) {
    return Post(
      id: id ?? this.id,
      name: name ?? this.name,
      userId: userId ?? this.userId, // 👈 Added here
      avatar: avatar ?? this.avatar,
      title: title ?? this.title,
      description: description ?? this.description,
      postImageLink: postImageLink ?? this.postImageLink,
      postVideoLink: postVideoLink ?? this.postVideoLink,
      isDebate: isDebate ?? this.isDebate,
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      isUpVote: isUpVote ?? this.isUpVote,
      isDownVote: isDownVote ?? this.isDownVote,
      comments: comments ?? this.comments,
      uploadTime: uploadTime ?? this.uploadTime,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    userId,
    avatar,
    title,
    description,
    postImageLink,
    postVideoLink,
    isDebate,
    upvotes,
    downvotes,
    comments,
    uploadTime,
    isUpVote,
    isDownVote,
    clusters,
  ];
}
