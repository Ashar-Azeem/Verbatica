import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:verbatica/BLOC/Comments%20Bloc/comments_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_state.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/model/comment.dart';

class CommentsBlock extends StatelessWidget {
  final Comment comment;
  final int level;
  const CommentsBlock({super.key, required this.level, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: level * 2.w),

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
                      children: [
                        Text(
                          comment.author,
                          style: TextStyle(color: Colors.white, fontSize: 3.w),
                        ),
                        Text(
                          timeago.format(comment.uploadTime),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 1.5.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Spacer(),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, size: 5.w),
                    onSelected: (String value) {
                      if (value == "report") {
                        context.read<CommentsBloc>().add(
                          ReportComment(comment: comment),
                        );
                      }
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

                                  color: Colors.white,
                                ),

                                Text('Report'),
                              ],
                            ),
                          ),
                        ],
                  ),
                ],
              ),
              SizedBox(width: 1.w),
              ExpandableText(
                comment.text,
                expandOnTextTap: true,
                collapseOnTextTap: true,
                expandText: 'show more',
                collapseText: 'show less',
                linkEllipsis: false,
                maxLines: 2,
                style: TextStyle(
                  fontSize: 3.8.w,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),

                linkColor: primaryColor,
              ),

              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton.icon(
                        onPressed: () {},
                        label: Text(
                          "Reply",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 3.5.w,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        icon: Icon(
                          Icons.reply,
                          size: 5.5.w,
                          color: primaryColor,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          Icons.arrow_circle_up_outlined,
                          size: 5.5.w,
                          color:
                              state.user.upVotedPosts.contains(comment.id)
                                  ? primaryColor
                                  : Colors.white,
                        ),
                      ),

                      Text(
                        "${comment.upVotes - comment.downVotes}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 3.w,
                          height: 1,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(width: 1.w),

                      IconButton(
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        icon: Icon(
                          size: 5.5.w,

                          Icons.arrow_circle_down_outlined,
                          color:
                              state.user.downVotedPosts.contains(comment.id)
                                  ? primaryColor
                                  : Colors.white,
                        ),
                      ),
                    ],
                  );
                },
              ),

              if (comment.allReplies.isNotEmpty)
                Padding(
                  padding: EdgeInsets.only(top: 0.5.h),
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
    );
  }
}
