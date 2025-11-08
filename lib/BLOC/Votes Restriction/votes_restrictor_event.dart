part of 'votes_restrictor_bloc.dart';

abstract class VotesRestrictorEvent extends Equatable {
  const VotesRestrictorEvent();

  @override
  List<Object> get props => [];
}

class RegisterVote extends VotesRestrictorEvent {
  final String postId;

  const RegisterVote({required this.postId});
}

class RegisterVoteOnComment extends VotesRestrictorEvent {
  final String commentId;

  const RegisterVoteOnComment({required this.commentId});
}
