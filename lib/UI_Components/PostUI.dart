// ignore_for_file: file_names
import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
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
            borderRadius: BorderRadius.circular(5),
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

                  /// Image placeholder (show only if image link is not null)
                  if (post.postImageLink != null)
                    Container(
                      height: 300,
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Text("Image Placeholder"),
                    ),

                  /// Video placeholder (show only if video link is not null)
                  if (post.postVideoLink != null)
                    Container(
                      height: 200,
                      color: Colors.grey[400],
                      alignment: Alignment.center,
                      child: const Text("Video Placeholder"),
                    ),
                ],
              ),

              //End of content, title, image or video

              //Bottom side of the post
              Padding(
                padding: EdgeInsets.only(right: 1.w, bottom: 1.w),
                child: SizedBox(
                  height: 6.3.h,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Upvote Column
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 9.w,
                            child: IconButton(
                              onPressed: () {},
                              splashRadius: 1,
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              iconSize: 7.w,
                              icon: Icon(Icons.arrow_circle_up_outlined),
                            ),
                          ),
                          Text(
                            "20",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 3.w,
                              height: 1,
                            ),
                          ),
                        ],
                      ),

                      // Downvote Button with Count
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 9.w,
                            child: IconButton(
                              onPressed: () {},
                              splashRadius: 1,
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              iconSize: 7.w,
                              icon: Icon(Icons.arrow_circle_down_outlined),
                            ),
                          ),
                          Text(
                            "5",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 3.w,
                              height: 1,
                            ),
                          ),
                        ],
                      ),

                      // Comment Button with Count
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 9.w,
                            child: IconButton(
                              onPressed: () {},
                              splashRadius: 1,
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              iconSize: 6.8.w,
                              icon: Icon(Icons.mode_comment_outlined),
                            ),
                          ),
                          Text(
                            "8",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 3.w,
                              height: 1,
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Sentiment Analysis Button
                      SizedBox(
                        height: 9.w,
                        child: TextButton.icon(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            minimumSize: Size.zero,
                            padding: EdgeInsets.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: Icon(Icons.pie_chart_sharp, size: 7.w),
                          label: Text(
                            'Sentiment Analysis',
                            style: TextStyle(fontSize: 3.w, height: 1),
                          ),
                        ),
                      ),
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
