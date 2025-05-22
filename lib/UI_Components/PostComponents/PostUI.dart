// ignore_for_file: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Home/home_bloc.dart';
import 'package:verbatica/UI_Components/PostComponents/VideoPlayer.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Home%20View%20Screens/SummaryView.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Home%20View%20Screens/ViewDiscussion.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/ProfileView/otherprofile.dart';
import 'package:verbatica/Views/clusterScreen.dart';
import 'package:verbatica/model/Post.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostWidget extends StatelessWidget {
  final Post post;
  final int index;
  final String category;
  final bool onFullView;

  const PostWidget({
    required this.post,
    super.key,
    required this.index,
    required this.category,
    required this.onFullView,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Center(
        child: SizedBox(
          width: 100.w,

          child: Column(
            children: [
              Divider(color: Color.fromARGB(255, 22, 28, 33), thickness: 0.5),
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
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                timeago.format(post.uploadTime),
                                style: TextStyle(
                                  color: Colors.white,
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

                            backgroundColor: primaryColor, // Button color
                            foregroundColor: Colors.white, // Text color
                          ),
                          child: Text(
                            'Summary',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 2.8.w,
                            ),
                          ),
                        ),
                        PopupMenuButton<String>(
                          icon: Icon(Icons.more_vert),
                          onSelected: (String value) {
                            if (value == "report") {
                              context.read<HomeBloc>().add(
                                ReportPost(
                                  index: index,
                                  category: category,
                                  postId: post.id,
                                ),
                              );
                            } else if (value == "save") {
                              // context.read<HomeBloc>().add(
                              // SavePost(post: post)
                              // );
                            } else if (value == "share") {
                              context.read<HomeBloc>().add(
                                SharePost(post: post),
                              );
                            }
                          },
                          itemBuilder:
                              (
                                BuildContext context,
                              ) => <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'report',
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(
                                        Icons.report_gmailerrorred,
                                        color: Colors.white,
                                      ),

                                      Text('Report'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'save',
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(Icons.save, color: Colors.white),
                                      Text('Save'),
                                    ],
                                  ),
                                ),

                                const PopupMenuItem<String>(
                                  value: 'share',
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(Icons.share, color: Colors.white),
                                      Text('Share'),
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
              Divider(color: Color.fromARGB(255, 22, 28, 33), thickness: 0.5),
              //Content, title, image or video
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Title
                  Padding(
                    padding: EdgeInsets.only(left: 1.w),
                    child: Text(
                      post.title,
                      style: const TextStyle(
                        color: Colors.white,
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
                      style: const TextStyle(fontSize: 15, color: Colors.white),

                      linkColor: primaryColor,
                    ),
                  ),

                  SizedBox(height: 0.5.h),

                  if (post.postImageLink != null)
                    CachedNetworkImage(
                      imageUrl: post.postImageLink!,
                      placeholder:
                          (context, url) => Shimmer.fromColors(
                            baseColor: const Color.fromARGB(255, 58, 76, 90),
                            highlightColor: const Color.fromARGB(
                              255,
                              81,
                              106,
                              125,
                            ),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(color: Colors.white),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              color: Colors.grey[200],
                              child: const Icon(Icons.error),
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
                padding: EdgeInsets.only(right: 1.w, bottom: 1.w),
                child: InkWell(
                  onTap: () {
                    if (!onFullView) {
                      pushScreen(
                        context,
                        pageTransitionAnimation: PageTransitionAnimation.scale,
                        screen: MultiBlocProvider(
                          providers: [
                            BlocProvider<HomeBloc>.value(
                              value:
                                  context
                                      .read<
                                        HomeBloc
                                      >(), // Passing existing bloc
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
                              color: Color.fromARGB(255, 70, 79, 87),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 0.5.w,
                            vertical: 0.5.w,
                          ),
                          child: BlocBuilder<HomeBloc, HomeState>(
                            builder: (context, state) {
                              Post dynamicpost;
                              if (category == 'ForYou') {
                                dynamicpost = state.forYou[index];
                              } else if (category == 'Following') {
                                dynamicpost = state.following[index];
                              } else {
                                dynamicpost = post;
                              }
                              return Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      context.read<HomeBloc>().add(
                                        UpVotePost(
                                          index: index,
                                          category: category,
                                        ),
                                      );
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
                                                    ? primaryColor
                                                    : Colors.white,
                                          ),
                                        ),

                                        Text(
                                          "${dynamicpost.upvotes - dynamicpost.downvotes}",
                                          style: TextStyle(
                                            color: Colors.white,
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
                                    color: Color.fromARGB(255, 70, 79, 87),
                                  ),

                                  IconButton(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,

                                    onPressed: () {
                                      context.read<HomeBloc>().add(
                                        DownVotePost(
                                          index: index,
                                          category: category,
                                        ),
                                      );
                                    },
                                    padding: EdgeInsets.zero,
                                    icon: Icon(
                                      size: 7.w,

                                      Icons.arrow_circle_down_outlined,
                                      color:
                                          dynamicpost.isDownVote
                                              ? primaryColor
                                              : Colors.white,
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
                                  color: Color.fromARGB(255, 70, 79, 87),
                                ),
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
                                        screen: MultiBlocProvider(
                                          providers: [
                                            BlocProvider<HomeBloc>(
                                              create:
                                                  (_) =>
                                                      context.read<HomeBloc>(),
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
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${post.comments}",
                                    style: TextStyle(
                                      color: Colors.white,
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
                                color: primaryColor,
                              ),
                            )
                            : SizedBox.shrink(),
                        Spacer(flex: 1),
                      ],
                    ),
                  ),
                ),
              ),
              Divider(color: Color.fromARGB(255, 22, 28, 33), thickness: 0.5),
            ],
          ),
        ),
      ),
    );
  }
}
