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
    print("For you initial call");
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
      final updatedPost = state.forYou[event.index].copyWith(
        upvotes: state.forYou[event.index].upvotes + event.incrementBy,
      );
      final newForYou = List<Post>.from(state.forYou);
      newForYou[event.index] = updatedPost;
      emit(state.copyWith(forYou: newForYou));
    } else {
      final updatedPost = state.following[event.index].copyWith(
        upvotes: state.following[event.index].upvotes + event.incrementBy,
      );
      final newFollowing = List<Post>.from(state.following);
      newFollowing[event.index] = updatedPost;
      emit(state.copyWith(following: newFollowing));
    }
  }

  downVotePost(DownVotePost event, Emitter<HomeState> emit) {
    if (event.category == "ForYou") {
      final updatedPost = state.forYou[event.index].copyWith(
        upvotes: state.forYou[event.index].upvotes - event.decrementBy,
      );
      final newForYou = List<Post>.from(state.forYou);
      newForYou[event.index] = updatedPost;
      emit(state.copyWith(forYou: newForYou));
    } else {
      final updatedPost = state.following[event.index].copyWith(
        upvotes: state.following[event.index].upvotes - event.decrementBy,
      );
      final newFollowing = List<Post>.from(state.following);
      newFollowing[event.index] = updatedPost;
      emit(state.copyWith(following: newFollowing));
    }
  }

  reportPost(ReportPost event, Emitter<HomeState> emit) {}
  savePost(SavePost event, Emitter<HomeState> emit) {}
}
