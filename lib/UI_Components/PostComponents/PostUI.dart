// ignore_for_file: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/UI_Components/PostComponents/VideoPlayer.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/model/Post.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostWidget extends StatelessWidget {
  final Post post;

  const PostWidget({required this.post, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.5.h),
      child: Center(
        child: Container(
          width: 97.w,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 15, 19, 22),
            borderRadius: BorderRadius.circular(7),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 5.h,
                child: Padding(
                  padding: EdgeInsets.only(left: 1.w, top: 1.w),

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
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(9),
                          ),
                          backgroundColor: primaryColor, // Button color
                          foregroundColor: Colors.white, // Text color
                        ),
                        child: Text(
                          'Summary',
                          style: TextStyle(color: Colors.white, fontSize: 3.w),
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert),
                        onSelected: (String value) {
                          // Handle the selected option here
                        },
                        itemBuilder:
                            (BuildContext context) => <PopupMenuEntry<String>>[
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
                                value: 'unfollow',
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Icon(
                                      Icons.cancel_presentation,
                                      color: Colors.white,
                                    ),
                                    Text('Unfollow'),
                                  ],
                                ),
                              ),
                            ],
                      ),
                    ],
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
                child: SizedBox(
                  height: 6.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.arrow_circle_up_outlined,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "${post.upvotes - post.downvotes}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 3.w,
                                height: 1,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Container(
                              width: 1,
                              height: 6.h,
                              color: Color.fromARGB(255, 70, 79, 87),
                            ),
                            IconButton(
                              onPressed: () {},
                              padding: EdgeInsets.zero,
                              icon: Icon(
                                Icons.arrow_circle_down_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(flex: 1),
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
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              onPressed: () {},
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
                      ),

                      const Spacer(flex: 10),

                      // Sentiment Analysis Button
                      SizedBox(
                        height: 9.w,
                        child: IconButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                          ),
                          icon: Icon(
                            Icons.pie_chart,
                            size: 7.w,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      Spacer(flex: 1),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
