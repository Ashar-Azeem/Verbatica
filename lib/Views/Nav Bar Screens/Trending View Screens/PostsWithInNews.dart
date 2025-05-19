// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/UI_Components/TrendingPostComponents/TrendingPost.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/AddPostView.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/news.dart';

class PostsWithInNews extends StatefulWidget {
  final News news;
  final int newsIndex;
  const PostsWithInNews({
    super.key,
    required this.news,
    required this.newsIndex,
  });

  @override
  State<PostsWithInNews> createState() => _PostsWithInNewsState();
}

class _PostsWithInNewsState extends State<PostsWithInNews> {
  late News news;
  late int newsIndex;
  late List<Post> discussions;
  @override
  void initState() {
    super.initState();
    news = widget.news;
    newsIndex = widget.newsIndex;
    discussions = news.discussions;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 4.h,
            floating: true,
            snap: true,
            pinned: false,
            title: Row(
              children: [
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  pushScreen(context, screen: CreatePostScreen());
                },
                icon: Icon(Icons.add_circle_outlined),
              ),
            ],
          ),

          discussions.isEmpty
              ? SliverToBoxAdapter(
                child: Center(child: Text('No Discussions yet')),
              )
              :
              // Discussion List
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final discussion = discussions[index];
                  return TrendingPostWidget(
                    post: discussion,
                    index: index,
                    category: "Top 10 news",
                    onFullView: false,
                    newsIndex: newsIndex,
                  );
                }, childCount: discussions.length),
              ),
        ],
      ),
    );
  }
}
