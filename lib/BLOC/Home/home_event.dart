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
  final int incrementBy;

  const UpVotePost({
    required this.index,
    required this.category,
    required this.incrementBy,
  });
}

class DownVotePost extends HomeEvent {
  final int index;
  final String category;
  final int decrementBy;

  const DownVotePost({
    required this.index,
    required this.category,
    required this.decrementBy,
  });
}

class ReportPost extends HomeEvent {
  final int index;
  final String category;
  final String postId;

  const ReportPost({
    required this.index,
    required this.category,
    required this.postId,
  });
}

class SavePost extends HomeEvent {
  final Post post;

  const SavePost({required this.post});
}

class SharePost extends HomeEvent {
  final Post post;

  const SharePost({required this.post});
}
