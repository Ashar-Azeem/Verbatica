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
class FetchUserPosts extends OtheruserEvent {}

class upvotePost extends OtheruserEvent {
  final int index;
  const upvotePost({required this.index});
}

class downvotePost extends OtheruserEvent {
  final int index;
  const downvotePost({required this.index});
  // New event for deleting a user post
}

class UpdateRelationship extends OtheruserEvent {
  final int myUserId;
  final int otherUserId;

  const UpdateRelationship({required this.myUserId, required this.otherUserId});
}

class clearBloc extends OtheruserEvent {}
