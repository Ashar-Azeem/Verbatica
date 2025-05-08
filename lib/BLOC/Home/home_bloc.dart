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
  upVotePost(UpVotePost event, Emitter<HomeState> emit) {}
  downVotePost(DownVotePost event, Emitter<HomeState> emit) {}
}
