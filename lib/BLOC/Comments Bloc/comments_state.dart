part of 'comments_bloc.dart';

class CommentsState extends Equatable {
  final List<Comment> comments;
  final bool initialLoader;
  final bool hasMore;
  final bool commentLoading;
  final Comment? replyToComment;

  const CommentsState({
    this.replyToComment,
    this.comments = const [],
    this.initialLoader = true,
    this.hasMore = true,
    this.commentLoading = false,
  });

  CommentsState copyWith({
    List<Comment>? comments,
    bool? initialLoader,
    bool? hasMore,
    bool? commentLoading,
    Map<String, dynamic>? replyToComment,
  }) {
    return CommentsState(
      comments: comments ?? this.comments,
      initialLoader: initialLoader ?? this.initialLoader,
      hasMore: hasMore ?? this.hasMore,
      commentLoading: commentLoading ?? this.commentLoading,
      replyToComment:
          replyToComment == null
              ? this.replyToComment
              : replyToComment['comment'],
    );
  }

  @override
  List<Object?> get props => [
    comments,
    initialLoader,
    hasMore,
    commentLoading,
    replyToComment,
  ];
}
