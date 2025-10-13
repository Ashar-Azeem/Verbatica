// ignore_for_file: file_names

import 'dart:async';

import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Chat%20Bloc/chat_bloc.dart';
import 'package:verbatica/BLOC/Home/home_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/UI_Components/Comment%20Componenets/Ad_component/adComponent.dart';
import 'package:verbatica/UI_Components/PostComponents/EmptyPosts.dart';
import 'package:verbatica/UI_Components/PostComponents/PostUI.dart';
import 'package:verbatica/UI_Components/PostComponents/ShimmerLoader.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Home%20View%20Screens/Chats%20And%20Messaging%20Views/ChatsView.dart';
import 'package:verbatica/model/Ad.dart';
import 'package:verbatica/model/FeedItem.dart';
import 'package:verbatica/model/Post.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with TickerProviderStateMixin {
  bool fetchFollowing = true;
  @override
  void initState() {
    super.initState();
    //initial fetch for loading the for you because it is the first tab that opens

    //Timer is used so that this event is called in the next event loop after blocs has been completely initialized
    Timer(const Duration(seconds: 0), () {
      final user = context.read<UserBloc>().state.user;

      if (user != null) {
        context.read<HomeBloc>().add(FetchInitialForYouPosts(userId: user.id));
      } else {
        debugPrint("User not ready yet, skipping fetch.");
      }
    });
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
            child: ExtendedNestedScrollView(
              onlyOneScrollInBody: true,
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
                                  if (value == 1 && fetchFollowing) {
                                    //Fetching this event here because we don't want to load the content of the following without being there
                                    context.read<HomeBloc>().add(
                                      FetchInitialFollowingPosts(
                                        userId:
                                            context
                                                .read<UserBloc>()
                                                .state
                                                .user!
                                                .id,
                                      ),
                                    );
                                    setState(() {
                                      fetchFollowing = false;
                                    });
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
                        ads: state.ads,
                        loading: state.forYouInitialLoading,
                        hasMore: state.hasMoreForYouPosts,
                        category: "ForYou",
                      ),

                      // Following Tab
                      BuiltPostList(
                        posts: state.following,
                        ads: state.ads,
                        loading: state.followingInitialLoading,
                        category: "Following",
                        hasMore: state.hasMoreFollowingPosts,
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
  final bool hasMore;
  final List<Ad> ads;
  final String category;

  const BuiltPostList({
    super.key,
    required this.posts,
    required this.hasMore,
    required this.loading,
    required this.category,
    required this.ads,
  });

  @override
  State<BuiltPostList> createState() => _BuiltPostListState();
}

class _BuiltPostListState extends State<BuiltPostList>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    // 🔹 Step 1: Handle loading state
    if (widget.loading) {
      return ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => PostShimmerTile(),
      );
    }

    // 🔹 Step 2: Handle empty state
    if (widget.posts.isEmpty) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: const Center(
          child: BuildEmptyTabContent(
            icon: Icons.article_outlined,
            message: 'No posts',
          ),
        ),
      );
    }

    // 🔹 Step 3: Combine posts & ads into one feed
    final combinedFeed = <FeedItem>[];
    for (int i = 0; i < widget.posts.length; i++) {
      combinedFeed.add(widget.posts[i]);

      // Only add ad after every 10 posts *if ads remain*
      if ((i + 1) % 10 == 0 && i ~/ 10 < widget.ads.length) {
        combinedFeed.add(widget.ads[i ~/ 10]);
      }
    }

    // 🔹 Step 4: Build the feed
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 0),
      addAutomaticKeepAlives: true,
      addRepaintBoundaries: true,
      cacheExtent: 500,
      itemCount: combinedFeed.length + (widget.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Infinite scroll loading trigger
        if (index == combinedFeed.length) {
          final userId = context.read<UserBloc>().state.user!.id;
          context.read<HomeBloc>().add(
            widget.category == "Following"
                ? FetchBottomFollowingPosts(userId)
                : FetchBottomForYouPosts(userId: userId),
          );
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 3.h),
            child: LoadingAnimationWidget.dotsTriangle(
              color: primaryColor,
              size: 12.w,
            ),
          );
        }

        // 🔹 Step 5: Render Post or Ad based on type
        final item = combinedFeed[index];
        if (item is Post) {
          return PostWidget(
            post: item,
            index: widget.posts.indexWhere((p) => p.id == item.id),
            category: widget.category,
            onFullView: false,
          );
        } else if (item is Ad) {
          return AdCard(ad: item);
        }

        return const SizedBox.shrink();
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
