import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_registeration_event.dart';
part 'login_registeration_state.dart';

class LoginRegisterationBloc
    extends Bloc<LoginRegisterationEvent, LoginRegisterationState> {
  LoginRegisterationBloc() : super(LoginRegisterationState()) {
    on<LoginEvent>(login);
    on<Registration>(register);
  }

  void login(LoginEvent event, Emitter<LoginRegisterationState> emit) {
    //Only login when the credentials exists and are correct and also the isEmailVerified field is true too.
    //otherwise display the exception of user doesn't exist.
  }
  void register(Registration event, Emitter<LoginRegisterationState> emit) {
    //Data is sent to the server
    //server would check if the email has already been registered or not
    //if it is registered then check the isEmaillVerified field
    //If yes then sends the exception of email already in use
    //if not then remove the old info and register this user in the db and also isEmailVerified is false
    //if the user then verifies this email then this account is concrete to one user and can enter to their credencials and login to system.
  }
}
