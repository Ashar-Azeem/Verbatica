// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Trending%20View%20BLOC/trending_view_bloc.dart';
import 'package:verbatica/UI_Components/PostComponents/PostUI.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/AddPostView.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/news.dart';

class PostsWithInNews extends StatelessWidget {
  final News news;
  final int newsIndex;
  const PostsWithInNews({
    super.key,
    required this.news,
    required this.newsIndex,
  });

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
          SliverToBoxAdapter(child: SizedBox(height: 2.w)),

          BlocBuilder<TrendingViewBloc, TrendingViewState>(
            buildWhen:
                (previous, current) =>
                    previous.news[newsIndex] != current.news[newsIndex],
            builder: (context, state) {
              List<Post> discussions = state.news[newsIndex].discussions;
              return discussions.isEmpty
                  ? SliverToBoxAdapter(
                    child: Center(child: Text('No Discussions yet')),
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
                        newsIndex: newsIndex,
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
