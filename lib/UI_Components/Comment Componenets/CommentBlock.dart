// ignore_for_file: file_names
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:verbatica/BLOC/Comments%20Bloc/comments_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/Votes%20Restriction/votes_restrictor_bloc.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/ProfileView/settingviews/Report/reportscreen.dart';
import 'package:verbatica/model/comment.dart';

class CommentsBlock extends StatelessWidget {
  final Comment comment;
  final int level;
  const CommentsBlock({super.key, required this.level, required this.comment});

  void onreply(BuildContext context) {
    context.read<CommentsBloc>().add(SelectComment(parentComment: comment));
  }

  @override
  Widget build(BuildContext context) {
    String userId = context.read<UserBloc>().state.user!.id.toString();

    return Stack(
      children: [
        if (level > 1)
          Positioned(
            left: level * 0.6.w,
            top: 0,
            bottom: 0,
            child: Container(
              width: 1,
              color: Theme.of(context).dividerColor.withOpacity(0.5),
            ),
          ),

        Padding(
          padding: EdgeInsets.only(
            left: level > 4 ? level * 1.1.w : level * 2.w,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
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
                                  color:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.color,
                                  fontSize: 3.w,
                                ),
                              ),
                              Text(
                                timeago.format(comment.uploadTime),
                                style: TextStyle(
                                  color:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodySmall?.color,
                                  fontSize: 1.5.w,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            size: 5.w,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onSelected: (String value) {
                            if (value == "report") {
                              pushScreen(
                                context,
                                screen: ReportScreen(
                                  reportType: 'comment',
                                  commentId: comment.id,
                                ),
                              );
                            }
                          },
                          itemBuilder:
                              (
                                BuildContext context,
                              ) => <PopupMenuEntry<String>>[
                                PopupMenuItem<String>(
                                  value: 'report',
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.report_gmailerrorred,
                                        color:
                                            Theme.of(context).iconTheme.color,
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
                            context.read<CommentsBloc>().add(
                              UpVoteComment(
                                comment: comment,
                                userId: userId,
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
                                        : Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                              )
                              .animate(
                                onPlay: (controller) {
                                  controller.forward(from: 0);
                                },
                              )
                              .scale(
                                duration: 300.ms,
                                curve: Curves.easeOutBack,
                              ),
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
                            context.read<CommentsBloc>().add(
                              DownVoteComment(
                                comment: comment,
                                userId: userId,
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
                        level > 7
                            ? const SizedBox.shrink()
                            : level == 1
                            ? TextButton.icon(
                              onPressed: () {
                                onreply(context);
                              },
                              label: Text(
                                "Reply",
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  fontSize: 3.5.w,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              icon: Icon(
                                Icons.reply,
                                size: 5.5.w,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            )
                            : IconButton(
                              onPressed: () {
                                onreply(context);
                              },
                              icon: Icon(
                                Icons.reply,
                                size: 5.5.w,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                      ],
                    ),
                    if (comment.allReplies.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 0.3.h),
                        child: Column(
                          children:
                              comment.allReplies
                                  .map(
                                    (reply) => CommentsBlock(
                                      level: level + 1,
                                      comment: reply,
                                    ),
                                  )
                                  .toList(),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
