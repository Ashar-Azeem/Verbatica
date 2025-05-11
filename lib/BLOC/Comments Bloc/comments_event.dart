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

class SelectComment extends CommentsEvent {
  final Comment parentComment;

  const SelectComment({required this.parentComment});
}

class RemoveSelectComment extends CommentsEvent {
  const RemoveSelectComment();
}

class UploadComment extends CommentsEvent {
  final User user;
  final String comment;
  final TextEditingController commentController;
  final String postId;
  const UploadComment({
    required this.comment,
    required this.postId,
    required this.user,
    required this.commentController,
  });
}

class ReportComment extends CommentsEvent {
  final Comment comment;

  const ReportComment({required this.comment});
}
