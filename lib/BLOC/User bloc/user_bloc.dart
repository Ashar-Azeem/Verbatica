import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/Chat%20Bloc/chat_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_event.dart';
import 'package:verbatica/BLOC/User%20bloc/user_state.dart';
import 'package:verbatica/DummyData/comments.dart';
import 'package:verbatica/DummyData/dummyPosts.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/comment.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState()) {
    on<UpdateUser>(_onUpdateUser);
    on<UpdateAvatar>(_onUpdateAvatar);
    on<UpdateAbout>(_onUpdateAbout);
    on<updateCommentWithPost>(_onupdateComment);
    on<FetchUserPosts>(_onFetchUserPosts);
    on<DeleteUserPost>(_onDeleteUserPost);
    // Register new event handlers
    on<SavePost1>(_onSavePost);
    on<UnsavePost1>(_onUnsavePost);
    on<FetchSavedPosts>(_onFetchSavedPosts);
    on<upvotePost1>(_UpvotePost);
    on<downvotePost1>(_downvotePost);
    on<upvotesavedPost1>(_UpvotesavedPost);
    on<downvotesavedPost>(_downvotesavedPost);
    // Automatically fetch user posts when the bloc is created
    add(FetchUserPosts());
  }

  void _onUpdateAvatar(UpdateAvatar event, Emitter<UserState> emit) {
    final currentUser = state.user;
    final updatedUser = currentUser.copyWith(avatarUrl: event.newAvatarId);
    emit(state.copyWith(user: updatedUser));
  }

  void _UpvotesavedPost(upvotesavedPost1 event, Emitter<UserState> emit) {
    print('dhsfdsjhgdfjshgbfvsjbgfusgigfsiyfgwrifewrgfwiefevwukdvwfcrjtw');
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
    }
  }

  void _UpvotePost(upvotePost1 event, Emitter<UserState> emit) {
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

  void _downvotePost(downvotePost1 event, Emitter<UserState> emit) {
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
    Emitter<UserState> emit,
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
  void _onFetchUserPosts(FetchUserPosts event, Emitter<UserState> emit) async {
    emit(state.copyWith(isLoadingPosts: true));

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    // Get dummy user posts data
    final List<Post> userPosts = forYouPosts;

    emit(state.copyWith(userPosts: userPosts, isLoadingPosts: false));
  }

  // New method to handle post deletion
  void _onDeleteUserPost(DeleteUserPost event, Emitter<UserState> emit) {
    // Filter out the post with the matching ID
    final updatedPosts =
        state.userPosts.where((post) => post.id != event.postId).toList();

    emit(state.copyWith(userPosts: updatedPosts));

    // In a real app, you would call an API here to delete the post
    // await _postRepository.deletePost(event.postId);
  }

  void _onUpdateAbout(UpdateAbout event, Emitter<UserState> emit) {
    final currentUser = state.user;
    final updatedUser = currentUser.copyWith(about: event.newAbout);
    emit(state.copyWith(user: updatedUser));

    // Here you would typically also persist to local storage/API
    // await _userRepository.updateAbout(event.newAbout);
  }

  void _onUpdateUser(UpdateUser event, Emitter<UserState> emit) {
    emit(state.copyWith(user: event.user));
    event.context.read<ChatBloc>().add(
      FetchInitialChats(userId: event.user.userId),
    );
  }

  // New handler for saving posts
  void _onSavePost(SavePost1 event, Emitter<UserState> emit) {
    final currentSavedPosts = state.savedPosts;

    // Check if the post is already saved
    // if (!currentSavedPosts.any((post) => post.id == event.post.id)) {

    final updatedSavedPosts = List<Post>.from(currentSavedPosts)
      ..add(event.post);
    emit(state.copyWith(savedPosts: updatedSavedPosts));

    // }
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
  ) async {
    if (state.savedPosts.isEmpty) {
      final sampleSavedPosts = forYouPosts.take(3).toList();
      emit(state.copyWith(savedPosts: sampleSavedPosts));
    } else {
      emit(
        state.copyWith(savedPosts: state.savedPosts),
      ); // Force emit current savedPosts
    }
  }
}
