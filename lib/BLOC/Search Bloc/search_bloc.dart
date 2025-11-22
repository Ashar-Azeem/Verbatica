import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/user.dart';
import 'package:rxdart/rxdart.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchState()) {
    on<SearchUsers>(
      searchUsers,
      transformer: debounceRestartable(const Duration(milliseconds: 500)),
    );
    on<SearchPosts>(
      searchPosts,
      transformer: debounceRestartable(const Duration(milliseconds: 1000)),
    );
    on<UpVotePost>(upVotePost);
    on<DownVotePost>(downVotePost);
    on<ReportPost>(reportPost);
    on<SavePost>(savePost);
    on<Reset>(reset);
    on<UpdateCommentCountOfAPost>((event, emit) {
      List<Post> posts = List.from(state.posts);
      posts[event.postIndex] = posts[event.postIndex].copyWith(
        comments: posts[event.postIndex].comments + 1,
      );
      emit(state.copyWith(posts: posts));
    });
    on<ToggleSaveOfSearchedPosts>((event, emit) {
      List<Post> posts = List.from(state.posts);
      posts[event.postIndex] = posts[event.postIndex].copyWith(
        isSaved: !posts[event.postIndex].isSaved,
      );
      emit(state.copyWith(posts: posts));
    });
  }

  EventTransformer<E> debounceRestartable<E>(Duration duration) {
    return (events, mapper) {
      return events.debounceTime(duration).switchMap(mapper);
    };
  }

  searchUsers(SearchUsers event, Emitter<SearchState> emit) async {
    try {
      if (event.userName.trim().isEmpty) {
        emit(state.copyWith(users: [], loadingUsers: false));
      } else {
        emit(state.copyWith(users: [], loadingUsers: true));

        final query = event.userName.toLowerCase();
        final currentUsers = List.from(state.users);

        List<User> matchedInState = [];
        for (User user in currentUsers) {
          final String username = user.userName.toLowerCase().trim();
          if (username.startsWith(query)) {
            matchedInState.add(user);
          }
        }

        if (matchedInState.isNotEmpty) {
          emit(state.copyWith(users: matchedInState, loadingUsers: false));
        } else {
          List<User> fetchedUsers = await ApiService().searchUsers(query);

          emit(state.copyWith(users: fetchedUsers, loadingUsers: false));
        }
      }
    } catch (e) {
      print(e);
    }
  }

  searchPosts(SearchPosts event, Emitter<SearchState> emit) async {
    try {
      if (event.postTitle.trim().isEmpty) {
        emit(state.copyWith(posts: [], loadingPosts: false));
      } else {
        emit(state.copyWith(posts: [], loadingPosts: true));

        final query = event.postTitle.toLowerCase();

        List<Post> fetchedPosts = await ApiService().searchedPosts(
          query,
          event.userId,
        );

        emit(state.copyWith(posts: fetchedPosts, loadingPosts: false));
      }
    } catch (e) {
      print(e);
    }
  }

  upVotePost(UpVotePost event, Emitter<SearchState> emit) {
    List<Post> posts = List.from(state.posts);
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
        emit(state.copyWith(posts: posts));
      } else {
        posts[event.index] = posts[event.index].copyWith(
          isUpVote: true,
          upvotes: posts[event.index].upvotes + 1,
        );
        emit(state.copyWith(posts: posts));
      }
    } else {
      //undo the vote
      posts[event.index] = posts[event.index].copyWith(
        isDownVote: false,
        isUpVote: false,
        upvotes: posts[event.index].upvotes - 1,
      );
      emit(state.copyWith(posts: posts));
    }
  }

  downVotePost(DownVotePost event, Emitter<SearchState> emit) {
    List<Post> posts = List.from(state.posts);
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
        emit(state.copyWith(posts: posts));
      } else {
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: true,
          downvotes: posts[event.index].downvotes + 1,
        );
        emit(state.copyWith(posts: posts));
      }
    } else {
      //undo the vote
      posts[event.index] = posts[event.index].copyWith(
        isDownVote: false,
        isUpVote: false,
        downvotes: posts[event.index].downvotes - 1,
      );
      emit(state.copyWith(posts: posts));
    }
  }

  reportPost(ReportPost event, Emitter<SearchState> emit) {}
  savePost(SavePost event, Emitter<SearchState> emit) {}
  reset(Reset event, Emitter<SearchState> emit) {
    emit(
      state.copyWith(
        users: [],
        posts: [],
        loadingPosts: false,
        loadingUsers: false,
      ),
    );
  }
}
