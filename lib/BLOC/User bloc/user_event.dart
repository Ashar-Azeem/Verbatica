import 'package:flutter/material.dart';
import 'package:verbatica/model/user.dart';

abstract class UserEvent {}

class FetchUser extends UserEvent {
  final String username;

  FetchUser(this.username);
}

class UpdateUser extends UserEvent {
  final User user;
  final BuildContext context;

  UpdateUser(this.user, this.context);
}

class UpdateAvatar extends UserEvent {
  final int newAvatarId;
  UpdateAvatar(this.newAvatarId);
}

class UpdateAbout extends UserEvent {
  final String newAbout;
  UpdateAbout(this.newAbout);
}

class updateCommentWithPost extends UserEvent {}
