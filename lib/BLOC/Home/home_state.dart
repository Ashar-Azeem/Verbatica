part of 'home_bloc.dart';

class HomeState extends Equatable {
  final List<Post> following;
  final List<Post> forYou;
  final bool forYouInitialLoading;
  final bool followingInitialLoading;

  const HomeState({
    this.following = const [],
    this.forYou = const [],
    this.forYouInitialLoading = true,
    this.followingInitialLoading = true,
  });

  HomeState copyWith({
    List<Post>? following,
    List<Post>? forYou,
    bool? forYouInitialLoading,
    bool? followingInitialLoading,
  }) {
    return HomeState(
      following: following ?? this.following,
      forYou: forYou ?? this.forYou,
      forYouInitialLoading: forYouInitialLoading ?? this.forYouInitialLoading,
      followingInitialLoading:
          followingInitialLoading ?? this.followingInitialLoading,
    );
  }

  @override
  List<Object> get props => [
    following,
    forYou,
    forYouInitialLoading,
    followingInitialLoading,
  ];
}
