// States
import 'package:equatable/equatable.dart';
import 'package:verbatica/model/Post.dart';

enum PostStatus {
  checkingDuplicates,
  preparingVideo,
  preparingImage,
  uploadingToTheServer,
  done,
  error,
  encrypting,
}

class PostState extends Equatable {
  final PostStatus status;
  final bool loading;
  final String? error;
  final String? progress;
  final List<Post>? similarPosts;

  const PostState({
    this.status = PostStatus.checkingDuplicates,
    this.loading = false,
    this.error,
    this.progress,
    this.similarPosts,
  });

  PostState copyWith({
    PostStatus? status,
    bool? loading,
    String? error,
    String? progress,
    List<Post>? similarPosts,
  }) {
    return PostState(
      loading: loading ?? this.loading,
      status: status ?? this.status,
      error: error ?? this.error,
      progress: progress ?? this.progress,
      similarPosts: similarPosts ?? this.similarPosts,
    );
  }

  @override
  List<Object?> get props => [status, progress, loading, error, similarPosts];
}
