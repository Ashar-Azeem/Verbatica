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
  final int userId;

  const SearchPosts({required this.userId, required this.postTitle});
}

class UpVotePost extends SearchEvent {
  final int index;
  final BuildContext context;
  final int userId;
  const UpVotePost({
    required this.index,
    required this.context,
    required this.userId,
  });
}

class DownVotePost extends SearchEvent {
  final int index;
  final BuildContext context;
  final int userId;

  const DownVotePost({
    required this.index,
    required this.context,
    required this.userId,
  });
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

class UpdateCommentCountOfAPost extends SearchEvent {
  final int postIndex;
  final String? clusters;

  const UpdateCommentCountOfAPost({
    required this.postIndex,
    required this.clusters,
  });
}

class ToggleSaveOfSearchedPosts extends SearchEvent {
  final int postIndex;

  const ToggleSaveOfSearchedPosts({required this.postIndex});
}
