import 'package:verbatica/model/user.dart';

abstract class UserEvent {}

class FetchUser extends UserEvent {
  final String username;

  FetchUser(this.username);
}

class UpdateUser extends UserEvent {
  final User user;

  UpdateUser(this.user);
}

class UpdateAvatar extends UserEvent {
  final int newAvatarId;
  UpdateAvatar(this.newAvatarId);
}

class UpdateAbout extends UserEvent {
  final String newAbout;
  UpdateAbout(this.newAbout);
}
