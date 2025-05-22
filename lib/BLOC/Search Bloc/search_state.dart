part of 'search_bloc.dart';

class SearchState extends Equatable {
  final List<User> users;
  final List<Post> posts;
  final bool loadingUsers;
  final bool loadingPosts;

  const SearchState({
    this.users = const [],
    this.posts = const [],
    this.loadingUsers = false,
    this.loadingPosts = false,
  });

  SearchState copyWith({
    List<User>? users,
    List<Post>? posts,
    bool? loadingUsers,
    bool? loadingPosts,
  }) {
    return SearchState(
      users: users ?? this.users,
      posts: posts ?? this.posts,
      loadingUsers: loadingUsers ?? this.loadingUsers,
      loadingPosts: loadingPosts ?? this.loadingPosts,
    );
  }

  @override
  List<Object> get props => [users, posts, loadingUsers, loadingPosts];
}
