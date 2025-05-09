import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/Home/home_bloc.dart' as homeBloc;
import 'package:verbatica/BLOC/User%20bloc/user_event.dart';
import 'package:verbatica/BLOC/User%20bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState()) {
    on<UpdateUser>(_onUpdateUser);
    on<UpdateAvatar>(_onUpdateAvatar);
    on<UpdateAbout>(_onUpdateAbout);
    on<UpVotePost>(upVotePost);
    on<DownVotePost>(downVotePost);
  }

  // Future<void> _onFetchUser(FetchUser event, Emitter<UserState> emit) async {
  //   emit(UserLoading());
  //   try {
  //     // Replace with actual API call
  //     final user = await _fetchUserFromApi(event.username);
  //     emit(UserLoaded(user));
  //   } catch (e) {
  //     emit(UserError(e.toString()));
  //   }
  // }
  void _onUpdateAvatar(UpdateAvatar event, Emitter<UserState> emit) {
    final currentUser = state.user;
    final updatedUser = currentUser.copyWith(avatarUrl: event.newAvatarId);
    emit(state.copyWith(user: updatedUser));

    // Here you would typically also persist to local storage/API
    // await _userRepository.updateAvatar(event.newAvatarUrl);
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
  }

  upVotePost(UpVotePost event, Emitter<UserState> emit) {
    if (!state.user.upVotedPosts.contains(event.postId)) {
      if (state.user.downVotedPosts.contains(event.postId)) {
        //Removing from down voted posts
        List<String> downvotes = state.user.downVotedPosts;
        downvotes.remove(event.postId);
        emit(
          state.copyWith(
            user: state.user.copyWith(downVotedPosts: List.from(downvotes)),
          ),
        );
        //Adding into upvoted posts
        List<String> upvotes = state.user.upVotedPosts;
        upvotes.add(event.postId);
        emit(
          state.copyWith(
            user: state.user.copyWith(upVotedPosts: List.from(upvotes)),
          ),
        );

        event.context.read<homeBloc.HomeBloc>().add(
          homeBloc.UpVotePost(
            index: event.index,
            category: event.category,
            incrementBy: 2,
          ),
        );
      } else {
        //Adding into upvoted posts
        List<String> upvotes = state.user.upVotedPosts;
        upvotes.add(event.postId);
        emit(
          state.copyWith(
            user: state.user.copyWith(upVotedPosts: List.from(upvotes)),
          ),
        );
        event.context.read<homeBloc.HomeBloc>().add(
          homeBloc.UpVotePost(
            index: event.index,
            category: event.category,
            incrementBy: 1,
          ),
        );
      }
    }
  }

  downVotePost(DownVotePost event, Emitter<UserState> emit) {
    if (!state.user.downVotedPosts.contains(event.postId)) {
      if (state.user.upVotedPosts.contains(event.postId)) {
        //removing from the upvoted list
        List<String> upvotes = state.user.upVotedPosts;
        upvotes.remove(event.postId);
        emit(
          state.copyWith(
            user: state.user.copyWith(upVotedPosts: List.from(upvotes)),
          ),
        );
        //Adding in the downvotes list
        List<String> downvotes = state.user.downVotedPosts;
        downvotes.add(event.postId);
        emit(
          state.copyWith(
            user: state.user.copyWith(downVotedPosts: List.from(downvotes)),
          ),
        );
        //Updates two times
        event.context.read<homeBloc.HomeBloc>().add(
          homeBloc.DownVotePost(
            index: event.index,
            category: event.category,
            decrementBy: 2,
          ),
        );
      } else {
        //Adding in the downvotes list

        List<String> downvotes = state.user.downVotedPosts;
        downvotes.add(event.postId);
        emit(
          state.copyWith(
            user: state.user.copyWith(downVotedPosts: List.from(downvotes)),
          ),
        );
        event.context.read<homeBloc.HomeBloc>().add(
          homeBloc.DownVotePost(
            index: event.index,
            category: event.category,
            decrementBy: 1,
          ),
        );
      }
    }
  }
}
