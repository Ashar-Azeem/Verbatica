// ignore_for_file: camel_case_types, must_be_immutable

part of 'otheruser_bloc.dart';

sealed class OtheruserEvent extends Equatable {
  const OtheruserEvent();

  @override
  List<Object> get props => [];
}

class fetchUserinfo extends OtheruserEvent {
  final int myUserId;
  final int otherUserId;

  const fetchUserinfo({required this.myUserId, required this.otherUserId});
}

class updateCommentWithPost extends OtheruserEvent {}

// New event for fetching user posts
class FetchUserPosts extends OtheruserEvent {
  final int userId;
  final int ownerUserId;

  const FetchUserPosts({required this.ownerUserId, required this.userId});
}

class upvotePost extends OtheruserEvent {
  final int index;
  final BuildContext context;

  const upvotePost({required this.context, required this.index});
}

class downvotePost extends OtheruserEvent {
  final int index;
  final BuildContext context;

  const downvotePost({required this.context, required this.index});
  // New event for deleting a user post
}

class UpdateRelationship extends OtheruserEvent {
  final int myUserId;
  final int otherUserId;

  const UpdateRelationship({required this.myUserId, required this.otherUserId});
}

class clearBloc extends OtheruserEvent {}

class FetchMorePosts extends OtheruserEvent {
  final int ownerUserId;

  const FetchMorePosts({required this.ownerUserId});
}
class SyncUpvoteotherPost extends OtheruserEvent {
  final String postId;

  const SyncUpvoteotherPost({required this.postId});

}

class SyncDownvoteotherPost extends OtheruserEvent {
  final String postId;

  const SyncDownvoteotherPost({required this.postId});


}
