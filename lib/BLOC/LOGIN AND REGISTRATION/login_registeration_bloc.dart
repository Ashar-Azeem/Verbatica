import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_event.dart';
import 'package:verbatica/LocalDB/TokenOperations.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/Services/GoogleAuth.dart';
import 'package:verbatica/Services/endToEndEncryption.dart';
import 'package:verbatica/Utilities/ErrorSnackBar.dart';
import 'package:verbatica/model/user.dart';

part 'login_registeration_event.dart';
part 'login_registeration_state.dart';

class LoginRegisterationBloc
    extends Bloc<LoginRegisterationEvent, LoginRegisterationState> {
  LoginRegisterationBloc() : super(LoginRegisterationState()) {
    on<LoginEvent>(login);
    on<Registration>(register);
    on<VerifyOtp>(verifyOtp);
    on<ResendOTP>(resendOTP);
    on<SignInWithGoogle>(signInWithGoogle);
    on<SignInWithGoogleCompleteInfo>(signInWithGoogleCompleteInfo);
  }

  void login(LoginEvent event, Emitter<LoginRegisterationState> emit) async {
    try {
      emit(state.copyWith(status: Loginandregisterationstatus.loading));
      User user = await ApiService().loginUser(event.email, event.password);
      await TokenOperations().saveUserProfile(user);
      event.context.read<UserBloc>().add(UpdateUser(user, event.context));
      emit(state.copyWith(status: Loginandregisterationstatus.sucess));
    } catch (e) {
      emit(
        state.copyWith(
          status: Loginandregisterationstatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  void register(
    Registration event,
    Emitter<LoginRegisterationState> emit,
  ) async {
    try {
      emit(state.copyWith(status: Loginandregisterationstatus.loading));
      User user = await ApiService().registerUser(
        event.email,
        event.password,
        event.country,
        event.gender,
      );
      await TokenOperations().saveUserProfile(user);
      event.context.read<UserBloc>().add(UpdateUser(user, event.context));
      emit(state.copyWith(status: Loginandregisterationstatus.sucess));
    } catch (e) {
      emit(
        state.copyWith(
          status: Loginandregisterationstatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  void verifyOtp(VerifyOtp event, Emitter<LoginRegisterationState> emit) async {
    try {
      emit(state.copyWith(status: Loginandregisterationstatus.loading));
      final keys = await E2EEChat().generateKeyPair();

      User user = await ApiService().verifyOTP(
        event.email,
        event.userId,
        event.otp,
        keys['privateKey']!,
        keys['publicKey']!,
      );
      await TokenOperations().saveUserProfile(user);
      await TokenOperations().savePrivateKey(keys['privateKey']!);
      event.context.read<UserBloc>().add(UpdateUser(user, event.context));
      emit(state.copyWith(status: Loginandregisterationstatus.sucess));
    } catch (e) {
      emit(
        state.copyWith(
          status: Loginandregisterationstatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  void resendOTP(ResendOTP event, Emitter<LoginRegisterationState> emit) async {
    try {
      await ApiService().resendOTP(event.email);
    } catch (e) {
      CustomSnackbar.showError(event.context, "Failed to send the OTP");
    }
  }

  void signInWithGoogle(
    SignInWithGoogle event,
    Emitter<LoginRegisterationState> emit,
  ) async {
    try {
      String googleToken = await AuthService().signInWithGoogle();
      emit(state.copyWith(status: Loginandregisterationstatus.googleLoading));
      Map<String, dynamic> map = await ApiService().sendGoogleTokensToBackend(
        googleToken,
      );
      User user = map['user'];
      String message = map['status'];

      //All the info is complete
      if (message == "Complete") {
        await TokenOperations().saveUserProfile(user);
        event.context.read<UserBloc>().add(UpdateUser(user, event.context));
        emit(state.copyWith(status: Loginandregisterationstatus.sucess));
      } else {
        //Requires country and gender
        emit(
          state.copyWith(
            status: Loginandregisterationstatus.googleDone,
            user: user,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          status: Loginandregisterationstatus.failure,
          error: e.toString(),
        ),
      );
    }
  }

  void signInWithGoogleCompleteInfo(
    SignInWithGoogleCompleteInfo event,
    Emitter<LoginRegisterationState> emit,
  ) async {
    try {
      emit(state.copyWith(status: Loginandregisterationstatus.googleLoading));
      User userPayLoad = state.user!;
      userPayLoad = userPayLoad.copyWith(
        country: event.country,
        gender: event.gender,
      );
      final keys = await E2EEChat().generateKeyPair();

      User user = await ApiService().completeFirstTimerGoogleSignUp(
        userPayLoad,
        keys['privateKey']!,
        keys['publicKey']!,
      );
      await TokenOperations().savePrivateKey(keys['privateKey']!);

      await TokenOperations().saveUserProfile(user);
      event.context.read<UserBloc>().add(UpdateUser(user, event.context));
      emit(state.copyWith(status: Loginandregisterationstatus.sucess));
    } catch (e) {
      emit(
        state.copyWith(
          status: Loginandregisterationstatus.failure,
          error: e.toString(),
        ),
      );
    }
  }
}
