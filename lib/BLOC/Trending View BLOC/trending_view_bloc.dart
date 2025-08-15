import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:verbatica/DummyData/News.DART';
import 'package:verbatica/DummyData/dummyPosts.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/news.dart';

part 'trending_view_event.dart';
part 'trending_view_state.dart';

class TrendingViewBloc extends Bloc<TrendingViewEvent, TrendingViewState> {
  TrendingViewBloc() : super(TrendingViewState()) {
    on<FetchInitialTrendingPosts>(fetchInitialTrendingPosts);
    on<FetchInitialNews>(fetchInitialNews);
    on<FetchBottomTrendingPosts>(fetchBottomTrendingPosts);
    on<UpVotePost>(upVotePost);
    on<DownVotePost>(downVotePost);
    on<ReportPost>(reportPost);
    on<SavePost>(savePost);
    on<UpVoteNewsPost>(upVoteNewsPost);
    on<DownVoteNewsPost>(downVoteNewsPost);
  }

  fetchInitialTrendingPosts(
    FetchInitialTrendingPosts event,
    Emitter<TrendingViewState> emit,
  ) async {
    //Dummy Logic
    await Future.delayed(Duration(seconds: 2));

    emit(state.copyWith(trending: forYouPosts, trendingInitialLoading: false));
  }

  fetchInitialNews(
    FetchInitialNews event,
    Emitter<TrendingViewState> emit,
  ) async {
    await Future.delayed(Duration(seconds: 2));
    emit(state.copyWith(news: newsList, newsInitialLoading: false));
  }

  fetchBottomTrendingPosts(
    FetchBottomTrendingPosts event,
    Emitter<TrendingViewState> emit,
  ) {}

  upVotePost(UpVotePost event, Emitter<TrendingViewState> emit) {
    List<Post> posts = List.from(state.trending);
    if (!posts[event.index].isUpVote) {
      if (posts[event.index].isDownVote) {
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: false,
          isUpVote: true,
          upvotes: posts[event.index].upvotes + 2,
        );
        emit(state.copyWith(trending: posts));
      } else {
        posts[event.index] = posts[event.index].copyWith(
          isUpVote: true,
          upvotes: posts[event.index].upvotes + 1,
        );
        emit(state.copyWith(trending: posts));
      }
    }
  }

  downVotePost(DownVotePost event, Emitter<TrendingViewState> emit) {
    List<Post> posts = List.from(state.trending);
    if (!posts[event.index].isDownVote) {
      if (posts[event.index].isUpVote) {
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: true,
          isUpVote: false,
          downvotes: posts[event.index].downvotes + 2,
        );
        emit(state.copyWith(trending: posts));
      } else {
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: true,
          downvotes: posts[event.index].downvotes + 1,
        );
        emit(state.copyWith(trending: posts));
      }
    }
  }

  reportPost(ReportPost event, Emitter<TrendingViewState> emit) {}
  savePost(SavePost event, Emitter<TrendingViewState> emit) {}

  upVoteNewsPost(UpVoteNewsPost event, Emitter<TrendingViewState> emit) {
    List<News> news = List.from(state.news);
    List<Post> posts = List.from(news[event.newsIndex].discussions);
    if (!posts[event.index].isUpVote) {
      if (posts[event.index].isDownVote) {
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: false,
          isUpVote: true,
          upvotes: posts[event.index].upvotes + 2,
        );
        news[event.newsIndex] = news[event.newsIndex].copyWith(
          discussions: posts,
        );
        emit(state.copyWith(news: news));
      } else {
        posts[event.index] = posts[event.index].copyWith(
          isUpVote: true,
          upvotes: posts[event.index].upvotes + 1,
        );
        news[event.newsIndex] = news[event.newsIndex].copyWith(
          discussions: posts,
        );
        emit(state.copyWith(news: news));
      }
    }
  }

  downVoteNewsPost(DownVoteNewsPost event, Emitter<TrendingViewState> emit) {
    List<News> news = List.from(state.news);
    List<Post> posts = List.from(news[event.newsIndex].discussions);
    if (!posts[event.index].isDownVote) {
      if (posts[event.index].isUpVote) {
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: true,
          isUpVote: false,
          downvotes: posts[event.index].downvotes + 2,
        );
        news[event.newsIndex] = news[event.newsIndex].copyWith(
          discussions: posts,
        );
        emit(state.copyWith(news: news));
      } else {
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: true,
          downvotes: posts[event.index].downvotes + 1,
        );
        news[event.newsIndex] = news[event.newsIndex].copyWith(
          discussions: posts,
        );
        emit(state.copyWith(news: news));
      }
    }
  }
}
