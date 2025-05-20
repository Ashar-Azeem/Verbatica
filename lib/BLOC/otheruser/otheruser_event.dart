// ignore_for_file: camel_case_types, must_be_immutable

part of 'otheruser_bloc.dart';

sealed class OtheruserEvent extends Equatable {
  const OtheruserEvent();

  @override
  List<Object> get props => [];
}

class fetchUserinfo extends OtheruserEvent {
  String Userid;
  fetchUserinfo({required this.Userid});
}

class updateCommentWithPost extends OtheruserEvent {}

// New event for fetching user posts
class FetchUserPosts extends OtheruserEvent {}

// New event for deleting a user post
class DeleteUserPost extends OtheruserEvent {
  final String postId;
  DeleteUserPost({required this.postId});
}
