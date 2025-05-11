import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:verbatica/DummyData/UserDummyData.dart';
import 'package:verbatica/model/user.dart';

part 'otheruser_event.dart';
part 'otheruser_state.dart';

class OtheruserBloc extends Bloc<OtheruserEvent, OtheruserState> {
  OtheruserBloc() : super(OtheruserState()) {
    on<fetchUserinfo>((event, emit) async {
      await Future.delayed(Duration(seconds: 2));

      final fetchedUser = dummyUser.copyWith(
        username: 'Pakistan Air Force new ',
      );

      emit(state.copyWith(user: fetchedUser));
    });
  }
}
