part of 'comment_cluster_bloc.dart';

class CommentClusterState extends Equatable {
  final List<CommentSectionOfEachTab> comments;

  const CommentClusterState({this.comments = const []});

  CommentClusterState copyWith({
    List<CommentSectionOfEachTab>? comments,
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

class CommentSectionOfEachTab extends Equatable {
  final List<ExpandableComments> comments;
  final bool isLoading;

  const CommentSectionOfEachTab({
    required this.comments,
    required this.isLoading,
  });

  CommentSectionOfEachTab copyWith({
    bool? isLoading,
    List<ExpandableComments>? comments,
  }) {
    return CommentSectionOfEachTab(
      comments: comments ?? this.comments,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [comments, isLoading];
}

class ExpandableComments extends Equatable {
  final Comment comment;
  final bool isExpand;

  const ExpandableComments({required this.comment, required this.isExpand});

  ExpandableComments copyWith({bool? isExpand, Comment? comment}) {
    return ExpandableComments(
      comment: comment ?? this.comment,
      isExpand: isExpand ?? this.isExpand,
    );
  }

  @override
  List<Object?> get props => [comment, isExpand];
}
