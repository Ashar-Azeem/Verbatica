import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';
import 'package:verbatica/DummyData/comments.dart';
import 'package:verbatica/model/comment.dart';
import 'package:verbatica/model/user.dart';

part 'comments_event.dart';
part 'comments_state.dart';

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  CommentsBloc({required String postId}) : super(CommentsState()) {
    on<LoadInitialComments>(loadInitialComments);
    on<LoadMoreComments>(loadMoreComments);
    on<UpVoteComment>(upVoteComment);
    on<DownVoteComment>(downVoteComment);
    on<SelectComment>(selectComment);
    on<UploadComment>(uploadComment);
    on<RemoveSelectComment>(removeSelectComment);
    add(LoadInitialComments(postId: postId));
  }

  loadInitialComments(
    LoadInitialComments event,
    Emitter<CommentsState> emit,
  ) async {
    await Future.delayed(Duration(seconds: 1));
    emit(state.copyWith(initialLoader: false, comments: dummyComments));
  }

  loadMoreComments(LoadMoreComments event, Emitter<CommentsState> emit) {}

  upVoteComment(UpVoteComment event, Emitter<CommentsState> emit) {
    List<Comment> comments = List.from(state.comments);
    comments = _updateVotes(
      comments,
      event.comment.id,
      event.userId,
      isUpvote: true,
    );
    emit(state.copyWith(comments: List.from(comments)));
  }

  downVoteComment(DownVoteComment event, Emitter<CommentsState> emit) {
    List<Comment> comments = List.from(state.comments);
    comments = _updateVotes(
      comments,
      event.comment.id,
      event.userId,
      isUpvote: false,
    );
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

    await Future.delayed(Duration(seconds: 2));

    List<Comment> comments = List.from(state.comments);

    Comment newComment = Comment(
      id: Uuid().v4(),
      postId: event.postId,
      text: event.comment,
      author: event.user.username,
      profile: event.user.avatarId.toString(),
      uploadTime: DateTime.now(),
      upVoteUserIds: [],
      downVoteUserIds: [],
      allReplies: [],
      parentId: state.replyToComment?.id, // optional
    );

    if (state.replyToComment == null) {
      comments.add(newComment);
    } else {
      Comment? updatedRoot = _addReplyToComment(
        comments,
        state.replyToComment!.id,
        newComment,
      );

      if (updatedRoot != null) {
        // Replace the modified root in the top-level list
        int rootIndex = comments.indexWhere((c) => c.id == updatedRoot.id);
        if (rootIndex != -1) {
          comments[rootIndex] = updatedRoot;
        }
      }
    }

    event.commentController.text = '';

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
  String commentId,
  String userId, {
  required bool isUpvote,
}) {
  return comments.map((comment) {
    if (comment.id == commentId) {
      final updatedUpvotes = List<String>.from(comment.upVoteUserIds);
      final updatedDownvotes = List<String>.from(comment.downVoteUserIds);

      if (isUpvote) {
        if (!updatedUpvotes.contains(userId)) {
          if (updatedDownvotes.contains(userId)) {
            updatedDownvotes.remove(userId);
            updatedUpvotes.add(userId);
          } else {
            updatedUpvotes.add(userId);
          }
        }
      } else {
        if (!updatedDownvotes.contains(userId)) {
          if (updatedUpvotes.contains(userId)) {
            updatedUpvotes.remove(userId);
            updatedDownvotes.add(userId);
          } else {
            updatedDownvotes.add(userId);
          }
        }
      }

      return comment.copyWith(
        upVoteUserIds: updatedUpvotes,
        downVoteUserIds: updatedDownvotes,
      );
    } else {
      return comment.copyWith(
        allReplies: _updateVotes(
          comment.allReplies,
          commentId,
          userId,
          isUpvote: isUpvote,
        ),
      );
    }
  }).toList();
}
