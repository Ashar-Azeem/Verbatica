part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<Post> following;
  final List<Post> forYou;
  final bool hasMoreFollowingPosts;
  final int? lastFollowingPostId;
  final bool hasMoreForYouPosts;
  final int? lastForYouPostId;
  final bool forYouInitialLoading;
  final bool followingInitialLoading;

  const HomeState({
    this.following = const [],
    this.forYou = const [],
    this.lastFollowingPostId,
    this.hasMoreFollowingPosts = false,
    this.lastForYouPostId,
    this.hasMoreForYouPosts = false,
    this.forYouInitialLoading = true,
    this.followingInitialLoading = true,
  });

  HomeState copyWith({
    List<Post>? following,
    List<Post>? forYou,
    bool? hasMoreFollowingPosts,
    int? lastFollowingPostId,
    bool? hasMoreForYouPosts,
    int? lastForYouPostId,
    bool? forYouInitialLoading,
    bool? followingInitialLoading,
  }) {
    return HomeState(
      following: following ?? this.following,
      forYou: forYou ?? this.forYou,
      hasMoreFollowingPosts:
          hasMoreFollowingPosts ?? this.hasMoreFollowingPosts,
      lastFollowingPostId: lastFollowingPostId ?? lastFollowingPostId,
      hasMoreForYouPosts: hasMoreForYouPosts ?? this.hasMoreForYouPosts,
      lastForYouPostId: lastForYouPostId ?? this.lastForYouPostId,
      forYouInitialLoading: forYouInitialLoading ?? this.forYouInitialLoading,
      followingInitialLoading:
          followingInitialLoading ?? this.followingInitialLoading,
    );
  }

  @override
  List<Object?> get props => [
    following,
    forYou,
    hasMoreFollowingPosts,
    lastFollowingPostId,
    lastForYouPostId,
    hasMoreForYouPosts,
    forYouInitialLoading,
    followingInitialLoading,
  ];
}
