import 'package:equatable/equatable.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/comment.dart';
import 'package:verbatica/model/user.dart';

class UserState extends Equatable {
  final User? user;
  final List<Post> userPosts;
  final List<Comment> userComments;
  final bool isLoadingComments;
  final bool isLoadingPosts;
  final bool isLoadingUpdatingProfile;
  final List<Post> savedPosts; // New field for saved posts

  const UserState({
    this.user,
    this.isLoadingUpdatingProfile = false,
    this.userPosts = const [],
    this.userComments = const [],
    this.savedPosts = const [],
    this.isLoadingComments = false,
    this.isLoadingPosts = false,
  });

  UserState copyWith({
    User? user,
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
      isLoadingUpdatingProfile:
          isLoadingUpdatingProfile ?? this.isLoadingUpdatingProfile,
      savedPosts: savedPosts ?? this.savedPosts, // Add saved posts
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      isLoadingPosts: isLoadingPosts ?? this.isLoadingPosts,
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
    savedPosts, // Add to props
  ];
}
