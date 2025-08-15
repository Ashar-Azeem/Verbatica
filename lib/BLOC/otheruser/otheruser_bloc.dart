import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:verbatica/BLOC/otheruser/otheruser_state.dart';
import 'package:verbatica/DummyData/comments.dart';
import 'package:verbatica/DummyData/dummyPosts.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/comment.dart';
import 'package:verbatica/model/user.dart';
part 'otheruser_event.dart';

class OtheruserBloc extends Bloc<OtheruserEvent, OtheruserState> {
  OtheruserBloc() : super(OtheruserState()) {
    on<updateCommentWithPost>(_onupdateComment);
    on<FetchUserPosts>(_onFetchUserPosts);
    on<upvotePost>(_UpvotePost);
    on<downvotePost>(_downvotePost);
    add(FetchUserPosts());
    on<clearBloc>(_clearBloc);
    on<UpdateRelationship>(updateRelationship);
    on<fetchUserinfo>((event, emit) async {
      try {
        Map<String, dynamic> profile = await ApiService().getProfile(
          event.myUserId,
          event.otherUserId,
        );
        emit(
          state.copyWith(
            user: profile['user'] as User,
            isFollowedByMe: profile['isFollowing'],
            isProfileLoading: false,
          ),
        );
      } catch (e) {
        print("something went wrong: $e");
      }
    });
  }
  void _UpvotePost(upvotePost event, Emitter<OtheruserState> emit) {
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

    final List<Comment> matchingComments = dummyComments;

    emit(
      state.copyWith(userComments: matchingComments, isLoadingComments: false),
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

  void _clearBloc(clearBloc event, Emitter<OtheruserState> emit) {
    emit(
      state.copyWith(
        isProfileLoading: true,
        userPosts: [],
        userComments: [],
        isLoadingComments: false,
        isLoadingPosts: false,
        attemptsInOneGo: 0,
      ),
    );
  }

  void updateRelationship(
    UpdateRelationship event,
    Emitter<OtheruserState> emit,
  ) async {
    if (state.attemptsInOneGo < 2) {
      if (state.isFollowedByMe!) {
        //unfollow
        ApiService().unFollowingAUser(event.myUserId, event.otherUserId);
        emit(
          state.copyWith(
            isFollowedByMe: !state.isFollowedByMe!,
            attemptsInOneGo: state.attemptsInOneGo + 1,
          ),
        );
      } else {
        //Follow
        ApiService().followingAUser(event.myUserId, event.otherUserId);
        emit(
          state.copyWith(
            isFollowedByMe: !state.isFollowedByMe!,
            attemptsInOneGo: state.attemptsInOneGo + 1,
          ),
        );
      }
    } else {
      emit(state.copyWith(attemptsInOneGo: state.attemptsInOneGo + 1));
    }
  }
}
