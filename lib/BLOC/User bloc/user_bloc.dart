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
      final updatedUpvotes = List<String>.from(state.user.upVotedPosts);
      final updatedDownvotes = List<String>.from(state.user.downVotedPosts);

      if (updatedDownvotes.contains(event.postId)) {
        updatedDownvotes.remove(event.postId);
        updatedUpvotes.add(event.postId);

        emit(
          state.copyWith(
            user: state.user.copyWith(
              downVotedPosts: updatedDownvotes,
              upVotedPosts: updatedUpvotes,
            ),
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
        updatedUpvotes.add(event.postId);

        emit(
          state.copyWith(
            user: state.user.copyWith(upVotedPosts: updatedUpvotes),
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
      final updatedUpvotes = List<String>.from(state.user.upVotedPosts);
      final updatedDownvotes = List<String>.from(state.user.downVotedPosts);

      if (updatedUpvotes.contains(event.postId)) {
        updatedUpvotes.remove(event.postId);
        updatedDownvotes.add(event.postId);

        emit(
          state.copyWith(
            user: state.user.copyWith(
              upVotedPosts: updatedUpvotes,
              downVotedPosts: updatedDownvotes,
            ),
          ),
        );

        event.context.read<homeBloc.HomeBloc>().add(
          homeBloc.DownVotePost(
            index: event.index,
            category: event.category,
            decrementBy: 2,
          ),
        );
      } else {
        updatedDownvotes.add(event.postId);

        emit(
          state.copyWith(
            user: state.user.copyWith(downVotedPosts: updatedDownvotes),
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
