import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/model/Ad.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/news.dart';

part 'trending_view_event.dart';
part 'trending_view_state.dart';

class TrendingViewBloc extends Bloc<TrendingViewEvent, TrendingViewState> {
  final int limit = 10;
  int page = 1;
  List<double>? vector;

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
    on<FetchPostsWithInNews>(fetchPostsWithInNews);
    on<SyncDownVoteTrendingPost>(syncDownVoteTrendingPost);
    on<SyncUpVoteTrendingPost>(syncUpVoteTrendingPost);
    on<SyncDownVoteNewsPost>(syncDownVoteNewsPost);
    on<SyncUpVoteNewsPost>(syncUpVoteNewsPost);
    on<AddRecentPostInNews>(addRecentPost);
    on<ClearTrendingBloc>((event, emit) => emit(TrendingViewState.initial()));
  }
  void addRecentPost(
    AddRecentPostInNews event,
    Emitter<TrendingViewState> emit,
  ) {
    final trendingNews = List<News>.from(state.news);

    for (int i = 0; i < trendingNews.length; i++) {
      if (trendingNews[i].newsId == event.newsId) {
        final updatedPosts = List<Post>.from(trendingNews[i].discussions)
          ..insert(0, event.post);

        trendingNews[i] = trendingNews[i].copyWith(discussions: updatedPosts);
        break;
      }
    }

    emit(state.copyWith(news: trendingNews)); // ✅ Emit only once
  }

  fetchInitialTrendingPosts(
    FetchInitialTrendingPosts event,
    Emitter<TrendingViewState> emit,
  ) async {
    Map<String, dynamic> data = await ApiService().fetchTrendingPosts(
      event.userId,
      vector,
      page,
    );
    List<Ad> ads = List.from(state.ads);
    List<Post> posts = data['posts'];
    page++;
    vector = data['vector'];
    Ad? ad = data['ad'];

    if (ad != null) {
      bool exists = ads.any((a) => a.adId == ad.adId);
      if (!exists) {
        ads.add(ad);
      }
    }

    if (posts.length < limit) {
      emit(
        state.copyWith(
          trending: posts,
          ads: ads,
          trendingInitialLoading: false,
          trendingBottomLoading: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          trending: posts,
          ads: ads,
          trendingInitialLoading: false,
          trendingBottomLoading: true,
        ),
      );
    }
  }

  fetchInitialNews(
    FetchInitialNews event,
    Emitter<TrendingViewState> emit,
  ) async {
    emit(state.copyWith(newsInitialLoading: true));

    List<News> news = await ApiService().fetchNews(event.country, event.date);
    emit(state.copyWith(news: news, newsInitialLoading: false));
  }

  fetchBottomTrendingPosts(
    FetchBottomTrendingPosts event,
    Emitter<TrendingViewState> emit,
  ) async {
    Map<String, dynamic> data = await ApiService().fetchTrendingPosts(
      event.userId,
      vector,
      page,
    );
    List<Ad> ads = List.from(state.ads);

    List<Post> posts = data['posts'];
    page++;
    vector = data['vector'];
    Ad? ad = data['ad'];

    if (ad != null) {
      bool exists = ads.any((a) => a.adId == ad.adId);
      if (!exists) {
        ads.add(ad);
      }
    }

    final List<Post> trendingPosts = List.from(state.trending);
    trendingPosts.addAll(posts);

    if (posts.length < limit) {
      emit(
        state.copyWith(
          trending: trendingPosts,
          trendingBottomLoading: false,
          ads: ads,
        ),
      );
    } else {
      emit(
        state.copyWith(
          trending: trendingPosts,
          trendingBottomLoading: true,
          ads: ads,
        ),
      );
    }
  }

  upVotePost(UpVotePost event, Emitter<TrendingViewState> emit) {
    List<Post> posts = List.from(state.trending);
    ApiService().updatingVotes(
      int.parse(posts[event.index].id),
      event.userId,
      true,
      event.context,
    );
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
    } else {
      //undo the vote
      posts[event.index] = posts[event.index].copyWith(
        isDownVote: false,
        isUpVote: false,
        upvotes: posts[event.index].upvotes - 1,
      );
      emit(state.copyWith(trending: posts));
    }
  }

  downVotePost(DownVotePost event, Emitter<TrendingViewState> emit) {
    List<Post> posts = List.from(state.trending);
    ApiService().updatingVotes(
      int.parse(posts[event.index].id),
      event.userId,
      false,
      event.context,
    );
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
    } else {
      //undo the vote
      posts[event.index] = posts[event.index].copyWith(
        isDownVote: false,
        isUpVote: false,
        downvotes: posts[event.index].downvotes - 1,
      );
      emit(state.copyWith(trending: posts));
    }
  }

  reportPost(ReportPost event, Emitter<TrendingViewState> emit) {}
  savePost(SavePost event, Emitter<TrendingViewState> emit) {}

  upVoteNewsPost(UpVoteNewsPost event, Emitter<TrendingViewState> emit) {
    List<News> news = List.from(state.news);
    List<Post> posts = List.from(news[event.newsIndex].discussions);
    ApiService().updatingVotes(
      int.parse(posts[event.index].id),
      event.userId,
      true,
      event.context,
    );
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
    } else {
      //undo the vote
      posts[event.index] = posts[event.index].copyWith(
        isDownVote: false,
        isUpVote: false,
        upvotes: posts[event.index].upvotes - 1,
      );
      news[event.newsIndex] = news[event.newsIndex].copyWith(
        discussions: posts,
      );
      emit(state.copyWith(news: news));
    }
  }

  downVoteNewsPost(DownVoteNewsPost event, Emitter<TrendingViewState> emit) {
    List<News> news = List.from(state.news);
    List<Post> posts = List.from(news[event.newsIndex].discussions);
    ApiService().updatingVotes(
      int.parse(posts[event.index].id),
      event.userId,
      false,
      event.context,
    );
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
    } else {
      //undo the vote
      posts[event.index] = posts[event.index].copyWith(
        isDownVote: false,
        isUpVote: false,
        downvotes: posts[event.index].downvotes - 1,
      );
      news[event.newsIndex] = news[event.newsIndex].copyWith(
        discussions: posts,
      );
      emit(state.copyWith(news: news));
    }
  }

  syncUpVoteTrendingPost(
    SyncUpVoteTrendingPost event,
    Emitter<TrendingViewState> emit,
  ) {
    // Update in Trending list
    List<Post> trendingPosts = List.from(state.trending);
    int trendingIndex = trendingPosts.indexWhere(
      (post) => post.id == event.postId,
    );

    if (trendingIndex != -1) {
      Post post = trendingPosts[trendingIndex];
      if (!post.isUpVote) {
        if (post.isDownVote) {
          post = post.copyWith(
            isUpVote: true,
            isDownVote: false,
            upvotes: post.upvotes + 2,
          );
        } else {
          post = post.copyWith(isUpVote: true, upvotes: post.upvotes + 1);
        }
      } else {
        post = post.copyWith(isUpVote: false, upvotes: post.upvotes - 1);
      }
      trendingPosts[trendingIndex] = post;
      emit(state.copyWith(trending: trendingPosts));
    }
  }

  syncDownVoteTrendingPost(
    SyncDownVoteTrendingPost event,
    Emitter<TrendingViewState> emit,
  ) {
    // Update in Trending list
    List<Post> trendingPosts = List.from(state.trending);
    int trendingIndex = trendingPosts.indexWhere(
      (post) => post.id == event.postId,
    );

    if (trendingIndex != -1) {
      Post post = trendingPosts[trendingIndex];
      if (!post.isDownVote) {
        if (post.isUpVote) {
          post = post.copyWith(
            isDownVote: true,
            isUpVote: false,
            downvotes: post.downvotes + 2,
          );
        } else {
          post = post.copyWith(isDownVote: true, downvotes: post.downvotes + 1);
        }
      } else {
        post = post.copyWith(isDownVote: false, downvotes: post.downvotes - 1);
      }
      trendingPosts[trendingIndex] = post;
      emit(state.copyWith(trending: trendingPosts));
    }
  }

  syncUpVoteNewsPost(
    SyncUpVoteNewsPost event,
    Emitter<TrendingViewState> emit,
  ) {
    List<News> newsList = List.from(state.news);
    int newsIndex = newsList.indexWhere((n) => n.newsId == event.newsId);

    if (newsIndex != -1) {
      List<Post> posts = List.from(newsList[newsIndex].discussions);
      int postIndex = posts.indexWhere((p) => p.id == event.postId);

      if (postIndex != -1) {
        Post post = posts[postIndex];

        if (!post.isUpVote) {
          if (post.isDownVote) {
            post = post.copyWith(
              isDownVote: false,
              isUpVote: true,
              upvotes: post.upvotes + 2,
            );
          } else {
            post = post.copyWith(isUpVote: true, upvotes: post.upvotes + 1);
          }
        } else {
          // undo upvote
          post = post.copyWith(isUpVote: false, upvotes: post.upvotes - 1);
        }

        posts[postIndex] = post;
        newsList[newsIndex] = newsList[newsIndex].copyWith(discussions: posts);
        emit(state.copyWith(news: newsList));
      }
    }
  }

  syncDownVoteNewsPost(
    SyncDownVoteNewsPost event,
    Emitter<TrendingViewState> emit,
  ) {
    List<News> newsList = List.from(state.news);
    int newsIndex = newsList.indexWhere((n) => n.newsId == event.newsId);

    if (newsIndex != -1) {
      List<Post> posts = List.from(newsList[newsIndex].discussions);
      int postIndex = posts.indexWhere((p) => p.id == event.postId);

      if (postIndex != -1) {
        Post post = posts[postIndex];

        if (!post.isDownVote) {
          if (post.isUpVote) {
            post = post.copyWith(
              isDownVote: true,
              isUpVote: false,
              downvotes: post.downvotes + 2,
            );
          } else {
            post = post.copyWith(
              isDownVote: true,
              downvotes: post.downvotes + 1,
            );
          }
        } else {
          // undo downvote
          post = post.copyWith(
            isDownVote: false,
            downvotes: post.downvotes - 1,
          );
        }

        posts[postIndex] = post;
        newsList[newsIndex] = newsList[newsIndex].copyWith(discussions: posts);
        emit(state.copyWith(news: newsList));
      }
    }
  }

  void fetchPostsWithInNews(
    FetchPostsWithInNews event,
    Emitter<TrendingViewState> emit,
  ) async {
    if (state.news[event.newsIndex].discussions.isEmpty) {
      emit(state.copyWith(fetchingPostsWithInNews: true));
      await Future.delayed(Duration(seconds: 2));
      List<News> news = List.from(state.news);
      List<Post> posts = await ApiService().fetchPostsWithInNews(
        news[event.newsIndex].newsId,
        event.userId,
      );
      news[event.newsIndex] = news[event.newsIndex].copyWith(
        discussions: posts,
      );

      emit(state.copyWith(fetchingPostsWithInNews: false, news: news));
    }
  }
}
