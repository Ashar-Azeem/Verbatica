import 'package:equatable/equatable.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/comment.dart';
import 'package:verbatica/model/user.dart';

class UserState extends Equatable {
  final User? user;
  final List<Post> userPosts;
  final int? lastPostId;
  final bool isMorePost;
  final List<Comment> userComments;
  final bool isLoadingComments;
  final bool isLoadingPosts;
  final bool isLoadingUpdatingProfile;
  final List<Post> savedPosts;

  const UserState({
    this.user,
    this.lastPostId,
    this.isMorePost = true,
    this.isLoadingUpdatingProfile = false,
    this.userPosts = const [],
    this.userComments = const [],
    this.savedPosts = const [],
    this.isLoadingComments = false,
    this.isLoadingPosts = false,
  });

  UserState copyWith({
    User? user,
    int? lastPostId,
    bool? isMorePost,
    List<Post>? userPosts,
    List<Comment>? userComments,
    bool? isLoadingUpdatingProfile,
    List<Post>? savedPosts,
    bool? isLoadingComments,
    bool? isLoadingPosts,
  }) {
    return UserState(
      user: user ?? this.user,
      userPosts: userPosts ?? this.userPosts,
      userComments: userComments ?? this.userComments,
      lastPostId: lastPostId ?? this.lastPostId,
      isMorePost: isMorePost ?? this.isMorePost,
      isLoadingUpdatingProfile:
          isLoadingUpdatingProfile ?? this.isLoadingUpdatingProfile,
      savedPosts: savedPosts ?? this.savedPosts, // Add saved posts
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      isLoadingPosts: isLoadingPosts ?? this.isLoadingPosts,
    );
  }

  UserState initState() {
    return UserState(
      user: null,
      userPosts: [],
      userComments: [],
      isLoadingUpdatingProfile: false,
      savedPosts: [],
      isLoadingComments: false,
      isLoadingPosts: false,
      isMorePost: true,
      lastPostId: null,
    );
  }

  @override
  List<Object?> get props => [
    user,
    userPosts,
    userComments,
    isLoadingUpdatingProfile,
    isLoadingComments,
    isLoadingPosts,
    savedPosts,
    isMorePost,
    lastPostId,
  ];
}
