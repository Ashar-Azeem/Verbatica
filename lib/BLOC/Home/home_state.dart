part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<Post> following;
  final List<Post> forYou;
  final bool hasMoreFollowingPosts;
  final int? lastFollowingPostId;
  final bool hasMoreForYouPosts;
  final bool forYouInitialLoading;
  final bool followingInitialLoading;
  final List<Ad> ads;

  const HomeState({
    this.following = const [],
    this.forYou = const [],
    this.ads = const [],
    this.lastFollowingPostId,
    this.hasMoreFollowingPosts = false,
    this.hasMoreForYouPosts = false,
    this.forYouInitialLoading = true,
    this.followingInitialLoading = true,
  });

  factory HomeState.initial() => const HomeState();

  HomeState copyWith({
    List<Post>? following,
    List<Post>? forYou,
    List<Ad>? ads,
    bool? hasMoreFollowingPosts,
    int? lastFollowingPostId,
    bool? hasMoreForYouPosts,
    bool? forYouInitialLoading,
    bool? followingInitialLoading,
  }) {
    return HomeState(
      following: following ?? this.following,
      forYou: forYou ?? this.forYou,
      ads: ads ?? this.ads,
      hasMoreFollowingPosts:
          hasMoreFollowingPosts ?? this.hasMoreFollowingPosts,
      lastFollowingPostId: lastFollowingPostId ?? lastFollowingPostId,
      hasMoreForYouPosts: hasMoreForYouPosts ?? this.hasMoreForYouPosts,
      forYouInitialLoading: forYouInitialLoading ?? this.forYouInitialLoading,
      followingInitialLoading:
          followingInitialLoading ?? this.followingInitialLoading,
    );
  }

  @override
  List<Object?> get props => [
    following,
    ads,
    forYou,
    hasMoreFollowingPosts,
    lastFollowingPostId,
    hasMoreForYouPosts,
    forYouInitialLoading,
    followingInitialLoading,
  ];
}
