import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:verbatica/model/Post.dart';

import '../../DummyData/dummyPosts.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
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
    //Dummy Logic
    await Future.delayed(Duration(seconds: 2));
    emit(
      state.copyWith(
        forYou: List.from(forYouPosts),
        forYouInitialLoading: false,
      ),
    );
  }

  fetchInitialFollowingPosts(
    FetchInitialFollowingPosts event,
    Emitter<HomeState> emit,
  ) async {
    print("Following initial call");

    await Future.delayed(Duration(seconds: 2));
    emit(
      state.copyWith(
        following: List.from(followingPosts),
        followingInitialLoading: false,
      ),
    );
  }

  fetchBottomForYouPosts(
    FetchBottomForYouPosts event,
    Emitter<HomeState> emit,
  ) {}
  fetchBottomFollowingPosts(
    FetchBottomFollowingPosts event,
    Emitter<HomeState> emit,
  ) {}
  upVotePost(UpVotePost event, Emitter<HomeState> emit) {
    if (event.category == "ForYou") {
      List<Post> posts = List.from(state.forYou);
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
      }
    } else if (event.category == 'Following') {
      List<Post> posts = List.from(state.following);
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
      }
    }
  }

  downVotePost(DownVotePost event, Emitter<HomeState> emit) {
    if (event.category == "ForYou") {
      List<Post> posts = List.from(state.forYou);
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
      }
    } else {
      List<Post> posts = List.from(state.following);
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
      }
    }
  }

  reportPost(ReportPost event, Emitter<HomeState> emit) {}
  savePost(SavePost event, Emitter<HomeState> emit) {}
}
