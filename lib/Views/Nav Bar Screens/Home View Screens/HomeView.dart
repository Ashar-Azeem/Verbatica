// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Chat%20Bloc/chat_bloc.dart';
import 'package:verbatica/BLOC/Home/home_bloc.dart';
import 'package:verbatica/UI_Components/PostComponents/PostUI.dart';
import 'package:verbatica/UI_Components/PostComponents/ShimmerLoader.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Home%20View%20Screens/Chats%20And%20Messaging%20Views/ChatsView.dart';
import 'package:verbatica/model/Post.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    //initial fetch for loading the for you because it is the first tab that opens
    context.read<HomeBloc>().add(FetchInitialForYouPosts());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: DefaultTabController(
        length: 2,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.only(left: 1.w, right: 1.w),
            child: NestedScrollView(
              physics: NeverScrollableScrollPhysics(),
              headerSliverBuilder:
                  (context, innerBoxIsScrolled) => [
                    SliverAppBar(
                      backgroundColor: theme.scaffoldBackgroundColor,
                      automaticallyImplyLeading: false,
                      toolbarHeight: 12.h,
                      floating: true,
                      snap: true,
                      pinned: false,
                      title: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Image.asset(
                                'assets/Logo.png',
                                width: 40,
                                height: 40,
                              ),
                              BlocBuilder<ChatBloc, ChatState>(
                                buildWhen:
                                    (previous, current) =>
                                        previous.isAnyUnread !=
                                        current.isAnyUnread,
                                builder: (context, state) {
                                  return Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        pushScreen(
                                          context,
                                          pageTransitionAnimation:
                                              PageTransitionAnimation.platform,
                                          screen: ChatsView(),
                                          withNavBar: false,
                                        );
                                      },
                                      borderRadius: BorderRadius.circular(50),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Badge(
                                          isLabelVisible: state.isAnyUnread,
                                          backgroundColor: colorScheme.error,
                                          child: Icon(
                                            Icons.insert_comment_rounded,
                                            color: colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          BlocBuilder<HomeBloc, HomeState>(
                            builder: (context, state) {
                              return TabBar(
                                dividerColor: Theme.of(context).dividerColor,
                                indicatorColor:
                                    Theme.of(context).colorScheme.primary,
                                labelColor:
                                    Theme.of(context).colorScheme.primary,
                                unselectedLabelColor:
                                    Theme.of(context).colorScheme.secondary,

                                onTap: (value) {
                                  //Only Called once
                                  if (value == 1 && state.following.isEmpty) {
                                    //Fetching this event here because we don't want to load the content of the following without being there
                                    context.read<HomeBloc>().add(
                                      FetchInitialFollowingPosts(),
                                    );
                                  }
                                },
                                tabs: const [
                                  Tab(text: 'For You'),
                                  Tab(text: 'Following'),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],

              body: BlocBuilder<HomeBloc, HomeState>(
                buildWhen: (previous, current) {
                  return previous.forYou != current.forYou ||
                      previous.following != current.following;
                },
                builder: (context, state) {
                  return TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      // For You Tab
                      BuiltPostList(
                        posts: state.forYou,
                        loading: state.forYouInitialLoading,
                        category: "ForYou",
                      ),

                      // Following Tab
                      BuiltPostList(
                        posts: state.following,
                        loading: state.followingInitialLoading,
                        category: "Following",
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class BuiltPostList extends StatefulWidget {
  final List<Post> posts;
  final bool loading;
  final String category;

  const BuiltPostList({
    super.key,
    required this.posts,
    required this.loading,
    required this.category,
  });

  @override
  State<BuiltPostList> createState() => _BuiltPostListState();
}

class _BuiltPostListState extends State<BuiltPostList>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return widget.loading
        ? ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return PostShimmerTile();
          },
        )
        : ListView.builder(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.only(top: 0),
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          cacheExtent: 500,
          itemCount: widget.posts.length,
          itemBuilder: (context, index) {
            return PostWidget(
              post: widget.posts[index],
              index: index,
              category: widget.category,
              onFullView: false,
            );
          },
        );
  }

  @override
  bool get wantKeepAlive => true;
}
