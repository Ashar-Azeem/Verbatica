import 'package:equatable/equatable.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/comment.dart';
import 'package:verbatica/model/user.dart';

class OtheruserState extends Equatable {
  final User? user;
  final bool? isFollowedByMe;
  final int? lastPostId;
  final bool isMorePost;
  final int attemptsInOneGo;
  final List<Post> userPosts;
  final List<Comment> userComments;
  final bool isLoadingComments;
  final bool isProfileLoading;
  final bool isLoadingPosts;

  const OtheruserState({
    this.user,
    this.attemptsInOneGo = 0,
    this.isFollowedByMe,
    this.isProfileLoading = true,
    this.userPosts = const [],
    this.userComments = const [],
    this.isMorePost = true,
    this.lastPostId,
    this.isLoadingComments = false,
    this.isLoadingPosts = false,
  });

  OtheruserState copyWith({
    User? user,
    bool? isFollowedByMe,
    int? lastPostId,
    bool? isMorePost,
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
      isMorePost: isMorePost ?? this.isMorePost,
      lastPostId: lastPostId ?? this.lastPostId,
      isFollowedByMe: isFollowedByMe ?? this.isFollowedByMe,
      userPosts: userPosts ?? this.userPosts,
      userComments: userComments ?? this.userComments,
      isLoadingComments: isLoadingComments ?? this.isLoadingComments,
      isLoadingPosts: isLoadingPosts ?? this.isLoadingPosts,
    );
  }

  OtheruserState initState() {
    return OtheruserState(
      isProfileLoading: true,
      userPosts: [],
      userComments: [],
      isLoadingComments: false,
      isLoadingPosts: false,
      attemptsInOneGo: 0,
      lastPostId: null,
      user: null,
      isMorePost: true,
      isFollowedByMe: null,
    );
  }

  @override
  List<Object?> get props => [
    user,
    attemptsInOneGo,
    isFollowedByMe,
    lastPostId,
    isMorePost,
    isProfileLoading,
    userPosts,
    userComments,
    isLoadingComments,
    isLoadingPosts,
  ];
}
