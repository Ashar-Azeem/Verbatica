part of 'comments_bloc.dart';

class CommentsState extends Equatable {
  final List<Comment> comments;
  final bool initialLoader;
  final bool hasMore;

  const CommentsState({
    this.comments = const [],
    this.initialLoader = true,
    this.hasMore = true,
  });

  CommentsState copyWith({
    List<Comment>? comments,
    bool? initialLoader,
    bool? hasMore,
  }) {
    return CommentsState(
      comments: comments ?? this.comments,
      initialLoader: initialLoader ?? this.initialLoader,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object> get props => [comments, initialLoader, hasMore];
}
