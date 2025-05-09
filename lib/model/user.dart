class User {
  final String username;

  final int karma;
  final int followers;
  final int following;
  final DateTime joinedDate;
  final String country;
  final String? about;
  final int avatarId;
  final List<String> upVotedPosts;
  final List<String> downVotedPosts;

  User({
    required this.username,
    required this.karma,
    required this.followers,
    required this.following,
    required this.joinedDate,
    required this.country,
    required this.upVotedPosts,
    required this.downVotedPosts,

    this.about,
    required this.avatarId,
  });

  // Convert User object to JSON map
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'country': country,
      'karma': karma,
      'followers': followers,
      'following': following,
      'joinedDate': joinedDate.toIso8601String(),
      'upVotedPosts': upVotedPosts,
      'downVotedPosts': downVotedPosts,

      'about': about,
      'avatarUrl': avatarId,
    };
  }

  // Create User object from JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'] as String,
      country: json['country'] as String,
      karma: json['karma'] as int,
      followers: json['followers'] as int,
      following: json['following'] as int,
      joinedDate: DateTime.parse(json['joinedDate'] as String),
      upVotedPosts: json['upVotedPosts'] ?? [],
      downVotedPosts: json['downVotedPosts'] ?? [],

      about: json['about'] as String?,
      avatarId: json['avatarId'] as int,
    );
  }

  User copyWith({
    String? username,

    int? karma,
    int? followers,
    int? following,
    DateTime? joinedDate,
    int? postCount,
    int? commentCount,
    String? about,
    int? avatarUrl,
    List<String>? upVotedPosts,
    List<String>? downVotedPosts,

    String? country,
  }) {
    return User(
      username: username ?? this.username,
      country: country ?? this.country,
      karma: karma ?? this.karma,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      joinedDate: joinedDate ?? this.joinedDate,
      upVotedPosts: upVotedPosts ?? this.upVotedPosts,
      downVotedPosts: downVotedPosts ?? this.downVotedPosts,

      about: about ?? this.about,
      avatarId: avatarUrl ?? avatarId,
    );
  }
}
