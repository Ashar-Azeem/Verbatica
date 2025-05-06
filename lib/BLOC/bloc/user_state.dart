import 'package:equatable/equatable.dart';
import 'package:verbatica/model/user.dart';

// user_state.dart
class UserState extends Equatable {
  final User user;

  // Correct constructor with default value
  UserState({User? user}) : user = user ?? _defaultUser();

  // Helper method for default user
  static User _defaultUser() {
    return User(
      username: 'AnonymousRebel354',
      country: 'Pakistan',
      karma: 0,
      followers: 0,
      following: 0,
      joinedDate: DateTime.now(),
      about:
          'ahfhjadfbjdbfjshdbfhjsbfjhsdbfjsdfbsfhsjfjsfdbjsdfjhsfbjsfdjshf...',
      avatarId: 1,
    );
  }

  UserState copyWith({User? user}) {
    return UserState(user: user ?? this.user);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [user];
}
