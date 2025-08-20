part of 'trending_view_bloc.dart';

class TrendingViewState extends Equatable {
  final List<News> news;
  final List<Post> trending;
  final bool trendingInitialLoading;
  final bool newsInitialLoading;
  final bool fetchingPostsWithInNews;

  const TrendingViewState({
    this.news = const [],
    this.trending = const [],
    this.trendingInitialLoading = true,
    this.fetchingPostsWithInNews = false,
    this.newsInitialLoading = true,
  });

  TrendingViewState copyWith({
    List<News>? news,
    List<Post>? trending,
    bool? fetchingPostsWithInNews,
    bool? trendingInitialLoading,
    bool? newsInitialLoading,
  }) {
    return TrendingViewState(
      news: news ?? this.news,
      trending: trending ?? this.trending,
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
    trendingInitialLoading,
    newsInitialLoading,
  ];
}
