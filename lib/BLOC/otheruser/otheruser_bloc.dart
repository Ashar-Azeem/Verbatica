import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:verbatica/BLOC/otheruser/otheruser_state.dart';
import 'package:verbatica/DummyData/UserDummyData.dart';
import 'package:verbatica/DummyData/comments.dart';
import 'package:verbatica/DummyData/dummyPosts.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/comment.dart';

part 'otheruser_event.dart';

class OtheruserBloc extends Bloc<OtheruserEvent, OtheruserState> {
  OtheruserBloc() : super(OtheruserState()) {
    on<updateCommentWithPost>(_onupdateComment);
    on<FetchUserPosts>(_onFetchUserPosts);
    on<upvotePost>(_UpvotePost);
    on<downvotePost>(_downvotePost);
    // Automatically fetch user posts when the bloc is created
    add(FetchUserPosts());
    on<fetchUserinfo>((event, emit) async {
      await Future.delayed(Duration(seconds: 2));

      final fetchedUser = dummyUser.copyWith(
        username: 'Pakistan Air Force new ',
      );

      emit(state.copyWith(user: fetchedUser));
    });
  }
  void _UpvotePost(upvotePost event, Emitter<OtheruserState> emit) {
    print('dhsfdsjhgdfjshgbfvsjbgfusgigfsiyfgwrifewrgfwiefevwukdvwfcrjtw');
    List<Post> posts = List.from(state.userPosts);
    if (!posts[event.index].isUpVote) {
      if (posts[event.index].isDownVote) {
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: false,
          isUpVote: true,
          upvotes: posts[event.index].upvotes + 2,
        );
        emit(state.copyWith(userPosts: posts));
      } else {
        posts[event.index] = posts[event.index].copyWith(
          isUpVote: true,
          upvotes: posts[event.index].upvotes + 1,
        );
        emit(state.copyWith(userPosts: posts));
      }
    }
  }

  void _downvotePost(downvotePost event, Emitter<OtheruserState> emit) {
    List<Post> posts = List.from(state.userPosts);
    if (!posts[event.index].isDownVote) {
      if (posts[event.index].isUpVote) {
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: true,
          isUpVote: false,
          upvotes: posts[event.index].upvotes - 2,
        );
        emit(state.copyWith(userPosts: posts));
      } else {
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: true,
          upvotes: posts[event.index].upvotes - 1,
        );
        emit(state.copyWith(userPosts: posts));
      }
    }
  }

  void _onupdateComment(
    updateCommentWithPost event,
    Emitter<OtheruserState> emit,
  ) async {
    emit(state.copyWith(isLoadingComments: true));

    await Future.delayed(Duration(seconds: 3));

    final List<Post> dummyPosts = dummypostuser;
    final List<Comment> matchingComments = userdummyComments;

    emit(
      state.copyWith(
        postofComment: dummyPosts,
        userComments: matchingComments,
        isLoadingComments: false,
      ),
    );
  }

  // New method to fetch user posts
  void _onFetchUserPosts(
    FetchUserPosts event,
    Emitter<OtheruserState> emit,
  ) async {
    emit(state.copyWith(isLoadingPosts: true));

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    // Get dummy user posts data
    final List<Post> userPosts = forYouPosts;

    emit(state.copyWith(userPosts: userPosts, isLoadingPosts: false));
  }
}
