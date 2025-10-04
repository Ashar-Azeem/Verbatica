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
  final List<Post> similarPosts;
  final String currentScreen;

  const PostState({
    this.status = PostStatus.done,
    this.currentScreen = 'simplePost',
    this.loading = false,
    this.error,
    this.progress,
    this.similarPosts = const [],
  });

  PostState copyWith({
    PostStatus? status,
    bool? loading,
    String? error,
    String? progress,
    String? currentScreen,
    List<Post>? similarPosts,
  }) {
    return PostState(
      loading: loading ?? this.loading,
      status: status ?? this.status,
      error: error ?? this.error,
      progress: progress ?? this.progress,
      currentScreen: currentScreen ?? this.currentScreen,
      similarPosts: similarPosts ?? this.similarPosts,
    );
  }

  @override
  List<Object?> get props => [
    status,
    progress,
    loading,
    error,
    similarPosts,
    currentScreen,
  ];
}
