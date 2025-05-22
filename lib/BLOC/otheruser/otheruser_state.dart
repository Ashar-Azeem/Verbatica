import 'package:equatable/equatable.dart';
import 'package:verbatica/DummyData/UserDummyData.dart';
import 'package:verbatica/DummyData/dummyPosts.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/comment.dart';
import 'package:verbatica/model/user.dart';

class OtheruserState extends Equatable {
  final User user;
  final List<Post> userPosts;
  final List<Comment> userComments;
  final bool isLoadingComments;
  final bool isLoadingPosts;
  final List<Post> postofComments;

  OtheruserState({
    User? user,
    List<Post>? userPosts,
    List<Comment>? userComments,
    List<Post>? postofComments,
    this.isLoadingComments = false,
    this.isLoadingPosts = false,
  }) : user = user ?? _defaultUser(),
       userPosts = userPosts ?? forYouPosts,
       postofComments = postofComments ?? [],
       userComments = userComments ?? [];

  static User _defaultUser() {
    return dummyUser;
  }

  OtheruserState copyWith({
    User? user,
    List<Post>? userPosts,
    List<Post>? postofComment,
    List<Comment>? userComments,
    bool? isLoadingComments,
    bool? isLoadingPosts,
  }) {
    return OtheruserState(
      postofComments: postofComment ?? postofComments,
      user: user ?? this.user,
      userPosts: userPosts ?? this.userPosts,
      userComments: userComments ?? this.userComments,
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
  ];
}
