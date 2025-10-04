import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/model/Post.dart';
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  Map<String, dynamic>? lastForYouPost;
  int forYouPage = 1;
  int followingPage = 1;
  List<double>? forYouVector;
  List<double>? followingVector;
  final limit = 10;
  HomeBloc() : super(HomeState()) {
    on<FetchInitialForYouPosts>(fetchInitialForYouPosts);
    on<FetchInitialFollowingPosts>(fetchInitialFollowingPosts);
    on<FetchBottomForYouPosts>(fetchBottomForYouPosts);
    on<FetchBottomFollowingPosts>(fetchBottomFollowingPosts);
    on<UpVotePost>(upVotePost);
    on<DownVotePost>(downVotePost);
    on<ReportPost>(reportPost);
    on<SavePost>(savePost);
  }
  fetchInitialForYouPosts(
    FetchInitialForYouPosts event,
    Emitter<HomeState> emit,
  ) async {
    Map<String, dynamic> data = await ApiService().fetchForYouPosts(
      event.userId,
      lastForYouPost,
      forYouVector,
      forYouPage,
    );
    List<Post> posts = data['posts'];
    forYouPage++;
    forYouVector = data['vector'];
    lastForYouPost = data['lastPost'];

    if (posts.length < limit) {
      emit(
        state.copyWith(
          forYou: posts,
          forYouInitialLoading: false,
          hasMoreForYouPosts: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          forYou: posts,
          forYouInitialLoading: false,
          hasMoreForYouPosts: true,
        ),
      );
    }
  }

  fetchInitialFollowingPosts(
    FetchInitialFollowingPosts event,
    Emitter<HomeState> emit,
  ) async {
    Map<String, dynamic> data = await ApiService().fetchFollowingPosts(
      event.userId,
      null,
      followingVector,
      followingPage,
    );
    List<Post> posts = data['posts'];
    followingPage++;
    followingVector = data['vector'];

    if (posts.length < limit) {
      emit(
        state.copyWith(
          following: posts,
          followingInitialLoading: false,
          hasMoreFollowingPosts: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          following: posts,
          followingInitialLoading: false,
          hasMoreFollowingPosts: true,
          lastFollowingPostId: int.parse(posts[posts.length - 1].id),
        ),
      );
    }
  }

  fetchBottomForYouPosts(
    FetchBottomForYouPosts event,
    Emitter<HomeState> emit,
  ) async {
    Map<String, dynamic> data = await ApiService().fetchForYouPosts(
      event.userId,
      lastForYouPost,
      forYouVector,
      forYouPage,
    );
    List<Post> posts = data['posts'];
    forYouPage++;
    forYouVector = data['vector'];
    lastForYouPost = data['lastPost'];

    final List<Post> forYouPosts = List.from(state.forYou);
    forYouPosts.addAll(posts);

    if (posts.length < limit) {
      emit(state.copyWith(forYou: forYouPosts, hasMoreForYouPosts: false));
    } else {
      emit(state.copyWith(forYou: forYouPosts, hasMoreForYouPosts: true));
    }
  }

  fetchBottomFollowingPosts(
    FetchBottomFollowingPosts event,
    Emitter<HomeState> emit,
  ) async {
    Map<String, dynamic> data = await ApiService().fetchFollowingPosts(
      event.userId,
      state.lastFollowingPostId,
      followingVector,
      followingPage,
    );
    List<Post> posts = data['posts'];
    followingPage++;
    followingVector = data['vector'];
    final List<Post> followingPosts = List.from(state.following);
    followingPosts.addAll(posts);

    if (posts.length < limit) {
      emit(
        state.copyWith(
          following: followingPosts,
          hasMoreFollowingPosts: false,
          lastFollowingPostId: null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          following: followingPosts,
          hasMoreFollowingPosts: true,
          lastFollowingPostId: int.parse(posts[posts.length - 1].id),
        ),
      );
    }
  }

  upVotePost(UpVotePost event, Emitter<HomeState> emit) {
    if (event.category == "ForYou") {
      List<Post> posts = List.from(state.forYou);
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
          emit(state.copyWith(forYou: posts));
        } else {
          posts[event.index] = posts[event.index].copyWith(
            isUpVote: true,
            upvotes: posts[event.index].upvotes + 1,
          );
          emit(state.copyWith(forYou: posts));
        }
      } else {
        //undo the vote
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: false,
          isUpVote: false,
          upvotes: posts[event.index].upvotes - 1,
        );
        emit(state.copyWith(forYou: posts));
      }
    } else if (event.category == 'Following') {
      List<Post> posts = List.from(state.following);
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
          emit(state.copyWith(following: posts));
        } else {
          posts[event.index] = posts[event.index].copyWith(
            isUpVote: true,
            upvotes: posts[event.index].upvotes + 1,
          );
          emit(state.copyWith(following: posts));
        }
      } else {
        //undo the vote
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: false,
          isUpVote: false,
          upvotes: posts[event.index].upvotes - 1,
        );
        emit(state.copyWith(following: posts));
      }
    }
  }

  downVotePost(DownVotePost event, Emitter<HomeState> emit) {
    if (event.category == "ForYou") {
      List<Post> posts = List.from(state.forYou);
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
          emit(state.copyWith(forYou: posts));
        } else {
          posts[event.index] = posts[event.index].copyWith(
            isDownVote: true,
            downvotes: posts[event.index].downvotes + 1,
          );
          emit(state.copyWith(forYou: posts));
        }
      } else {
        //undo the vote
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: false,
          isUpVote: false,
          downvotes: posts[event.index].downvotes - 1,
        );
        emit(state.copyWith(forYou: posts));
      }
    } else {
      List<Post> posts = List.from(state.following);
      ApiService().updatingVotes(
        int.parse(posts[event.index].id),
        event.userId,
        true,
        event.context,
      );
      if (!posts[event.index].isDownVote) {
        if (posts[event.index].isUpVote) {
          posts[event.index] = posts[event.index].copyWith(
            isDownVote: true,
            isUpVote: false,
            downvotes: posts[event.index].downvotes + 2,
          );
          emit(state.copyWith(following: posts));
        } else {
          posts[event.index] = posts[event.index].copyWith(
            isDownVote: true,
            downvotes: posts[event.index].downvotes + 1,
          );
          emit(state.copyWith(following: posts));
        }
      } else {
        //undo the vote
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: false,
          isUpVote: false,
          downvotes: posts[event.index].downvotes - 1,
        );
        emit(state.copyWith(following: posts));
      }
    }
  }

  reportPost(ReportPost event, Emitter<HomeState> emit) {}
  savePost(SavePost event, Emitter<HomeState> emit) {}
}
