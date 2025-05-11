part of 'otheruser_bloc.dart';

class OtheruserState extends Equatable {
  final User user;

  // Proper constructor
  OtheruserState({User? user}) : user = user ?? _defaultUser();

  // CopyWith method
  OtheruserState copyWith({User? user}) {
    return OtheruserState(user: user ?? this.user);
  }

  static User _defaultUser() {
    return dummyUser;
  }

  @override
  List<Object?> get props => [user];
}

class otheruserStateinitial extends OtheruserState {
  otheruserStateinitial({required super.user});
}
