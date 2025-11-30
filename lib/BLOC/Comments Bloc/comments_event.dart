part of 'comments_bloc.dart';

sealed class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialComments extends CommentsEvent {
  final String postId;
  final int userId;

  const LoadInitialComments({required this.userId, required this.postId});
}

class LoadMoreComments extends CommentsEvent {
  final String postId;
  final int userId;

  const LoadMoreComments({required this.postId, required this.userId});
}

class UpVoteComment extends CommentsEvent {
  final Comment comment;
  final String userId;
  final BuildContext context;

  const UpVoteComment({
    required this.comment,
    required this.userId,
    required this.context,
  });
}

class DownVoteComment extends CommentsEvent {
  final Comment comment;
  final String userId;
  final BuildContext context;

  const DownVoteComment({
    required this.comment,
    required this.userId,
    required this.context,
  });
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
  final int index;
  final String category;
  final int? newsIndex;
  final String comment;
  final String titleOfThePost;
  final List<String>? clusters;
  final TextEditingController commentController;
  final String postId;
  final String postDescription;
  final bool isAutomatedClusters;
  final BuildContext context;
  const UploadComment({
    required this.category,
    required this.postDescription,
    required this.isAutomatedClusters,
    this.newsIndex,
    required this.comment,
    required this.context,
    required this.titleOfThePost,
    required this.clusters,
    required this.postId,
    required this.user,
    required this.index,
    required this.commentController,
  });
}

class ReportComment extends CommentsEvent {
  final Comment comment;

  const ReportComment({required this.comment});
}

class UpdateCommentCount extends CommentsEvent {
  final int commentCount;

  const UpdateCommentCount({required this.commentCount});
}
