// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Trending%20View%20BLOC/trending_view_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/UI_Components/PostComponents/EmptyPosts.dart';
import 'package:verbatica/UI_Components/PostComponents/PostUI.dart';
import 'package:verbatica/UI_Components/PostComponents/ShimmerLoader.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<TrendingViewBloc>().add(
      FetchPostsWithInNews(
        newsIndex: widget.newsIndex,
        userId: context.read<UserBloc>().state.user!.id,
      ),
    );
  }

  double _getAppBarHeight(String text) {
    const lineHeight = 16.0; // 16 font size + ~8px line spacing
    const baseHeight = kToolbarHeight * 0.7; // default appbar height (56.0)
    int lines = (text.length / 33).ceil(); // assume 30 chars per line
    return baseHeight + (lines - 1) * lineHeight;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            floating: true,
            snap: true,
            pinned: false,
            toolbarHeight: _getAppBarHeight(widget.news.title),
            title: Row(
              children: [
                SizedBox(
                  width: 62.w,
                  child: Text(
                    softWrap: true,
                    maxLines: 3,
                    widget.news.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                onPressed: () {
                  pushScreen(
                    context,
                    screen: CreatePostScreen(newsId: widget.news.newsId),
                  );
                },
                icon: Icon(Icons.add_circle_outlined),
              ),
            ],
          ),
          SliverToBoxAdapter(child: SizedBox(height: 2.w)),

          BlocBuilder<TrendingViewBloc, TrendingViewState>(
            builder: (context, state) {
              if (state.fetchingPostsWithInNews) {
                return SliverList(
                  key: const Key("loader"),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return PostShimmerTile();
                  }, childCount: 10),
                );
              }

              List<Post> discussions = state.news[widget.newsIndex].discussions;
              return discussions.isEmpty
                  ? SliverToBoxAdapter(
                    child: SizedBox(
                      height: 80.h - _getAppBarHeight(widget.news.title),
                      child: Center(
                        child: BuildEmptyTabContent(
                          icon: Icons.article_outlined,
                          message: 'No posts yet',
                        ),
                      ),
                    ),
                  )
                  :
                  // Discussion List
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final discussion = discussions[index];
                      return PostWidget(
                        post: discussion,
                        index: index,
                        category: "Top 10 news",
                        onFullView: false,
                        newsIndex: widget.newsIndex,
                      );
                    }, childCount: discussions.length),
                  );
            },
          ),
        ],
      ),
    );
  }
}
