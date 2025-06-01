// ignore_for_file: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Trending%20View%20BLOC/trending_view_bloc.dart';
import 'package:verbatica/UI_Components/PostComponents/VideoPlayer.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/ProfileView/otherprofile.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Trending%20View%20Screens/TrendingViewDiscussion.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Analysis%20Views/clusterScreen.dart';
import 'package:verbatica/model/Post.dart';
import 'package:timeago/timeago.dart' as timeago;

class TrendingPostWidget extends StatelessWidget {
  final Post post;
  final int index;
  final int? newsIndex;
  final String category;
  final bool onFullView;

  const TrendingPostWidget({
    required this.post,
    super.key,
    this.newsIndex,
    required this.index,
    required this.category,
    required this.onFullView,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: SizedBox(
        width: 100.w,
        child: Column(
          children: [
            Divider(color: theme.dividerColor, thickness: 0.5),
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
                          //Move to the summaryView
                        },
                        style: TextButton.styleFrom(
                          shape: StadiumBorder(),
                          backgroundColor: colorScheme.primary, // Button color
                          foregroundColor: colorScheme.onPrimary, // Text color
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
                        onSelected: (String value) {
                          if (value == "report") {
                            context.read<TrendingViewBloc>().add(
                              ReportPost(
                                index: index,
                                category: category,
                                postId: post.id,
                              ),
                            );
                          } else if (value == "save") {
                            context.read<TrendingViewBloc>().add(
                              SavePost(post: post),
                            );
                          } else if (value == "share") {
                            context.read<TrendingViewBloc>().add(
                              SharePost(post: post),
                            );
                          }
                        },
                        itemBuilder:
                            (BuildContext context) => <PopupMenuEntry<String>>[
                              PopupMenuItem<String>(
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
                              ),
                              PopupMenuItem<String>(
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
            Divider(color: theme.dividerColor, thickness: 0.5),
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
                      color: textTheme.titleLarge?.color,
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
                      color: textTheme.bodyLarge?.color,
                    ),
                    linkColor: colorScheme.primary,
                  ),
                ),

                SizedBox(height: 0.5.h),

                if (post.postImageLink != null)
                  CachedNetworkImage(
                    imageUrl: post.postImageLink!,
                    placeholder:
                        (context, url) => Shimmer.fromColors(
                          baseColor: colorScheme.surfaceVariant.withOpacity(
                            0.3,
                          ),
                          highlightColor: colorScheme.surfaceVariant
                              .withOpacity(0.1),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(color: colorScheme.surfaceVariant),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Container(
                            color: colorScheme.errorContainer,
                            child: Icon(Icons.error, color: colorScheme.error),
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
                          BlocProvider<TrendingViewBloc>.value(
                            value:
                                context
                                    .read<
                                      TrendingViewBloc
                                    >(), // Passing existing bloc
                          ),
                        ],
                        child: TrendingViewDiscussion(
                          post: post,
                          index: index,
                          newIndex: newsIndex,
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
                          border: Border.all(color: colorScheme.outline),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 0.5.w,
                          vertical: 0.5.w,
                        ),
                        child: BlocBuilder<TrendingViewBloc, TrendingViewState>(
                          builder: (context, state) {
                            Post dynamicpost;
                            if (newsIndex != null) {
                              dynamicpost =
                                  state.news[newsIndex!].discussions[index];
                            } else {
                              dynamicpost = state.trending[index];
                            }
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
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
                                                  ? colorScheme.primary
                                                  : textTheme.bodyLarge?.color,
                                        ),
                                      ),

                                      Text(
                                        "${dynamicpost.upvotes - dynamicpost.downvotes}",
                                        style: TextStyle(
                                          color: textTheme.bodyLarge?.color,
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
                                  color: colorScheme.outline,
                                ),
                                IconButton(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,

                                  onPressed: () {
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
                                  },
                                  padding: EdgeInsets.zero,
                                  icon: Icon(
                                    size: 7.w,

                                    Icons.arrow_circle_down_outlined,
                                    color:
                                        dynamicpost.isDownVote
                                            ? colorScheme.primary
                                            : textTheme.bodyLarge?.color,
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
                              border: Border.all(color: colorScheme.outline),
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
                                    //Move to the full view of the post with all the comments
                                    pushScreen(
                                      context,
                                      pageTransitionAnimation:
                                          PageTransitionAnimation.scale,
                                      screen: MultiBlocProvider(
                                        providers: [
                                          BlocProvider<TrendingViewBloc>.value(
                                            value:
                                                context
                                                    .read<
                                                      TrendingViewBloc
                                                    >(), // Passing existing bloc
                                          ),
                                        ],
                                        child: TrendingViewDiscussion(
                                          post: post,
                                          index: index,
                                          newIndex: newsIndex,
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
                                    color: textTheme.bodyLarge?.color,
                                  ),
                                ),
                                Text(
                                  "${post.comments}",
                                  style: TextStyle(
                                    color: textTheme.bodyLarge?.color,
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
            Divider(color: theme.dividerColor, thickness: 0.5),
          ],
        ),
      ),
    );
  }
}
