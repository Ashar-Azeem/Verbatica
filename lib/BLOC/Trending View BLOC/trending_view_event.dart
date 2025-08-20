part of 'trending_view_bloc.dart';

sealed class TrendingViewEvent extends Equatable {
  const TrendingViewEvent();

  @override
  List<Object> get props => [];
}

class FetchInitialTrendingPosts extends TrendingViewEvent {
  const FetchInitialTrendingPosts();
}

class FetchInitialNews extends TrendingViewEvent {
  final String country;
  final DateTime date;
  const FetchInitialNews({required this.country, required this.date});
}

class FetchBottomTrendingPosts extends TrendingViewEvent {
  const FetchBottomTrendingPosts();
}

class UpVotePost extends TrendingViewEvent {
  final int index;
  final String category;

  const UpVotePost({required this.index, required this.category});
}

class DownVotePost extends TrendingViewEvent {
  final int index;
  final String category;

  const DownVotePost({required this.index, required this.category});
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
  final String category;

  const UpVoteNewsPost({
    required this.index,
    required this.category,
    required this.newsIndex,
  });
}

class DownVoteNewsPost extends TrendingViewEvent {
  final int index;
  final int newsIndex;
  final String category;

  const DownVoteNewsPost({
    required this.index,
    required this.category,
    required this.newsIndex,
  });
}

class FetchPostsWithInNews extends TrendingViewEvent {
  final int newsIndex;
  final int userId;

  const FetchPostsWithInNews({required this.newsIndex, required this.userId});
}
