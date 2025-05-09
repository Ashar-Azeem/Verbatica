// ignore_for_file: file_names

class Cluster {
  final String id;
  final String title;

  //list of comment to be added here

  Cluster({required this.id, required this.title});

  factory Cluster.fromJson(Map<String, dynamic> json) {
    return Cluster(id: json['id'], title: json['title']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title};
  }
}

class Post {
  final String id;
  final String name;
  final int avatar;
  final String title;
  final String description;
  final String? postImageLink;
  final String? postVideoLink;
  final bool isDebate;
  final int upvotes;
  final int downvotes;
  final int comments;
  final DateTime uploadTime;
  final List<Cluster>? clusters; //// Only used when isdebate==true

  const Post({
    required this.id,
    this.clusters,
    required this.name,
    this.clusters,
    required this.avatar,
    required this.title,
    required this.description,
    this.postImageLink,
    this.postVideoLink,
    required this.isDebate,
    required this.upvotes,
    required this.downvotes,
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
      'upVote': upvotes,
      'downVotes': downvotes,
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
      upvotes: json['upVote'] ?? 0,
      downvotes: json['downVotes'] ?? 0,
      comments: json['comments'] ?? 0,
      uploadTime: DateTime.parse(json['uploadTime']),
    );
  }

  // Optionally, you can add a copyWith method for easy modifications
  Post copyWith({
    String? id,
    String? name,
    int? avatar,
    String? title,
    String? description,
    String? postImageLink,
    String? postVideoLink,
    bool? isDebate,
    int? upvotes,
    int? downvotes,
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
      upvotes: upvotes ?? this.upvotes,
      downvotes: downvotes ?? this.downvotes,
      comments: comments ?? this.comments,
      uploadTime: uploadTime ?? this.uploadTime,
    );
  }
}
