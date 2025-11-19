part of 'comment_cluster_bloc.dart';

sealed class CommentClusterEvent extends Equatable {
  const CommentClusterEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialComments extends CommentClusterEvent {
  const LoadInitialComments();
}

class ToggleExpandOrCollapse extends CommentClusterEvent {
  final int tabIndex;
  final int listIndex;

  const ToggleExpandOrCollapse({
    required this.tabIndex,
    required this.listIndex,
  });
}

class LoadOtherTabs extends CommentClusterEvent {
  final int tabIndex;

  const LoadOtherTabs({required this.tabIndex});
}

class UpVoteComment extends CommentClusterEvent {
  final int tabIndex;
  final int commentClusterIndex;
  final String commentId;
  final int userId;
  final BuildContext context;

  const UpVoteComment({
    required this.tabIndex,
    required this.commentClusterIndex,
    required this.commentId,
    required this.context,
    required this.userId,
  });
}

class DownVoteComment extends CommentClusterEvent {
  final int tabIndex;
  final int commentClusterIndex;
  final String commentId;
  final int userId;
  final BuildContext context;

  const DownVoteComment({
    required this.tabIndex,
    required this.userId,
    required this.commentClusterIndex,
    required this.commentId,
    required this.context,
  });
}
