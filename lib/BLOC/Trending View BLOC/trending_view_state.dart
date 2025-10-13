part of 'trending_view_bloc.dart';

class TrendingViewState extends Equatable {
  final List<News> news;
  final List<Post> trending;
  final bool trendingInitialLoading;
  final bool trendingBottomLoading;
  final bool newsInitialLoading;
  final bool fetchingPostsWithInNews;
  final List<Ad> ads;
  const TrendingViewState({
    this.news = const [],
    this.ads = const [],
    this.trending = const [],
    this.trendingInitialLoading = true,
    this.trendingBottomLoading = false,
    this.fetchingPostsWithInNews = false,
    this.newsInitialLoading = true,
  });

  factory TrendingViewState.initial() => const TrendingViewState();

  TrendingViewState copyWith({
    List<News>? news,
    List<Ad>? ads,
    List<Post>? trending,
    bool? trendingBottomLoading,
    bool? fetchingPostsWithInNews,
    bool? trendingInitialLoading,
    bool? newsInitialLoading,
  }) {
    return TrendingViewState(
      news: news ?? this.news,
      ads: ads ?? this.ads,
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
    ads,
  ];
}
