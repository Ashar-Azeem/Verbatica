import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:verbatica/DummyData/SearchingPostsDummyData.dart';
import 'package:verbatica/DummyData/SearchingUserDummyData.dart';
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
      transformer: debounceRestartable(const Duration(milliseconds: 500)),
    );
    on<UpVotePost>(upVotePost);
    on<DownVotePost>(downVotePost);
    on<ReportPost>(reportPost);
    on<SavePost>(savePost);
    on<Reset>(reset);
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

        if (query.trim().isEmpty) {
          emit(state.copyWith(loadingUsers: false, users: []));
        }
        await Future.delayed(const Duration(milliseconds: 150));

        List<User> matchedInState = [];
        for (User user in currentUsers) {
          final String username = user.username.toLowerCase().trim();
          if (username.startsWith(query)) {
            matchedInState.add(user);
          }
        }

        if (matchedInState.isNotEmpty) {
          emit(state.copyWith(users: matchedInState, loadingUsers: false));
        } else {
          List<User> matchedInDummy =
              dummySearchedUsers.where((user) {
                final username = user.username.toLowerCase().trim();
                return username.startsWith(query);
              }).toList();
          emit(state.copyWith(users: matchedInDummy, loadingUsers: false));
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
        final List<Post> currentPosts = List.from(state.posts);

        await Future.delayed(const Duration(milliseconds: 150));
        List<Post> matchedInState =
            currentPosts.where((post) {
              final title = post.title.toLowerCase().trim();
              return title.startsWith(query);
            }).toList();

        if (matchedInState.isNotEmpty) {
          emit(state.copyWith(posts: matchedInState, loadingPosts: false));
        } else {
          List<Post> matchedInDummy =
              searchingPosts.where((post) {
                final title = post.title.toLowerCase().trim();
                return title.startsWith(query);
              }).toList();

          emit(state.copyWith(posts: matchedInDummy, loadingPosts: false));
        }
      }
    } catch (e) {
      print(e);
    }
  }

  upVotePost(UpVotePost event, Emitter<SearchState> emit) {
    List<Post> posts = List.from(state.posts);
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
    }
  }

  downVotePost(DownVotePost event, Emitter<SearchState> emit) {
    List<Post> posts = List.from(state.posts);
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
