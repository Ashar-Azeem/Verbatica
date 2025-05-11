part of 'comments_bloc.dart';

sealed class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialComments extends CommentsEvent {
  final String postId;

  const LoadInitialComments({required this.postId});
}

class LoadMoreComments extends CommentsEvent {
  final Comment lastComment;

  const LoadMoreComments({required this.lastComment});
}

class UpVoteComment extends CommentsEvent {
  final Comment comment;

  const UpVoteComment({required this.comment});
}

class DownVoteComment extends CommentsEvent {
  final Comment comment;

  const DownVoteComment({required this.comment});
}

class AddComment extends CommentsEvent {
  final Comment parentComment;

  const AddComment({required this.parentComment});
}

class ReportComment extends CommentsEvent {
  final Comment comment;

  const ReportComment({required this.comment});
}
