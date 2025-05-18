import 'package:equatable/equatable.dart';
import 'package:verbatica/DummyData/UserDummyData.dart';
import 'package:verbatica/DummyData/dummyPosts.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/user.dart';

// user_state.dart
class UserState extends Equatable {
  final User user;
  final List<Post> userPosts = forYouPosts;
  // Correct constructor with default value
  UserState({User? user}) : user = user ?? _defaultUser();

  // Helper method for default user
  static User _defaultUser() {
    return dummyUser;
  }

  UserState copyWith({User? user}) {
    return UserState(user: user ?? this.user);
  }

  @override
  List<Object?> get props => [user];
}
