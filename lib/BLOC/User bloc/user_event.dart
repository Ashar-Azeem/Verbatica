import 'package:flutter/material.dart';
import 'package:verbatica/model/comment.dart';
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

class UpdateAvatarAndAbout extends UserEvent {
  final int newAvatarId;
  final String about;
  UpdateAvatarAndAbout(this.newAvatarId, this.about);
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
  final BuildContext context;
  final int userId;
  SavePost1({required this.context, required this.post, required this.userId});
}

// New event for unsaving a post
class UnsavePost1 extends UserEvent {
  final Post post;
  final int userId;
  UnsavePost1({required this.post, required this.userId});
}

// New event for fetching saved posts
class FetchSavedPosts extends UserEvent {
  final int userId;

  FetchSavedPosts({required this.userId});
}

class upvotePost1 extends UserEvent {
  final int index;
  final BuildContext context;
  upvotePost1({required this.context, required this.index});
}

class downvotePost1 extends UserEvent {
  final int index;
  final BuildContext context;

  downvotePost1({required this.context, required this.index});
}

class upvotesavedPost1 extends UserEvent {
  final int index;
  upvotesavedPost1({required this.index});
}

class downvotesavedPost extends UserEvent {
  final int index;
  downvotesavedPost({required this.index});
}

class UpdateAura extends UserEvent {}

class AddRecentPost extends UserEvent {
  final Post post;

  AddRecentPost({required this.post});
}

class FetchMorePosts extends UserEvent {}

class ClearBloc extends UserEvent {}

class SyncUpvotePost extends UserEvent {
  final String postId;
  SyncUpvotePost({required this.postId});
}

class SyncDownvotePost extends UserEvent {
  final String postId;
  SyncDownvotePost({required this.postId});
}

class AddNewComment extends UserEvent {
  final Comment comment;

  AddNewComment({required this.comment});
}

class UpdateCommentCountOfAPost extends UserEvent {
  final int postIndex;
  final String category;

  UpdateCommentCountOfAPost({required this.category, required this.postIndex});
}
