part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchInitialForYouPosts extends HomeEvent {
  const FetchInitialForYouPosts();
}

class FetchInitialFollowingPosts extends HomeEvent {
  const FetchInitialFollowingPosts();
}

class FetchBottomForYouPosts extends HomeEvent {
  const FetchBottomForYouPosts();
}

class FetchBottomFollowingPosts extends HomeEvent {
  const FetchBottomFollowingPosts();
}

class UpVotePost extends HomeEvent {
  final int index;
  final String category;

  const UpVotePost({required this.index, required this.category});
}

class DownVotePost extends HomeEvent {
  final int index;
  final String category;

  const DownVotePost({required this.index, required this.category});
}
