import 'package:flutter/material.dart';
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

class UpVotePost extends UserEvent {
  final int index;
  final String category;
  final String postId;
  final BuildContext context;

  UpVotePost({
    required this.index,
    required this.category,
    required this.postId,
    required this.context,
  });
}

class DownVotePost extends UserEvent {
  final int index;
  final String category;
  final String postId;
  final BuildContext context;

  DownVotePost({
    required this.index,
    required this.category,
    required this.postId,
    required this.context,
  });
}
