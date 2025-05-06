// ignore_for_file: file_names

class Post {
  final String id;
  final String name;
  final String avatar;
  final String title;
  final String description;
  final String? postImageLink;
  final String? postVideoLink;
  final bool isDebate;
  final int likes;
  final int comments;
  final DateTime uploadTime;

  Post({
    required this.id,
    required this.name,
    required this.avatar,
    required this.title,
    required this.description,
    this.postImageLink,
    this.postVideoLink,
    required this.isDebate,
    required this.likes,
    required this.comments,
    required this.uploadTime,
  });

  // Convert Post object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'title': title,
      'description': description,
      'postImageLink': postImageLink,
      'postVideoLink': postVideoLink,
      'isDebate': isDebate,
      'likes': likes,
      'comments': comments,
      'uploadTime': uploadTime.toIso8601String(),
    };
  }

  // Create Post object from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      title: json['title'],
      description: json['description'],
      postImageLink: json['postImageLink'],
      postVideoLink: json['postVideoLink'],
      isDebate: json['isDebate'] ?? false,
      likes: json['likes'] ?? 0,
      comments: json['comments'] ?? 0,
      uploadTime: DateTime.parse(json['uploadTime']),
    );
  }

  // Optionally, you can add a copyWith method for easy modifications
  Post copyWith({
    String? id,
    String? name,
    String? avatar,
    String? title,
    String? description,
    String? postImageLink,
    String? postVideoLink,
    bool? isDebate,
    int? likes,
    int? comments,
    DateTime? uploadTime,
  }) {
    return Post(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      title: title ?? this.title,
      description: description ?? this.description,
      postImageLink: postImageLink ?? this.postImageLink,
      postVideoLink: postVideoLink ?? this.postVideoLink,
      isDebate: isDebate ?? this.isDebate,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      uploadTime: uploadTime ?? this.uploadTime,
    );
  }
}
