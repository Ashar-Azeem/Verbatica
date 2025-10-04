part of 'trending_view_bloc.dart';

class TrendingViewState extends Equatable {
  final List<News> news;
  final List<Post> trending;
  final bool trendingInitialLoading;
  final bool trendingBottomLoading;
  final bool newsInitialLoading;
  final bool fetchingPostsWithInNews;

  const TrendingViewState({
    this.news = const [],
    this.trending = const [],
    this.trendingInitialLoading = true,
    this.trendingBottomLoading = false,
    this.fetchingPostsWithInNews = false,
    this.newsInitialLoading = true,
  });

  TrendingViewState copyWith({
    List<News>? news,
    List<Post>? trending,
    bool? trendingBottomLoading,
    bool? fetchingPostsWithInNews,
    bool? trendingInitialLoading,
    bool? newsInitialLoading,
  }) {
    return TrendingViewState(
      news: news ?? this.news,
      trending: trending ?? this.trending,
      trendingBottomLoading:
          trendingBottomLoading ?? this.trendingBottomLoading,
      fetchingPostsWithInNews:
          fetchingPostsWithInNews ?? this.fetchingPostsWithInNews,
      trendingInitialLoading:
          trendingInitialLoading ?? this.trendingInitialLoading,
      newsInitialLoading: newsInitialLoading ?? this.newsInitialLoading,
    );
  }

  @override
  List<Object> get props => [
    news,
    trending,
    fetchingPostsWithInNews,
    trendingBottomLoading,
    trendingInitialLoading,
    newsInitialLoading,
  ];
}
