// ignore_for_file: use_build_context_synchronously, library_prefixes

import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/Home/home_bloc.dart' as HomeBloc;
import 'package:verbatica/BLOC/Search%20Bloc/search_bloc.dart';
import 'package:verbatica/BLOC/Trending%20View%20BLOC/trending_view_bloc.dart'
    as trendingBloc;
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart' as userBloc;
import 'package:verbatica/BLOC/User%20bloc/user_event.dart' as userEvent;
import 'package:verbatica/BLOC/otheruser/otheruser_bloc.dart' as OtherUserBloc;
import 'package:verbatica/BLOC/postsubmit/postsubmit_bloc.dart';
import 'package:verbatica/BLOC/postsubmit/postsubmit_event.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/Services/encryption.dart';
import 'package:verbatica/model/comment.dart';
import 'package:verbatica/model/user.dart';
part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  DateTime lastCommentMarker = DateTime.now();
  final int limit = 10;
  CommentsBloc({required String postId, required int userID})
    : super(CommentsState()) {
    on<LoadInitialComments>(loadInitialComments);
    on<LoadMoreComments>(loadMoreComments);
    on<UpVoteComment>(upVoteComment);
    on<DownVoteComment>(downVoteComment);
    on<SelectComment>(selectComment);
    on<UploadComment>(uploadComment);
    on<RemoveSelectComment>(removeSelectComment);
    add(LoadInitialComments(postId: postId, userId: userID));
    on<UpdateCommentCount>((event, emit) {
      emit(state.copyWith(totalCommentCount: event.commentCount));
    });
  }

  loadInitialComments(
    LoadInitialComments event,
    Emitter<CommentsState> emit,
  ) async {
    final List<Comment> comments = await ApiService().fetchPostComments(
      event.userId,
      event.postId,
      lastCommentMarker,
    );

    if (comments.length < limit) {
      emit(
        state.copyWith(
          initialLoader: false,
          comments: comments,
          hasMore: false,
        ),
      );
    } else {
      lastCommentMarker = comments[limit - 1].uploadTime;
      emit(
        state.copyWith(initialLoader: false, comments: comments, hasMore: true),
      );
    }
  }

  loadMoreComments(LoadMoreComments event, Emitter<CommentsState> emit) async {
    final List<Comment> comments = await ApiService().fetchPostComments(
      event.userId,
      event.postId,
      lastCommentMarker,
    );

    if (comments.length < limit) {
      emit(state.copyWith(comments: comments, hasMore: false));
    } else {
      lastCommentMarker = comments[limit - 1].uploadTime;
      emit(state.copyWith(comments: comments, hasMore: true));
    }
  }

  upVoteComment(UpVoteComment event, Emitter<CommentsState> emit) {
    ApiService().updatingCommmentsVote(
      event.comment.id,
      int.parse(event.userId),
      "upvote",
      event.context,
    );
    List<Comment> comments = List.from(state.comments);
    comments = _updateVotes(comments, event.comment.id, isUpvote: true);
    emit(state.copyWith(comments: List.from(comments)));
  }

  downVoteComment(DownVoteComment event, Emitter<CommentsState> emit) {
    ApiService().updatingCommmentsVote(
      event.comment.id,
      int.parse(event.userId),
      "downvote",
      event.context,
    );
    List<Comment> comments = List.from(state.comments);
    comments = _updateVotes(comments, event.comment.id, isUpvote: false);
    emit(state.copyWith(comments: List.from(comments)));
  }

  selectComment(SelectComment event, Emitter<CommentsState> emit) {
    Map<String, dynamic> replyToComment = {"comment": event.parentComment};
    emit(state.copyWith(replyToComment: replyToComment));
  }

  removeSelectComment(RemoveSelectComment event, Emitter<CommentsState> emit) {
    Map<String, dynamic> replyToComment = {"comment": null};
    emit(state.copyWith(replyToComment: replyToComment));
  }

  void uploadComment(UploadComment event, Emitter<CommentsState> emit) async {
    emit(state.copyWith(commentLoading: true));
    final iv = generateRandomIVBytes();
    final encryptedNewComment = encryptText(event.comment, aesKey, iv);

    final Comment comment = await ApiService().uploadComment(
      event.postId,
      event.titleOfThePost,
      encryptedNewComment,
      event.user.userName,
      event.user.avatarId,
      event.user.gender,
      event.user.country,
      state.replyToComment?.id,
      event.clusters,
      DateTime.now(),
      event.user.id,
      iv,
      state.replyToComment?.text,
    );
    List<Comment> comments = List.from(state.comments);

    if (state.replyToComment == null) {
      comments.insert(0, comment);
    } else {
      Comment? updatedRoot = _addReplyToComment(
        comments,
        state.replyToComment!.id,
        comment,
      );

      if (updatedRoot != null) {
        int rootIndex = comments.indexWhere((c) => c.id == updatedRoot.id);
        if (rootIndex != -1) {
          comments[rootIndex] = updatedRoot;
        }
      }
    }

    event.commentController.text = '';
    event.context.read<userBloc.UserBloc>().add(
      userEvent.AddNewComment(comment: comment, postIndex: event.index),
    );

    if (event.category == 'other') {
      event.context.read<OtherUserBloc.OtheruserBloc>().add(
        OtherUserBloc.UpdateCommentCountOfAPost(postIndex: event.index),
      );
    } else if (event.category == 'saved') {
      event.context.read<userBloc.UserBloc>().add(
        userEvent.UpdateCommentCountOfAPost(postIndex: event.index),
      );
    } else if (event.category == 'Trending' ||
        event.category == 'Top 10 news') {
      event.context.read<trendingBloc.TrendingViewBloc>().add(
        trendingBloc.UpdateCommentCountOfAPost(
          postIndex: event.index,
          category: event.category,
          newIndex: event.newsIndex,
        ),
      );
    } else if (event.category == 'ForYou' || event.category == 'Following') {
      event.context.read<HomeBloc.HomeBloc>().add(
        HomeBloc.UpdateCommentCountOfAPost(
          postIndex: event.index,
          category: event.category,
        ),
      );
    } else if (event.category == 'searched') {
      event.context.read<SearchBloc>().add(
        UpdateCommentCountOfAPost(postIndex: event.index),
      );
    } else if (event.category == 'similarPosts') {
      event.context.read<PostBloc>().add(
        UpdateCommentCountOfAPostInSimilarPosts(postIndex: event.index),
      );
    }
    emit(
      state.copyWith(
        comments: comments,
        replyToComment: {"comment": null},
        commentLoading: false,
      ),
    );
  }
}

Comment? _addReplyToComment(
  List<Comment> comments,
  String parentId,
  Comment reply,
) {
  for (Comment comment in comments) {
    if (comment.id == parentId) {
      // Found the parent, clone it with updated replies
      return comment.copyWith(
        allReplies: List.from(comment.allReplies)..add(reply),
      );
    } else {
      Comment? updatedChild = _addReplyToComment(
        comment.allReplies,
        parentId,
        reply,
      );
      if (updatedChild != null) {
        return comment.copyWith(
          allReplies:
              comment.allReplies.map((c) {
                return c.id == updatedChild.id ? updatedChild : c;
              }).toList(),
        );
      }
    }
  }
  return null;
}

List<Comment> _updateVotes(
  List<Comment> comments,
  String commentId, {
  required bool isUpvote,
}) {
  return comments.map((comment) {
    if (comment.id == commentId) {
      bool updatedIsUpVote = comment.isUpvote;
      bool updatedIsDownVote = comment.isDownvote;
      int updatedTotalUpvotes = comment.totalUpvotes;
      int updatedTotalDownvotes = comment.totalDownvotes;

      if (isUpvote) {
        // When user taps upvote
        if (!comment.isUpvote) {
          // User is newly upvoting
          updatedIsUpVote = true;

          // Increase upvotes only if not already upvoted
          updatedTotalUpvotes += 1;

          // If previously downvoted, remove that downvote
          if (comment.isDownvote) {
            updatedIsDownVote = false;
            updatedTotalDownvotes -= 1;
          }
        } else {
          // User removes upvote
          updatedIsUpVote = false;
          updatedTotalUpvotes -= 1;
        }
      } else {
        // When user taps downvote
        if (!comment.isDownvote) {
          // User is newly downvoting
          updatedIsDownVote = true;
          updatedTotalDownvotes += 1;

          // If previously upvoted, remove that upvote
          if (comment.isUpvote) {
            updatedIsUpVote = false;
            updatedTotalUpvotes -= 1;
          }
        } else {
          // User removes downvote
          updatedIsDownVote = false;
          updatedTotalDownvotes -= 1;
        }
      }

      // Clamp totals so they don’t go below zero
      if (updatedTotalUpvotes < 0) updatedTotalUpvotes = 0;
      if (updatedTotalDownvotes < 0) updatedTotalDownvotes = 0;

      return comment.copyWith(
        isUpvote: updatedIsUpVote,
        isDownvote: updatedIsDownVote,
        totalUpvotes: updatedTotalUpvotes,
        totalDownvotes: updatedTotalDownvotes,
      );
    } else {
      // Recursive check for replies
      return comment.copyWith(
        allReplies: _updateVotes(
          comment.allReplies,
          commentId,
          isUpvote: isUpvote,
        ),
      );
    }
  }).toList();
}
