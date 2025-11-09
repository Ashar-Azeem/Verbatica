import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/Chat%20Bloc/chat_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_event.dart';
import 'package:verbatica/BLOC/User%20bloc/user_state.dart';
import 'package:verbatica/LocalDB/TokenOperations.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/comment.dart';
import 'package:verbatica/model/user.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final int limit = 10;
  UserBloc() : super(UserState()) {
    on<UpdateUser>(_onUpdateUser);
    on<UpdateAvatarAndAbout>(_onUpdateAvatarAndAbout);
    on<updateCommentWithPost>(_onupdateComment);
    on<FetchUserPosts>(_onFetchUserPosts);
    on<DeleteUserPost>(_onDeleteUserPost);
    on<UpdateAura>(updateAura);
    on<SavePost1>(_onSavePost);
    on<UnsavePost1>(_onUnsavePost);
    on<FetchSavedPosts>(_onFetchSavedPosts);
    on<upvotePost1>(_UpvotePost);
    on<downvotePost1>(_downvotePost);
    on<upvotesavedPost1>(_UpvotesavedPost);
    on<downvotesavedPost>(_downvotesavedPost);
    on<ClearBloc>(clearBloc);
    on<FetchMorePosts>(fetchMorePosts);
    on<SyncUpvotePost>(_syncUpvotePost);
    on<SyncDownvotePost>(_syncDownvotePost);
    on<AddRecentPost>(addRecentPost);
    on<AddNewComment>(addNewComment);
    on<UpdateCommentCountOfAPost>((event, emit) {
      if (event.category == "saved") {
        List<Post> posts = List.from(state.savedPosts);
        posts[event.postIndex] = posts[event.postIndex].copyWith(
          comments: posts[event.postIndex].comments + 1,
        );
        emit(state.copyWith(savedPosts: posts));
      } else {
        List<Post> posts = List.from(state.userPosts);
        posts[event.postIndex] = posts[event.postIndex].copyWith(
          comments: posts[event.postIndex].comments + 1,
        );
        emit(state.copyWith(userPosts: posts));
      }
    });
  }

  void addRecentPost(AddRecentPost event, Emitter<UserState> emit) {
    try {
      if (!state.isLoadingPosts) {
        List<Post> userPosts = List.from(state.userPosts);
        userPosts.insert(0, event.post);
        emit(state.copyWith(userPosts: userPosts));
      }
    } catch (e) {
      print(e);
    }
  }

  void addNewComment(AddNewComment event, Emitter<UserState> emit) {
    try {
      if (!state.isLoadingComments) {
        List<Comment> userComments = List.from(state.userComments);
        userComments.insert(0, event.comment);

        emit(state.copyWith(userComments: userComments));
      }
    } catch (e) {
      print(e);
    }
  }

  void _onUpdateAvatarAndAbout(
    UpdateAvatarAndAbout event,
    Emitter<UserState> emit,
  ) async {
    try {
      if (state.user!.avatarId != event.newAvatarId &&
          state.user!.about != event.about) {
        emit(state.copyWith(isLoadingUpdatingProfile: true));

        await ApiService().updateAvatar(state.user!.id, event.newAvatarId);
        User user = await ApiService().updateAboutSection(
          state.user!.id,
          event.about,
        );
        await TokenOperations().saveUserProfile(user);

        emit(state.copyWith(user: user, isLoadingUpdatingProfile: false));
      } else if (state.user!.avatarId != event.newAvatarId) {
        emit(state.copyWith(isLoadingUpdatingProfile: true));

        User user = await ApiService().updateAvatar(
          state.user!.id,
          event.newAvatarId,
        );
        await TokenOperations().saveUserProfile(user);

        emit(state.copyWith(user: user, isLoadingUpdatingProfile: false));
      } else if (state.user!.about != event.about) {
        emit(state.copyWith(isLoadingUpdatingProfile: true));
        User user = await ApiService().updateAboutSection(
          state.user!.id,
          event.about,
        );
        await TokenOperations().saveUserProfile(user);

        emit(state.copyWith(user: user, isLoadingUpdatingProfile: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoadingUpdatingProfile: false));
      print(e);
    }
  }

  void _UpvotesavedPost(upvotesavedPost1 event, Emitter<UserState> emit) {
    List<Post> posts = List.from(state.savedPosts);
    if (!posts[event.index].isUpVote) {
      if (posts[event.index].isDownVote) {
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: false,
          isUpVote: true,
          upvotes: posts[event.index].upvotes + 2,
        );
        emit(state.copyWith(savedPosts: posts));
      } else {
        posts[event.index] = posts[event.index].copyWith(
          isUpVote: true,
          upvotes: posts[event.index].upvotes + 1,
        );
        emit(state.copyWith(savedPosts: posts));
      }
    } else {
      //undo the vote
      posts[event.index] = posts[event.index].copyWith(
        isDownVote: false,
        isUpVote: false,
        upvotes: posts[event.index].upvotes - 1,
      );
      emit(state.copyWith(savedPosts: posts));
    }
  }

  void _downvotesavedPost(downvotesavedPost event, Emitter<UserState> emit) {
    List<Post> posts = List.from(state.savedPosts);
    if (!posts[event.index].isDownVote) {
      if (posts[event.index].isUpVote) {
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: true,
          isUpVote: false,
          upvotes: posts[event.index].upvotes - 2,
        );
        emit(state.copyWith(savedPosts: posts));
      } else {
        posts[event.index] = posts[event.index].copyWith(
          isDownVote: true,
          upvotes: posts[event.index].upvotes - 1,
        );
        emit(state.copyWith(savedPosts: posts));
      }
    } else {
      //undo the vote
      posts[event.index] = posts[event.index].copyWith(
        isDownVote: false,
        isUpVote: false,
        downvotes: posts[event.index].downvotes - 1,
      );
      emit(state.copyWith(savedPosts: posts));
    }
  }

  void _UpvotePost(upvotePost1 event, Emitter<UserState> emit) {
    List<Post> posts = List.from(state.userPosts);

    ApiService().updatingVotes(
      int.parse(posts[event.index].id),
      event.context.read<UserBloc>().state.user!.id,
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

  void _downvotePost(downvotePost1 event, Emitter<UserState> emit) {
    List<Post> posts = List.from(state.userPosts);
    ApiService().updatingVotes(
      int.parse(posts[event.index].id),
      event.context.read<UserBloc>().state.user!.id,
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

  void _syncUpvotePost(SyncUpvotePost event, Emitter<UserState> emit) {
    List<Post> posts = List.from(state.userPosts);

    int postIndex = posts.indexWhere((post) => post.id == event.postId);
    if (postIndex == -1) return;

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
      post = post.copyWith(
        isDownVote: false,
        isUpVote: false,
        upvotes: post.upvotes - 1,
      );
    }

    posts[postIndex] = post;
    emit(state.copyWith(userPosts: posts));
  }

  void _syncDownvotePost(SyncDownvotePost event, Emitter<UserState> emit) {
    List<Post> posts = List.from(state.userPosts);

    int postIndex = posts.indexWhere((post) => post.id == event.postId);
    if (postIndex == -1) return;

    Post post = posts[postIndex];
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
      post = post.copyWith(
        isDownVote: false,
        isUpVote: false,
        downvotes: post.downvotes - 1,
      );
    }

    posts[postIndex] = post;
    emit(state.copyWith(userPosts: posts));
  }

  void _onupdateComment(
    updateCommentWithPost event,
    Emitter<UserState> emit,
  ) async {
    emit(state.copyWith(isLoadingComments: true));

    final List<Comment> comments = await ApiService().fetchUserComments(
      state.user!.id,
      state.user!.id,
    );

    emit(state.copyWith(userComments: comments, isLoadingComments: false));
  }

  // New method to fetch user posts
  void _onFetchUserPosts(FetchUserPosts event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoadingPosts: true));
    List<Post> posts = await ApiService().fetchUserPosts(
      state.user!.id,
      state.user!.id,
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
  }

  void fetchMorePosts(FetchMorePosts event, Emitter<UserState> emit) async {
    try {
      List<Post> posts = await ApiService().fetchUserPosts(
        state.user!.id,
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

  void _onDeleteUserPost(DeleteUserPost event, Emitter<UserState> emit) {
    final updatedPosts =
        state.userPosts.where((post) => post.id != event.postId).toList();
    emit(state.copyWith(userPosts: updatedPosts));
  }

  void _onUpdateUser(UpdateUser event, Emitter<UserState> emit) {
    emit(state.copyWith(user: event.user));
    if (event.user.isVerified) {
      event.context.read<ChatBloc>().add(
        FetchInitialChats(userId: event.user.id),
      );
      event.context.read<ChatBloc>().onAppOpened(event.user.id.toString());
    }
  }

  // New handler for saving posts
  void _onSavePost(SavePost1 event, Emitter<UserState> emit) {
    final currentSavedPosts = state.savedPosts;

    final updatedSavedPosts = List<Post>.from(currentSavedPosts)
      ..add(event.post);
    emit(state.copyWith(savedPosts: updatedSavedPosts));
  }

  // New handler for unsaving posts
  void _onUnsavePost(UnsavePost1 event, Emitter<UserState> emit) {
    final currentSavedPosts = state.savedPosts;
    final updatedSavedPosts =
        currentSavedPosts.where((post) => post.id != event.post.id).toList();

    emit(state.copyWith(savedPosts: updatedSavedPosts));
  }

  // New handler for fetching saved posts
  void _onFetchSavedPosts(
    FetchSavedPosts event,
    Emitter<UserState> emit,
  ) async {}

  void updateAura(UpdateAura event, Emitter<UserState> emit) async {
    int aura = await ApiService().getAura(state.user!.id);
    User user = state.user!.copyWith(aura: aura);
    await TokenOperations().saveUserProfile(user);

    emit(state.copyWith(user: user));
  }

  void clearBloc(ClearBloc event, Emitter<UserState> emit) async {
    emit(state.initState());
  }
}
