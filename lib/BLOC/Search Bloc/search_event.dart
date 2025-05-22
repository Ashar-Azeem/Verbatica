part of 'search_bloc.dart';

sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchUsers extends SearchEvent {
  final String userName;

  const SearchUsers({required this.userName});
}

class SearchPosts extends SearchEvent {
  final String postTitle;

  const SearchPosts({required this.postTitle});
}

class UpVotePost extends SearchEvent {
  final int index;

  const UpVotePost({required this.index});
}

class DownVotePost extends SearchEvent {
  final int index;

  const DownVotePost({required this.index});
}

class ReportPost extends SearchEvent {
  final int index;
  final String postId;

  const ReportPost({required this.index, required this.postId});
}

class SavePost extends SearchEvent {
  final Post post;

  const SavePost({required this.post});
}

class SharePost extends SearchEvent {
  final Post post;

  const SharePost({required this.post});
}

class Reset extends SearchEvent {
  const Reset();
}
