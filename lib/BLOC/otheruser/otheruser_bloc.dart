import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart' as userBloc;
import 'package:verbatica/BLOC/otheruser/otheruser_state.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/comment.dart';
import 'package:verbatica/model/user.dart';
part 'otheruser_event.dart';

class OtheruserBloc extends Bloc<OtheruserEvent, OtheruserState> {
  final limit = 10;
  OtheruserBloc() : super(OtheruserState()) {
    on<updateCommentWithPost>(_onupdateComment);
    on<FetchUserPosts>(_onFetchUserPosts);
    on<upvotePost>(_UpvotePost);
    on<downvotePost>(_downvotePost);
    on<clearBloc>(_clearBloc);
    on<UpdateRelationship>(updateRelationship);
    on<FetchMorePosts>(fetchMorePosts);
    on<SyncUpvoteotherPost>(_syncUpvotePost);
    on<SyncDownvoteotherPost>(_syncDownvotePost);
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
    on<UpdateCommentCountOfAPost>((event, emit) {
      List<Post> posts = List.from(state.userPosts);
      posts[event.postIndex] = posts[event.postIndex].copyWith(
        comments: posts[event.postIndex].comments + 1,
      );
      emit(state.copyWith(userPosts: posts));
    });
    on<ToggleSave>((event, emit) {
      List<Post> posts = List.from(state.userPosts);
      posts[event.postIndex] = posts[event.postIndex].copyWith(
        isSaved: !posts[event.postIndex].isSaved,
      );
      emit(state.copyWith(userPosts: posts));
    });
  }
  void _UpvotePost(upvotePost event, Emitter<OtheruserState> emit) {
    List<Post> posts = List.from(state.userPosts);

    ApiService().updatingVotes(
      int.parse(posts[event.index].id),
      event.context.read<userBloc.UserBloc>().state.user!.id,
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
        emit(state.copyWith(userPosts: posts));
      } else {
        posts[event.index] = posts[event.index].copyWith(
          isUpVote: true,
          upvotes: posts[event.index].upvotes + 1,
        );
        emit(state.copyWith(userPosts: posts));
      }
    } else {
      //undo the vote
      posts[event.index] = posts[event.index].copyWith(
        isDownVote: false,
        isUpVote: false,
        upvotes: posts[event.index].upvotes - 1,
      );
      emit(state.copyWith(userPosts: posts));
    }
  }

  void _downvotePost(downvotePost event, Emitter<OtheruserState> emit) {
    List<Post> posts = List.from(state.userPosts);
    ApiService().updatingVotes(
      int.parse(posts[event.index].id),
      event.context.read<userBloc.UserBloc>().state.user!.id,
      false,
      event.context,
    );
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
    } else {
      //undo the vote
      posts[event.index] = posts[event.index].copyWith(
        isDownVote: false,
        isUpVote: false,
        downvotes: posts[event.index].downvotes - 1,
      );
      emit(state.copyWith(userPosts: posts));
    }
  }

  void _syncUpvotePost(
    SyncUpvoteotherPost event,
    Emitter<OtheruserState> emit,
  ) {
    List<Post> posts = List.from(state.userPosts);
    int index = posts.indexWhere((post) => post.id == event.postId);

    if (index != -1) {
      Post post = posts[index];
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
      posts[index] = post;
      emit(state.copyWith(userPosts: posts));
    }
  }

  void _syncDownvotePost(
    SyncDownvoteotherPost event,
    Emitter<OtheruserState> emit,
  ) {
    List<Post> posts = List.from(state.userPosts);
    int index = posts.indexWhere((post) => post.id == event.postId);

    if (index != -1) {
      Post post = posts[index];
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
        // undo downvote
        post = post.copyWith(isDownVote: false, downvotes: post.downvotes - 1);
      }
      posts[index] = post;
      emit(state.copyWith(userPosts: posts));
    }
  }

  void _onupdateComment(
    updateCommentWithPost event,
    Emitter<OtheruserState> emit,
  ) async {
    emit(state.copyWith(isLoadingComments: true));

    final List<Comment> comments = await ApiService().fetchUserComments(
      event.visitingUserId,
      event.ownerUser,
    );

    emit(state.copyWith(userComments: comments, isLoadingComments: false));
  }

  // New method to fetch user posts
  void _onFetchUserPosts(
    FetchUserPosts event,
    Emitter<OtheruserState> emit,
  ) async {
    emit(state.copyWith(isLoadingPosts: true));

    List<Post> posts = await ApiService().fetchUserPosts(
      event.ownerUserId,
      event.userId,
      null,
    );

    final List<Post> userPosts = List.from(state.userPosts);
    userPosts.addAll(posts);

    if (posts.length < limit) {
      emit(
        state.copyWith(
          userPosts: userPosts,
          isLoadingPosts: false,
          isMorePost: false,
        ),
      );
    } else {
      emit(
        state.copyWith(
          userPosts: userPosts,
          isLoadingPosts: false,
          isMorePost: true,
          lastPostId: int.parse(posts[posts.length - 1].id),
        ),
      );
    }

    emit(state.copyWith(userPosts: posts, isLoadingPosts: false));
  }

  void fetchMorePosts(
    FetchMorePosts event,
    Emitter<OtheruserState> emit,
  ) async {
    try {
      List<Post> posts = await ApiService().fetchUserPosts(
        event.ownerUserId,
        state.user!.id,
        state.lastPostId,
      );
      final List<Post> userPosts = List.from(state.userPosts);
      userPosts.addAll(posts);

      if (posts.length < limit) {
        emit(
          state.copyWith(
            userPosts: userPosts,
            isLoadingPosts: false,
            isMorePost: false,
          ),
        );
      } else {
        emit(
          state.copyWith(
            userPosts: userPosts,
            isLoadingPosts: false,
            isMorePost: true,
            lastPostId: int.parse(posts[posts.length - 1].id),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  void _clearBloc(clearBloc event, Emitter<OtheruserState> emit) {
    emit(state.initState());
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
