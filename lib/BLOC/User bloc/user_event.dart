import 'package:flutter/material.dart';
import 'package:verbatica/model/user.dart';
import 'package:verbatica/model/Post.dart';

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

// New event for fetching user posts
class FetchUserPosts extends UserEvent {}

// New event for deleting a user post
class DeleteUserPost extends UserEvent {
  final String postId;
  DeleteUserPost({required this.postId});
}

// New event for saving a post
class SavePost1 extends UserEvent {
  final Post post;
  SavePost1({required this.post});
}

// New event for unsaving a post
class UnsavePost1 extends UserEvent {
  final Post post;
  UnsavePost1({required this.post});
}

// New event for fetching saved posts
class FetchSavedPosts extends UserEvent {}

class upvotePost1 extends UserEvent {
  final int index;
  upvotePost1({required this.index});
}

class downvotePost1 extends UserEvent {
  final int index;
  downvotePost1({required this.index});
}

class upvotesavedPost1 extends UserEvent {
  final int index;
  upvotesavedPost1({required this.index});
}

class downvotesavedPost extends UserEvent {
  final int index;
  downvotesavedPost({required this.index});
}
