part of 'comment_cluster_bloc.dart';

// sealed class CommentClusterState extends Equatable {
//   const CommentClusterState();

//   @override
//   List<Object> get props => [];
// }

final class CommentClusterInitial extends CommentClusterState {}

class CommentClusterState extends Equatable {
  final List<Comment> comments;

  const CommentClusterState({this.comments = const []});

  CommentClusterState copyWith({
    List<Comment>? comments,
    bool? initialLoader,
    bool? hasMore,
    bool? commentLoading,
    Map<String, dynamic>? replyToComment,
  }) {
    return CommentClusterState(comments: comments ?? this.comments);
  }

  @override
  List<Object?> get props => [comments];
}
