part of 'trending_view_bloc.dart';

class TrendingViewState extends Equatable {
  final List<News> news;
  final List<Post> trending;
  final bool trendingInitialLoading;
  final bool newsInitialLoading;

  const TrendingViewState({
    this.news = const [],
    this.trending = const [],
    this.trendingInitialLoading = true,
    this.newsInitialLoading = true,
  });

  TrendingViewState copyWith({
    List<News>? news,
    List<Post>? trending,
    bool? trendingInitialLoading,
    bool? newsInitialLoading,
  }) {
    return TrendingViewState(
      news: news ?? this.news,
      trending: trending ?? this.trending,
      trendingInitialLoading:
          trendingInitialLoading ?? this.trendingInitialLoading,
      newsInitialLoading: newsInitialLoading ?? this.newsInitialLoading,
    );
  }

  @override
  List<Object> get props => [
    news,
    trending,
    trendingInitialLoading,
    newsInitialLoading,
  ];
}
