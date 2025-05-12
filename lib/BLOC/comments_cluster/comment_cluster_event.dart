part of 'comment_cluster_bloc.dart';

sealed class CommentClusterEvent extends Equatable {
  const CommentClusterEvent();

  @override
  List<Object> get props => [];
}

class LoadInitialComments extends CommentClusterEvent {
  final String clusterId;

  const LoadInitialComments({required this.clusterId});
}
