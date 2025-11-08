import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/model/comment.dart';
part 'comment_cluster_event.dart';
part 'comment_cluster_state.dart';

class CommentClusterBloc
    extends Bloc<CommentClusterEvent, CommentClusterState> {
  final int totalCluster;
  final List<String> clusterNames;
  final int userId;
  final String postId;
  CommentClusterBloc({
    required this.totalCluster,
    required this.clusterNames,
    required this.userId,
    required this.postId,
  }) : super(CommentClusterState()) {
    on<LoadInitialComments>(loadInitialComments);
    on<ToggleExpandOrCollapse>(toggleExpandOrCollapse);
    on<LoadOtherTabs>(loadOtherTabs);
    on<UpVoteComment>(upVoteComment);
    on<DownVoteComment>(downVoteComment);
    add(LoadInitialComments());
  }
  Future<void> loadInitialComments(
    LoadInitialComments event,
    Emitter<CommentClusterState> emit,
  ) async {
    final initialTabs = List.generate(
      totalCluster,
      (_) => CommentSectionOfEachTab(comments: const [], isLoading: true),
    );

    emit(state.copyWith(comments: initialTabs));
    final List<Comment> comments = await ApiService().fetchClusterComments(
      userId,
      postId,
      clusterNames[0],
    );
    final updatedTabs = List<CommentSectionOfEachTab>.from(state.comments);

    updatedTabs[0] = CommentSectionOfEachTab(
      comments:
          comments
              .map(
                (comment) =>
                    ExpandableComments(comment: comment, isExpand: false),
              )
              .toList(),
      isLoading: false,
    );

    emit(state.copyWith(comments: updatedTabs));
  }

  Future<void> loadOtherTabs(
    LoadOtherTabs event,
    Emitter<CommentClusterState> emit,
  ) async {
    final tabs = List<CommentSectionOfEachTab>.from(state.comments);
    if (tabs[event.tabIndex].comments.isEmpty) {
      final List<Comment> comments = await ApiService().fetchClusterComments(
        userId,
        postId,
        clusterNames[event.tabIndex],
      );
      tabs[event.tabIndex] = CommentSectionOfEachTab(
        comments:
            comments
                .map(
                  (comment) =>
                      ExpandableComments(comment: comment, isExpand: false),
                )
                .toList(),
        isLoading: false,
      );

      emit(state.copyWith(comments: tabs));
    }
  }

  Future<void> upVoteComment(
    UpVoteComment event,
    Emitter<CommentClusterState> emit,
  ) async {
    ApiService().updatingCommmentsVote(
      event.commentId,
      event.userId,
      "upvote",
      event.context,
    );
    List<CommentSectionOfEachTab> tabs = List.from(state.comments);
    List<ExpandableComments> tabComments = List.from(
      tabs[event.tabIndex].comments,
    );
    Comment comment = tabComments[event.commentClusterIndex].comment;
    comment = _updateVotes(comment, event.commentId, isUpvote: true);

    tabComments[event.commentClusterIndex] =
        tabComments[event.commentClusterIndex].copyWith(comment: comment);
    tabs[event.tabIndex] = tabs[event.tabIndex].copyWith(comments: tabComments);
    emit(state.copyWith(comments: tabs));
  }

  Future<void> downVoteComment(
    DownVoteComment event,
    Emitter<CommentClusterState> emit,
  ) async {
    ApiService().updatingCommmentsVote(
      event.commentId,
      event.userId,
      "downvote",
      event.context,
    );
    List<CommentSectionOfEachTab> tabs = List.from(state.comments);
    List<ExpandableComments> tabComments = List.from(
      tabs[event.tabIndex].comments,
    );
    Comment comment = tabComments[event.commentClusterIndex].comment;
    comment = _updateVotes(comment, event.commentId, isUpvote: false);

    tabComments[event.commentClusterIndex] =
        tabComments[event.commentClusterIndex].copyWith(comment: comment);
    tabs[event.tabIndex] = tabs[event.tabIndex].copyWith(comments: tabComments);
    emit(state.copyWith(comments: tabs));
  }

  toggleExpandOrCollapse(
    ToggleExpandOrCollapse event,
    Emitter<CommentClusterState> emit,
  ) {
    List<CommentSectionOfEachTab> commentsTab = List.from(state.comments);
    List<ExpandableComments> commentsOfOneTab = List.from(
      commentsTab[event.tabIndex].comments,
    );

    bool newValue =
        commentsOfOneTab[event.listIndex].comment.allReplies.isNotEmpty
            ? !commentsOfOneTab[event.listIndex].isExpand
            : false;

    commentsOfOneTab[event.listIndex] = commentsOfOneTab[event.listIndex]
        .copyWith(isExpand: newValue);

    commentsTab[event.tabIndex] = commentsTab[event.tabIndex].copyWith(
      comments: commentsOfOneTab,
    );

    emit(state.copyWith(comments: commentsTab));
  }
}

Comment _updateVotes(
  Comment comment,
  String commentId, {
  required bool isUpvote,
}) {
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
      allReplies: [
        _updateVotes(comment.allReplies[0], commentId, isUpvote: isUpvote),
      ],
    );
  }
}
