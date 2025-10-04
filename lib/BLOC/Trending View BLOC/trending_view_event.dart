part of 'trending_view_bloc.dart';

sealed class TrendingViewEvent extends Equatable {
  const TrendingViewEvent();

  @override
  List<Object> get props => [];
}

class FetchInitialTrendingPosts extends TrendingViewEvent {
  final int userId;
  const FetchInitialTrendingPosts({required this.userId});
}

class FetchInitialNews extends TrendingViewEvent {
  final String country;
  final DateTime date;
  const FetchInitialNews({required this.country, required this.date});
}

class FetchBottomTrendingPosts extends TrendingViewEvent {
  final int userId;

  const FetchBottomTrendingPosts({required this.userId});
}

class UpVotePost extends TrendingViewEvent {
  final int index;
  final int userId;
  final BuildContext context;

  const UpVotePost({
    required this.index,
    required this.context,
    required this.userId,
  });
}

class DownVotePost extends TrendingViewEvent {
  final int index;
  final int userId;
  final BuildContext context;

  const DownVotePost({
    required this.index,
    required this.context,
    required this.userId,
  });
}

class ReportPost extends TrendingViewEvent {
  final int index;
  final String category;
  final String postId;

  const ReportPost({
    required this.index,
    required this.category,
    required this.postId,
  });
}

class SavePost extends TrendingViewEvent {
  final Post post;

  const SavePost({required this.post});
}

class SharePost extends TrendingViewEvent {
  final Post post;

  const SharePost({required this.post});
}

class UpVoteNewsPost extends TrendingViewEvent {
  final int index;
  final int newsIndex;
  final int userId;
  final BuildContext context;
  const UpVoteNewsPost({
    required this.index,
    required this.newsIndex,
    required this.context,
    required this.userId,
  });
}

class DownVoteNewsPost extends TrendingViewEvent {
  final int index;
  final int newsIndex;
  final int userId;
  final BuildContext context;
  const DownVoteNewsPost({
    required this.index,
    required this.newsIndex,
    required this.context,
    required this.userId,
  });
}

class FetchPostsWithInNews extends TrendingViewEvent {
  final int newsIndex;
  final int userId;

  const FetchPostsWithInNews({required this.newsIndex, required this.userId});
}

class SyncUpVoteTrendingPost extends TrendingViewEvent {
  final String postId;
  // final int newsIndex;

  const SyncUpVoteTrendingPost({
    required this.postId,
    // required this.newsIndex,
  });
}

class SyncDownVoteTrendingPost extends TrendingViewEvent {
  final String postId;
  // final int newsIndex;

  const SyncDownVoteTrendingPost({
    required this.postId,
    // required this.newsIndex,
  });
}

class SyncUpVoteNewsPost extends TrendingViewEvent {
  final int newsId;
  final String postId;

  const SyncUpVoteNewsPost({required this.newsId, required this.postId});
}

class SyncDownVoteNewsPost extends TrendingViewEvent {
  final int newsId;
  final String postId;

  const SyncDownVoteNewsPost({required this.newsId, required this.postId});
}

class AddRecentPostInNews extends TrendingViewEvent {
  final Post post;
  final String newsId;

  const AddRecentPostInNews(this.newsId, {required this.post});
}
