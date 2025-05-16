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
  const FetchInitialNews();
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
