import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/Chat%20Bloc/chat_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_event.dart';
import 'package:verbatica/BLOC/User%20bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserState()) {
    on<UpdateUser>(_onUpdateUser);
    on<UpdateAvatar>(_onUpdateAvatar);
    on<UpdateAbout>(_onUpdateAbout);
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
}
