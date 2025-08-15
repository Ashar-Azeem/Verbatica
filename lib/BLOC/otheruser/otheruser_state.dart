import 'package:equatable/equatable.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/comment.dart';
import 'package:verbatica/model/user.dart';

class OtheruserState extends Equatable {
  final User? user;
  final bool? isFollowedByMe;
  final int attemptsInOneGo;
  final List<Post> userPosts;
  final List<Comment> userComments;
  final bool isLoadingComments;
  final bool isProfileLoading;
  final bool isLoadingPosts;

  OtheruserState({
    this.user,
    this.attemptsInOneGo = 0,
    this.isFollowedByMe,
    this.isProfileLoading = true,
    List<Post>? userPosts,
    List<Comment>? userComments,
    this.isLoadingComments = false,
    this.isLoadingPosts = false,
  }) : userPosts = userPosts ?? [],
       userComments = userComments ?? [];

  OtheruserState copyWith({
    User? user,
    bool? isFollowedByMe,
    int? attemptsInOneGo,
    List<Post>? userPosts,
    List<Comment>? userComments,
    bool? isProfileLoading,
    bool? isLoadingComments,
    bool? isLoadingPosts,
  }) {
    return OtheruserState(
      attemptsInOneGo: attemptsInOneGo ?? this.attemptsInOneGo,
      isProfileLoading: isProfileLoading ?? this.isProfileLoading,
      user: user ?? this.user,
      isFollowedByMe: isFollowedByMe ?? this.isFollowedByMe,
      userPosts: userPosts ?? this.userPosts,
      userComments: userComments ?? this.userComments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      isLoadingPosts: isLoadingPosts ?? this.isLoadingPosts,
    );
  }

  @override
  List<Object?> get props => [
    user,
    attemptsInOneGo,
    isFollowedByMe,
    isProfileLoading,
    userPosts,
    userComments,
    isLoadingComments,
    isLoadingPosts,
  ];
}
