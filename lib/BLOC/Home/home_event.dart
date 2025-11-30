part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class FetchInitialForYouPosts extends HomeEvent {
  final int userId;

  const FetchInitialForYouPosts({required this.userId});
}

class FetchInitialFollowingPosts extends HomeEvent {
  final int userId;
  const FetchInitialFollowingPosts({required this.userId});
}

class FetchBottomForYouPosts extends HomeEvent {
  final int userId;

  const FetchBottomForYouPosts({required this.userId});
}

class FetchBottomFollowingPosts extends HomeEvent {
  final int userId;

  const FetchBottomFollowingPosts(this.userId);
}

class UpVotePost extends HomeEvent {
  final int index;
  final String category;
  final BuildContext context;
  final int userId;

  const UpVotePost({
    required this.index,
    required this.category,
    required this.context,
    required this.userId,
  });
}

class DownVotePost extends HomeEvent {
  final int index;
  final String category;
  final BuildContext context;
  final int userId;

  const DownVotePost({
    required this.index,
    required this.category,
    required this.context,
    required this.userId,
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

class SyncUpVotePost extends HomeEvent {
  final String postId;

  const SyncUpVotePost({required this.postId});
}

class SyncDownVotePost extends HomeEvent {
  final String postId;

  const SyncDownVotePost({required this.postId});
}

class SyncUpvotePostsOfOtherTab extends HomeEvent {
  final String postId;
  final String category;

  const SyncUpvotePostsOfOtherTab({
    required this.postId,
    required this.category,
  });
}

class SyncDownvotePostsOfOtherTab extends HomeEvent {
  final String postId;
  final String category;

  const SyncDownvotePostsOfOtherTab({
    required this.postId,
    required this.category,
  });
}

class UpdateCommentCountOfAPost extends HomeEvent {
  final int postIndex;
  final String? clusters;
  final String category;

  const UpdateCommentCountOfAPost({
    required this.postIndex,
    required this.clusters,
    required this.category,
  });
}

class ToggleSaveOfForYouPosts extends HomeEvent {
  final int postIndex;
  final String category;

  const ToggleSaveOfForYouPosts({
    required this.postIndex,
    required this.category,
  });
}

class RefreshEvent extends HomeEvent {
  final String category;
  final int userId;

  const RefreshEvent({required this.category, required this.userId});
}

class ClearHomeBloc extends HomeEvent {}
