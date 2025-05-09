// States
import 'package:equatable/equatable.dart';
import 'package:verbatica/model/Post.dart';

enum PostStatus { initial, submitting, success, duplicateFound, failed }

class PostState extends Equatable {
  final PostStatus status;
  final Post? post;
  final String? error;
  final List<Post>? similarPosts;

  const PostState({
    this.status = PostStatus.initial,
    this.post,
    this.error,
    this.similarPosts,
  });

  PostState copyWith({
    PostStatus? status,
    Post? post,
    String? error,
    List<Post>? similarPosts,
  }) {
    return PostState(
      status: status ?? this.status,
      post: post ?? this.post,
      error: error ?? this.error,
      similarPosts: similarPosts ?? this.similarPosts,
    );
  }

  @override
  List<Object?> get props => [status, post, error, similarPosts];
}
