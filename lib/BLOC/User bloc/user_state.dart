import 'package:equatable/equatable.dart';
import 'package:verbatica/DummyData/UserDummyData.dart';
import 'package:verbatica/DummyData/dummyPosts.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/comment.dart';
import 'package:verbatica/model/user.dart';

class UserState extends Equatable {
  final User user;
  final List<Post> userPosts;
  final List<Comment> userComments;
  final bool isLoadingComments;
  final bool isLoadingPosts;
  final List<Post> postofComments;
  final List<Post> savedPosts; // New field for saved posts

  UserState({
    User? user,
    List<Post>? userPosts,
    List<Comment>? userComments,
    List<Post>? postofComments,
    List<Post>? savedPosts, // New parameter
    this.isLoadingComments = false,
    this.isLoadingPosts = false,
  }) : user = user ?? _defaultUser(),
       userPosts = userPosts ?? forYouPosts,
       postofComments = postofComments ?? [],
       savedPosts = savedPosts ?? [], // Initialize empty list if not provided
       userComments = userComments ?? [];

  static User _defaultUser() {
    return dummyUser;
  }

  UserState copyWith({
    User? user,
    List<Post>? userPosts,
    List<Post>? postofComment,
    List<Comment>? userComments,
    List<Post>? savedPosts, // New parameter
    bool? isLoadingComments,
    bool? isLoadingPosts,
  }) {
    return UserState(
      postofComments: postofComment ?? postofComments,
      user: user ?? this.user,
      userPosts: userPosts ?? this.userPosts,
      userComments: userComments ?? this.userComments,
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
    isLoadingComments,
    isLoadingPosts,
    postofComments,
    savedPosts, // Add to props
  ];
}
