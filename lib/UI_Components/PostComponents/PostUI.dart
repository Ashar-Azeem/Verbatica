// ignore_for_file: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Home/home_bloc.dart' as homeBloc;
import 'package:verbatica/BLOC/Search%20Bloc/search_bloc.dart' as searchBloc;
import 'package:verbatica/BLOC/Trending%20View%20BLOC/trending_view_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_event.dart';
import 'package:verbatica/BLOC/Votes%20Restriction/votes_restrictor_bloc.dart';
import 'package:verbatica/BLOC/otheruser/otheruser_bloc.dart';
import 'package:verbatica/UI_Components/PostComponents/VideoPlayer.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Home%20View%20Screens/SummaryView.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Home%20View%20Screens/ViewDiscussion.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/ProfileView/otherprofile.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Analysis%20Views/clusterScreen.dart';
import 'package:verbatica/model/Post.dart';
import 'package:timeago/timeago.dart' as timeago;

// ignore: must_be_immutable
class PostWidget extends StatelessWidget {
  final Post post;
  final int index;
  final int? newsIndex;
  final String category;
  final bool onFullView;

  const PostWidget({
    required this.post,
    super.key,
    required this.index,
    required this.category,
    required this.onFullView,
    this.newsIndex,
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return Center(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 5.5.h,
              child: Padding(
                padding: EdgeInsets.only(left: 1.w, top: 1.w),
                child: GestureDetector(
                  onTap: () {
                    pushScreen(
                      context,
                      pageTransitionAnimation: PageTransitionAnimation.scale,
                      screen: otherProfileView(post: post),
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
                                color: textTheme.bodyLarge?.color,
                              ),
                            ),
                            Text(
                              timeago.format(post.uploadTime),
                              style: TextStyle(
                                color: textTheme.bodyMedium?.color?.withOpacity(
                                  0.7,
                                ),
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
                                postId: '',
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
                                postId: '',
                              ),
                              withNavBar: false,
                            );
                          }
                        },
                        style: TextButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                        child: Text(
                          'Summary',
                          style: TextStyle(
                            color: colorScheme.onPrimary,
                            fontSize: 2.8.w,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(
                          Icons.more_vert,
                          color: textTheme.bodyLarge?.color,
                        ),
                        color: colorScheme.surface,
                        onSelected: (String value) {
                          if (value == "report") {
                            if (category == 'ForYou' ||
                                category == 'Following') {
                              context.read<homeBloc.HomeBloc>().add(
                                homeBloc.ReportPost(
                                  index: index,
                                  category: category,
                                  postId: post.id,
                                ),
                              );
                            } else if (category == 'Trending' ||
                                category == 'Top 10 news') {
                              context.read<TrendingViewBloc>().add(
                                ReportPost(
                                  index: index,
                                  category: category,
                                  postId: post.id,
                                ),
                              );
                            } else if (category == 'other') {
                            } else if (category == 'searched') {}
                          } else if (value == "save") {
                            context.read<UserBloc>().add(SavePost1(post: post));
                          } else if (value == "share") {
                          } else if (value == 'delete') {
                            _showDeleteConfirmation(context, post);
                          } else if (value == 'unSave') {
                            context.read<UserBloc>().add(
                              UnsavePost1(post: post),
                            );
                          }
                        },
                        itemBuilder:
                            (BuildContext context) => <PopupMenuEntry<String>>[
                              category != 'user'
                                  ? PopupMenuItem<String>(
                                    value: 'report',
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.report_gmailerrorred,
                                          color: textTheme.bodyLarge?.color,
                                        ),
                                        Text(
                                          'Report',
                                          style: TextStyle(
                                            color: textTheme.bodyLarge?.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  : PopupMenuItem<String>(
                                    value: 'delete',
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.delete,
                                          color: textTheme.bodyLarge?.color,
                                        ),
                                        Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: textTheme.bodyLarge?.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              category != 'saved'
                                  ? PopupMenuItem<String>(
                                    value: 'save',
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.save,
                                          color: textTheme.bodyLarge?.color,
                                        ),
                                        Text(
                                          'Save',
                                          style: TextStyle(
                                            color: textTheme.bodyLarge?.color,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  : PopupMenuItem<String>(
                                    value: 'unSave',
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(
                                          Icons.remove_circle_outline,
                                          color: textTheme.bodyLarge?.color,
                                        ),
                                        Text(
                                          'UnSave',
                                          style: TextStyle(
                                            color: textTheme.bodyLarge?.color,
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
                                      color: textTheme.bodyLarge?.color,
                                    ),
                                    Text(
                                      'Share',
                                      style: TextStyle(
                                        color: textTheme.bodyLarge?.color,
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
            SizedBox(height: 2.w),
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
                      color: textTheme.headlineSmall?.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 0.5.h),

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
                      color: textTheme.bodyLarge?.color,
                    ),
                    linkColor: colorScheme.primary,
                  ),
                ),

                SizedBox(height: 0.8.h),

                if (post.postImageLink != null)
                  CachedNetworkImage(
                    imageUrl: post.postImageLink!,
                    placeholder:
                        (context, url) => Shimmer.fromColors(
                          baseColor: colorScheme.surfaceContainerHighest,
                          highlightColor: colorScheme.surfaceContainerHighest
                              .withOpacity(0.8),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(color: colorScheme.surface),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            color: colorScheme.errorContainer,
                            child: Icon(
                              Icons.error,
                              color: colorScheme.onErrorContainer,
                            ),
                          ),
                        ),
                    fit: BoxFit.contain,
                  ),

                /// Video placeholder (show only if video link is not null)
                if (post.postVideoLink != null)
                  BetterCacheVideoPlayer(videoUrl: post.postVideoLink!),
              ],
            ),

            //End of content, title, image or video

            //Bottom side of the post
            Center(
              child: Padding(
                padding: EdgeInsets.only(right: 1.w),
                child: InkWell(
                  onTap: () {
                    if (!onFullView) {
                      pushScreen(
                        context,
                        pageTransitionAnimation: PageTransitionAnimation.scale,
                        screen: ViewDiscussion(
                          post: post,
                          index: index,
                          newIndex: newsIndex,
                          category: category,
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
                            border: Border.all(color: theme.dividerColor),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 0.5.w,
                            vertical: 0.5.w,
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                key: ValueKey(post.isUpVote),
                                onTap: () {
                                  context.read<VotesRestrictorBloc>().add(
                                    RegisterVote(postId: post.id),
                                  );
                                  if (category == 'ForYou' ||
                                      category == 'Following') {
                                    context.read<homeBloc.HomeBloc>().add(
                                      homeBloc.UpVotePost(
                                        index: index,
                                        category: category,
                                      ),
                                    );
                                  } else if (category == 'Trending' ||
                                      category == 'Top 10 news') {
                                    if (newsIndex != null) {
                                      context.read<TrendingViewBloc>().add(
                                        UpVoteNewsPost(
                                          index: index,
                                          category: category,
                                          newsIndex: newsIndex!,
                                        ),
                                      );
                                    } else {
                                      context.read<TrendingViewBloc>().add(
                                        UpVotePost(
                                          index: index,
                                          category: category,
                                        ),
                                      );
                                    }
                                  } else if (category == 'user') {
                                    context.read<UserBloc>().add(
                                      upvotePost1(
                                        index: index,
                                        context: context,
                                      ),
                                    );
                                  } else if (category == 'other') {
                                    context.read<OtheruserBloc>().add(
                                      upvotePost(
                                        index: index,
                                        context: context,
                                      ),
                                    );
                                  } else if (category == 'saved') {
                                    context.read<UserBloc>().add(
                                      upvotesavedPost1(index: index),
                                    );
                                  } else {
                                    context.read<searchBloc.SearchBloc>().add(
                                      searchBloc.UpVotePost(index: index),
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
                                                post.isUpVote
                                                    ? colorScheme.primary
                                                    : colorScheme.secondary,
                                          ),
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
                                    Text(
                                      "${post.upvotes - post.downvotes}",
                                      style: TextStyle(
                                        color: theme.colorScheme.secondary,
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
                                height: 5.h,
                                color: theme.dividerColor,
                              ),

                              IconButton(
                                splashColor: Colors.transparent,
                                highlightColor: Colors.transparent,

                                onPressed: () {
                                  context.read<VotesRestrictorBloc>().add(
                                    RegisterVote(postId: post.id),
                                  );
                                  if (category == 'ForYou' ||
                                      category == 'Following') {
                                    context.read<homeBloc.HomeBloc>().add(
                                      homeBloc.DownVotePost(
                                        index: index,
                                        category: category,
                                      ),
                                    );
                                  } else if (category == 'Trending' ||
                                      category == 'Top 10 news') {
                                    if (newsIndex != null) {
                                      context.read<TrendingViewBloc>().add(
                                        DownVoteNewsPost(
                                          index: index,
                                          category: category,
                                          newsIndex: newsIndex!,
                                        ),
                                      );
                                    } else {
                                      context.read<TrendingViewBloc>().add(
                                        DownVotePost(
                                          index: index,
                                          category: category,
                                        ),
                                      );
                                    }
                                  } else if (category == 'user') {
                                    context.read<UserBloc>().add(
                                      downvotePost1(
                                        index: index,
                                        context: context,
                                      ),
                                    );
                                  } else if (category == 'other') {
                                    context.read<OtheruserBloc>().add(
                                      downvotePost(
                                        index: index,
                                        context: context,
                                      ),
                                    );
                                  } else if (category == 'saved') {
                                    context.read<UserBloc>().add(
                                      downvotesavedPost(index: index),
                                    );
                                  } else {
                                    context.read<searchBloc.SearchBloc>().add(
                                      searchBloc.DownVotePost(index: index),
                                    );
                                  }
                                },
                                padding: EdgeInsets.zero,
                                icon: Icon(
                                  size: 7.w,

                                  Icons.arrow_circle_down_outlined,
                                  color:
                                      post.isDownVote
                                          ? colorScheme.primary
                                          : colorScheme.secondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(flex: 1),
                        !onFullView
                            ? Container(
                              height: 5.h,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: theme.dividerColor),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 0.5.w,
                                vertical: 0.5.w,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      //Move to the full view of the post with all the comments
                                      pushScreen(
                                        context,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.scale,
                                        screen: ViewDiscussion(
                                          post: post,
                                          index: index,
                                          newIndex: newsIndex,
                                          category: category,
                                        ),

                                        withNavBar: false,
                                      );
                                    },
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      Icons.mode_comment_outlined,
                                      color: theme.colorScheme.secondary,
                                    ),
                                  ),
                                  Text(
                                    "${post.comments}",
                                    style: TextStyle(
                                      color: theme.colorScheme.secondary,
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

                        const Spacer(flex: 10),

                        // Sentiment Analysis Button
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
                                color: colorScheme.primary,
                              ),
                            )
                            : SizedBox.shrink(),
                        Spacer(flex: 1),
                      ],
                    ),
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
