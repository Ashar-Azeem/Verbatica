// ignore_for_file: file_names
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/Votes%20Restriction/votes_restrictor_bloc.dart';
import 'package:verbatica/BLOC/comments_cluster/comment_cluster_bloc.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/model/comment.dart';

class ClusterComments extends StatelessWidget {
  final Comment comment;
  final int level;
  final bool isExpand;
  final VoidCallback toggleFold;
  final int tabBarIndex;
  final int clusterIndex;

  const ClusterComments({
    super.key,
    required this.comment,
    required this.level,
    required this.isExpand,
    required this.toggleFold,
    required this.tabBarIndex,
    required this.clusterIndex,
  });
  @override
  Widget build(BuildContext context) {
    String userId = context.read<UserBloc>().state.user!.id.toString();
    Comment getLeafComment(Comment comment) {
      Comment current = comment;
      while (current.allReplies.isNotEmpty) {
        current = current.allReplies.first; // go to the next reply
      }
      return current;
    }

    Comment clusterComment = getLeafComment(comment);

    return Stack(
      children: [
        if (level > 1)
          isExpand
              ? Positioned(
                left: level * 0.6.w,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 1,
                  color: Theme.of(context).dividerColor.withOpacity(0.5),
                ),
              )
              : comment.allReplies.isEmpty
              ? Positioned(
                left: 2.5.w,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 1,
                  color: Theme.of(context).dividerColor.withOpacity(0.5),
                ),
              )
              : const SizedBox.shrink(),
        isExpand
            ? _buildExpanded(context, userId)
            : _buildCollapsed(context, userId, clusterComment),
      ],
    );
  }

  Widget commentHighlightOverlay({
    required Widget child,
    required bool shouldHighlight,
  }) {
    if (!shouldHighlight) return child;

    return Stack(
      children: [
        child,
        Positioned.fill(
          child: IgnorePointer(
            ignoring: true, // let taps pass through
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: -1.0, end: 2),
              duration: const Duration(milliseconds: 2500),
              builder: (context, value, _) {
                return FractionallySizedBox(
                  alignment: Alignment(value, 0),
                  widthFactor: 40.w, // width of the light beam
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          Colors.blue.withOpacity(0.25),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExpanded(BuildContext context, String userId) {
    return Padding(
      padding: EdgeInsets.only(left: level > 4 ? level * 1.1.w : level * 2.w),
      child: commentHighlightOverlay(
        shouldHighlight: comment.allReplies.isEmpty,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 3.5.w,
                  backgroundImage: AssetImage(
                    'assets/Avatars/avatar${comment.profile}.jpg',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 1.5.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.author,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 3.w,
                        ),
                      ),
                      Text(
                        timeago.format(comment.uploadTime),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 1.5.w,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                if (comment.allReplies.isEmpty)
                  IconButton(
                    onPressed: toggleFold,
                    icon: Icon(Icons.unfold_less, color: primaryColor),
                  ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    size: 5.w,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onSelected: (String value) {
                    if (value == "report") {}
                  },
                  itemBuilder:
                      (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'report',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.report_gmailerrorred,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              Text(
                                'Report',
                                style: TextStyle(
                                  color:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            ExpandableText(
              comment.text,
              expandOnTextTap: true,
              collapseOnTextTap: true,
              expandText: 'show more',
              collapseText: 'show less',
              linkEllipsis: false,
              maxLines: 4,
              style: TextStyle(
                fontSize: 3.8.w,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w300,
              ),
              linkColor: Theme.of(context).colorScheme.primary,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  key: ValueKey(comment.isUpvote),
                  onPressed: () {
                    context.read<VotesRestrictorBloc>().add(
                      RegisterVoteOnComment(commentId: comment.id),
                    );
                    context.read<CommentClusterBloc>().add(
                      UpVoteComment(
                        userId: int.parse(userId),
                        tabIndex: tabBarIndex,
                        commentClusterIndex: clusterIndex,
                        commentId: comment.id,
                        context: context,
                      ),
                    );
                  },
                  padding: EdgeInsets.zero,
                  icon: Icon(
                        Icons.arrow_circle_up_outlined,
                        size: 5.5.w,
                        color:
                            comment.isUpvote
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                      )
                      .animate(
                        onPlay: (controller) {
                          controller.forward(from: 0);
                        },
                      )
                      .scale(duration: 300.ms, curve: Curves.easeOutBack),
                ),
                Text(
                  "${comment.totalUpvotes - comment.totalDownvotes}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 3.w,
                    height: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 1.w),
                IconButton(
                  onPressed: () {
                    context.read<VotesRestrictorBloc>().add(
                      RegisterVoteOnComment(commentId: comment.id),
                    );
                    context.read<CommentClusterBloc>().add(
                      DownVoteComment(
                        userId: int.parse(userId),
                        tabIndex: tabBarIndex,
                        commentClusterIndex: clusterIndex,
                        commentId: comment.id,
                        context: context,
                      ),
                    );
                  },
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.arrow_circle_down_outlined,
                    size: 5.5.w,
                    color:
                        comment.isDownvote
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            if (comment.allReplies.isNotEmpty)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comment.allReplies.length,
                itemBuilder: (context, index) {
                  final reply = comment.allReplies[index];
                  return ClusterComments(
                    key: ValueKey(reply.id),
                    tabBarIndex: tabBarIndex,
                    clusterIndex: clusterIndex,
                    level: level + 1,
                    comment: reply,
                    isExpand: isExpand,
                    toggleFold: toggleFold,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollapsed(
    BuildContext context,
    String userId,
    Comment clusterComment,
  ) {
    return Padding(
      padding: EdgeInsets.only(left: 2.w),

      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 3.5.w,
                  backgroundImage: AssetImage(
                    'assets/Avatars/avatar${clusterComment.profile}.jpg',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 1.5.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clusterComment.author,
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                          fontSize: 3.w,
                        ),
                      ),
                      Text(
                        timeago.format(clusterComment.uploadTime),
                        style: TextStyle(
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          fontSize: 1.5.w,
                        ),
                      ),
                    ],
                  ),
                ),

                const Spacer(),
                if (comment.allReplies.isNotEmpty)
                  IconButton(
                    onPressed: toggleFold,
                    icon: Icon(Icons.unfold_more, color: primaryColor),
                  ),
                PopupMenuButton<String>(
                  icon: Icon(
                    Icons.more_vert,
                    size: 5.w,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  onSelected: (String value) {
                    if (value == "report") {}
                  },
                  itemBuilder:
                      (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'report',
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(
                                Icons.report_gmailerrorred,
                                color: Theme.of(context).iconTheme.color,
                              ),
                              Text(
                                'Report',
                                style: TextStyle(
                                  color:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                ),
              ],
            ),
            SizedBox(height: 0.5.h),
            ExpandableText(
              clusterComment.text,
              expandOnTextTap: true,
              collapseOnTextTap: true,
              expandText: 'show more',
              collapseText: 'show less',
              linkEllipsis: false,
              maxLines: 4,
              style: TextStyle(
                fontSize: 3.8.w,
                color: Theme.of(context).textTheme.bodyMedium?.color,
                fontWeight: FontWeight.w300,
              ),
              linkColor: Theme.of(context).colorScheme.primary,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Spacer(),
                IconButton(
                  key: ValueKey(comment.isUpvote),
                  onPressed: () {
                    context.read<VotesRestrictorBloc>().add(
                      RegisterVoteOnComment(commentId: comment.id),
                    );
                    context.read<CommentClusterBloc>().add(
                      UpVoteComment(
                        userId: int.parse(userId),
                        tabIndex: tabBarIndex,
                        commentClusterIndex: clusterIndex,
                        commentId: clusterComment.id,
                        context: context,
                      ),
                    );
                  },
                  padding: EdgeInsets.zero,
                  icon: Icon(
                        Icons.arrow_circle_up_outlined,
                        size: 5.5.w,
                        color:
                            clusterComment.isUpvote
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.secondary,
                      )
                      .animate(
                        onPlay: (controller) {
                          controller.forward(from: 0);
                        },
                      )
                      .scale(duration: 300.ms, curve: Curves.easeOutBack),
                ),
                Text(
                  "${clusterComment.totalUpvotes - clusterComment.totalDownvotes}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 3.w,
                    height: 1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 1.w),
                IconButton(
                  onPressed: () {
                    context.read<VotesRestrictorBloc>().add(
                      RegisterVoteOnComment(commentId: comment.id),
                    );
                    context.read<CommentClusterBloc>().add(
                      DownVoteComment(
                        userId: int.parse(userId),
                        tabIndex: tabBarIndex,
                        commentClusterIndex: clusterIndex,
                        commentId: clusterComment.id,
                        context: context,
                      ),
                    );
                  },
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.arrow_circle_down_outlined,
                    size: 5.5.w,
                    color:
                        clusterComment.isDownvote
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
