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
  final List<Post> postofComments;
  UserState({
    User? user,
    List<Post>? userPosts,
    List<Comment>? userComments,
    List<Post>? postofComments,
    this.isLoadingComments = false,
  }) : user = user ?? _defaultUser(),
       userPosts = userPosts ?? forYouPosts,
       postofComments = postofComments ?? [],
       userComments = userComments ?? [];

  static User _defaultUser() {
    return dummyUser;
  }

  UserState copyWith({
    User? user,
    List<Post>? userPosts,
    List<Post>? postofComment,
    List<Comment>? userComments,
    bool? isLoadingComments,
  }) {
    return UserState(
      postofComments: postofComment ?? this.postofComments,
      user: user ?? this.user,
      userPosts: userPosts ?? this.userPosts,
      userComments: userComments ?? this.userComments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
    );
  }

  @override
  List<Object?> get props => [
    user,
    userPosts,
    userComments,
    isLoadingComments,
    postofComments,
  ];
}
