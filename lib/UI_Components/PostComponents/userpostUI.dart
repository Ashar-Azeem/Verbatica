import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_event.dart';
import 'package:verbatica/BLOC/User%20bloc/user_state.dart';
import 'package:verbatica/UI_Components/PostComponents/VideoPlayer.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Home%20View%20Screens/SummaryView.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Home%20View%20Screens/ViewDiscussion.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/ProfileView/ProfileView.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/ProfileView/otherprofile.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Analysis%20Views/clusterScreen.dart';
import 'package:verbatica/model/Post.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserPostWidget extends StatelessWidget {
  final Post post;
  final int index;
  final String category;
  final bool onFullView;

  const UserPostWidget({
    required this.post,
    super.key,
    required this.index,
    required this.category,
    required this.onFullView,
  });

  void _showDeleteConfirmation(BuildContext context, Post post) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Delete Post',
            style: TextStyle(
              color: Theme.of(context).textTheme.titleLarge?.color,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this post?',
            style: TextStyle(
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // Dispatch delete post event
                context.read<UserBloc>().add(DeleteUserPost(postId: post.id));
                Navigator.of(context).pop();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isUserPost = category == 'user';

    return Center(
      child: SizedBox(
        width: 100.w,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 1.w, bottom: 1.w, left: 1.w),
              child: SizedBox(
                height: 5.5.h,
                child: Padding(
                  padding: EdgeInsets.only(left: 1.w, top: 1.w),
                  child: GestureDetector(
                    onTap: () {
                      pushScreen(
                        context,
                        pageTransitionAnimation: PageTransitionAnimation.scale,
                        screen:
                            isUserPost
                                ? ProfileView() // Navigate to user's own profile
                                : otherProfileView(
                                  post: post,
                                ), // Navigate to other user's profile
                        withNavBar: false,
                      );
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(
                            'assets/Avatars/avatar${post.avatar}.jpg',
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 1.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                post.name,
                                style: TextStyle(
                                  color:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyLarge?.color,
                                ),
                              ),
                              Text(
                                timeago.format(post.uploadTime),
                                style: TextStyle(
                                  color:
                                      Theme.of(
                                        context,
                                      ).textTheme.bodyMedium?.color,
                                  fontSize: 2.w,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(flex: 1),
                        TextButton(
                          onPressed: () {
                            if (post.isDebate) {
                              pushScreen(
                                context,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.scale,
                                screen: SummaryScreen(
                                  showClusters: true,
                                  clusters: post.clusters,
                                  postId: post.id,
                                ),
                                withNavBar: false,
                              );
                            } else {
                              pushScreen(
                                context,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.scale,
                                screen: SummaryScreen(
                                  showClusters: false,
                                  postId: post.id,
                                ),
                                withNavBar: false,
                              );
                            }
                          },
                          style: TextButton.styleFrom(
                            shape: StadiumBorder(),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            foregroundColor:
                                Theme.of(context).colorScheme.onPrimary,
                          ),
                          child: Text(
                            'Summary',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 2.8.w,
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            color: Theme.of(context).iconTheme.color,
                          ),
                          onSelected: (String value) {
                            if (isUserPost) {
                              // User's own posts - edit/delete/share options
                              if (value == "edit") {
                                // context.read<UserBloc>().add(
                                //   EditUserPost(postId: post.id),
                                // );
                              } else if (value == "delete") {
                                context.read<UserBloc>().add(
                                  DeleteUserPost(postId: post.id),
                                );
                              } else if (value == "share") {
                                // context.read<UserBloc>().add(
                                //   ShareUserPost(post: post),
                                // );
                              }
                            } else {
                              // Saved posts - report/save/share options
                              if (value == "report") {
                                // context.read<UserBloc>().add(
                                //   ReportPost(postId: post.id),
                                // );
                              } else if (value == "unsave") {
                                context.read<UserBloc>().add(
                                  UnsavePost1(post: post),
                                );
                              } else if (value == "share") {
                                // context.read<UserBloc>().add(
                                //   SharePost(post: post),
                                // );
                              }
                            }
                          },
                          itemBuilder:
                              (BuildContext context) =>
                                  isUserPost
                                      ? <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                          value: 'edit',
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                Icons.edit,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).iconTheme.color,
                                              ),
                                              Text(
                                                'Edit',
                                                style: TextStyle(
                                                  color:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.color,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'delete',
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).iconTheme.color,
                                              ),
                                              Text(
                                                'Delete',
                                                style: TextStyle(
                                                  color:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.color,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'share',
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                Icons.share,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).iconTheme.color,
                                              ),
                                              Text(
                                                'Share',
                                                style: TextStyle(
                                                  color:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.color,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]
                                      : <PopupMenuEntry<String>>[
                                        PopupMenuItem<String>(
                                          value: 'report',
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                Icons.report_gmailerrorred,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).iconTheme.color,
                                              ),
                                              Text(
                                                'Report',
                                                style: TextStyle(
                                                  color:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.color,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'unsave',
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                Icons.bookmark_remove,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).iconTheme.color,
                                              ),
                                              Text(
                                                'Unsave',
                                                style: TextStyle(
                                                  color:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.color,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        PopupMenuItem<String>(
                                          value: 'share',
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Icon(
                                                Icons.share,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).iconTheme.color,
                                              ),
                                              Text(
                                                'Share',
                                                style: TextStyle(
                                                  color:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium
                                                          ?.color,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            //Content, title, image or video
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Title
                Padding(
                  padding: EdgeInsets.only(left: 1.w),
                  child: Text(
                    post.title,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.titleLarge?.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 0.2.h),

                Padding(
                  padding: EdgeInsets.only(left: 1.w),
                  child: ExpandableText(
                    post.description,
                    expandOnTextTap: true,
                    collapseOnTextTap: true,
                    expandText: 'show more',
                    collapseText: 'show less',
                    linkEllipsis: false,
                    maxLines: 2,
                    style: TextStyle(
                      fontSize: 15,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    linkColor: Theme.of(context).colorScheme.primary,
                  ),
                ),

                SizedBox(height: 0.5.h),

                if (post.postImageLink != null)
                  CachedNetworkImage(
                    imageUrl: post.postImageLink!,
                    placeholder:
                        (context, url) => Shimmer.fromColors(
                          baseColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? const Color.fromARGB(255, 58, 76, 90)
                                  : Colors.grey[300]!,
                          highlightColor:
                              Theme.of(context).brightness == Brightness.dark
                                  ? const Color.fromARGB(255, 81, 106, 125)
                                  : Colors.grey[100]!,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              color: Theme.of(context).cardColor,
                            ),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            color:
                                Theme.of(
                                  context,
                                ).colorScheme.surfaceContainerHighest,
                            child: Icon(
                              Icons.error,
                              color: Theme.of(context).iconTheme.color,
                            ),
                          ),
                        ),
                    fit: BoxFit.contain,
                  ),

                /// Video placeholder (show only if video link is not null)
                if (post.postVideoLink != null)
                  VideoPlayer(videoUrl: post.postVideoLink!),
              ],
            ),

            //End of content, title, image or video

            //Bottom side of the post
            Padding(
              padding: EdgeInsets.only(right: 1.w),
              child: InkWell(
                onTap: () {
                  if (!onFullView) {
                    pushScreen(
                      context,
                      pageTransitionAnimation: PageTransitionAnimation.scale,
                      screen: MultiBlocProvider(
                        providers: [
                          BlocProvider<UserBloc>.value(
                            value: context.read<UserBloc>(),
                          ),
                        ],
                        child: ViewDiscussion(
                          post: post,
                          index: index,
                          category: category,
                        ),
                      ),
                      withNavBar: false,
                    );
                  }
                },
                child: SizedBox(
                  height: 6.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 1.w),
                      Container(
                        height: 5.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Theme.of(context).dividerColor,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 0.5.w,
                          // vertical: 0.5.w,
                        ),
                        child: BlocBuilder<UserBloc, UserState>(
                          builder: (context, state) {
                            Post dynamicpost;
                            if (category == 'user') {
                              if (state.userPosts.isNotEmpty) {
                                dynamicpost = state.userPosts.firstWhere(
                                  (p) => p.id == post.id,
                                  orElse: () => post,
                                );
                              } else {
                                dynamicpost = post;
                              }
                            } else if (category == 'saved') {
                              // For saved posts, get from saved posts list
                              dynamicpost = state.savedPosts[index];
                            } else {
                              dynamicpost = post;
                            }
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    if (category == 'user') {
                                      context.read<UserBloc>().add(
                                        upvotePost1(index: index),
                                      );
                                    } else {
                                      // For saved posts, use different event
                                      context.read<UserBloc>().add(
                                        upvotesavedPost1(index: index),
                                      );
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      IconButton(
                                        onPressed: null,
                                        padding: EdgeInsets.zero,
                                        icon: Icon(
                                          Icons.arrow_circle_up_outlined,
                                          size: 7.w,
                                          color:
                                              dynamicpost.isUpVote
                                                  ? Theme.of(
                                                    context,
                                                  ).colorScheme.primary
                                                  : Theme.of(
                                                    context,
                                                  ).colorScheme.secondary,
                                        ),
                                      ),
                                      Text(
                                        "${dynamicpost.upvotes - dynamicpost.downvotes}",
                                        style: TextStyle(
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                          fontSize: 3.w,
                                          height: 1,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 6.h,
                                  color: Theme.of(context).dividerColor,
                                ),
                                IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onPressed: () {
                                    if (category == 'user') {
                                      context.read<UserBloc>().add(
                                        downvotePost1(index: index),
                                      );
                                    } else {
                                      // For saved posts, use different event
                                      context.read<UserBloc>().add(
                                        downvotesavedPost(index: index),
                                      );
                                    }
                                  },
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    size: 7.w,
                                    Icons.arrow_circle_down_outlined,
                                    color:
                                        dynamicpost.isDownVote
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.primary
                                            : Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      Spacer(flex: 1),
                      !onFullView
                          ? Container(
                            height: 5.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 0.5.w,
                              vertical: 0.5.w,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                IconButton(
                                  onPressed: () {
                                    pushScreen(
                                      context,
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.scale,
                                      screen: MultiBlocProvider(
                                        providers: [
                                          BlocProvider<UserBloc>.value(
                                            value: context.read<UserBloc>(),
                                          ),
                                        ],
                                        child: ViewDiscussion(
                                          post: post,
                                          index: index,
                                          category: category,
                                        ),
                                      ),
                                      withNavBar: false,
                                    );
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    Icons.mode_comment_outlined,
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                Text(
                                  "${post.comments}",
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 3.w,
                                    height: 1,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                              ],
                            ),
                          )
                          : SizedBox.shrink(),

                      // Sentiment Analysis Button or spacing
                      post.isDebate
                          ? IconButton(
                            onPressed: () {
                              pushScreen(
                                context,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.scale,
                                screen: Clusterscreen(
                                  clusters: post.clusters!,
                                  postid: post.id,
                                ),
                                withNavBar: false,
                              );
                            },
                            icon: Icon(
                              Icons.analytics_outlined,
                              size: 7.w,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          )
                          : SizedBox(height: 6.h, width: 15.w),

                      // Delete button only for user's own posts
                      if (isUserPost) ...[
                        Spacer(),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          onPressed: () {
                            _showDeleteConfirmation(context, post);
                          },
                          tooltip: 'Delete post',
                        ),
                        Spacer(flex: 2),
                      ] else
                        const Spacer(flex: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
