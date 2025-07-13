// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_event.dart';
import 'package:verbatica/BLOC/User%20bloc/user_state.dart';
import 'package:verbatica/UI_Components/PostComponents/PostUI.dart';
import 'package:verbatica/UI_Components/PostComponents/ShimmerLoader.dart';
import 'package:verbatica/Utilities/dateformat.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/ProfileView/editprofile.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/ProfileView/settingscreen.dart';
import 'package:timeago/timeago.dart' as timeago;

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final double expandedHeight = 62.0.h; // AppBar height + TabBar height
  late final ValueNotifier<double> _scrollNotifier;

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(updateCommentWithPost());
    context.read<UserBloc>().add(FetchUserPosts());
    _tabController = TabController(length: 3, vsync: this);
    _scrollNotifier = ValueNotifier(0.0);
    _scrollController.addListener(_updateScrollNotifier);
  }

  void _updateScrollNotifier() {
    _scrollNotifier.value = _scrollController.offset;
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateScrollNotifier);
    _scrollNotifier.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Add this method to the _ProfileViewState class
  // Modify the buildUserPostsTab method to add bottom padding
  Widget buildUserPostsTab(UserState state) {
    if (state.isLoadingPosts) {
      // Show shimmer while loading
      return ListView.builder(
        // Add bottom padding to account for the navigation bar
        padding: EdgeInsets.only(bottom: 16.0.h), // Added bottom padding
        itemCount: 5,
        itemBuilder: (_, index) => const PostShimmerTile(),
      );
    }

    if (state.userPosts.isEmpty) {
      return _buildEmptyTabContent(
        icon: Icons.article_outlined,
        message: 'No posts yet',
      );
    }

    return ListView.builder(
      // Add bottom padding to account for the navigation bar
      padding: EdgeInsets.only(
        top: 2.h,
        bottom: 16.0.h,
      ), // Added bottom padding
      itemCount: state.userPosts.length,
      itemBuilder: (context, index) {
        final post = state.userPosts[index];
        return Padding(
          padding: EdgeInsets.only(left: 1.w, right: 1.w),
          child: PostWidget(
            post: post,
            index: index,
            onFullView: false,
            category: 'user',
          ),
        );
      },
    );
  }

  // Add this method to the _ProfileViewState class

  bool _isAppBarCollapsed(double shrinkOffset) {
    // Simpler condition to determine when to show the collapsed state
    return shrinkOffset > 40.h; // Fixed threshold that works reliably
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          controller: _scrollController,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: expandedHeight,
                floating: false,
                pinned: true,
                snap: false,
                stretch: false,
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  stretchModes: const [StretchMode.zoomBackground],
                  background: _buildProfileHeader(context),
                  titlePadding: EdgeInsets.zero,
                  title: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      return ValueListenableBuilder<double>(
                        valueListenable: _scrollNotifier,
                        builder: (context, scrollOffset, child) {
                          final isCollapsed = _isAppBarCollapsed(scrollOffset);

                          return AnimatedSwitcher(
                            duration: const Duration(seconds: 1),
                            switchInCurve: Curves.easeIn,
                            switchOutCurve: Curves.easeOut,
                            child:
                                isCollapsed
                                    ? Container(
                                      key: const ValueKey('collapsedAppBar'),
                                      padding: EdgeInsets.only(
                                        left: 2.w,
                                        bottom: 2.w,
                                      ),
                                      color:
                                          isDarkMode
                                              ? const Color.fromARGB(
                                                255,
                                                10,
                                                13,
                                                15,
                                              )
                                              : const Color.fromARGB(
                                                255,
                                                230,
                                                230,
                                                230,
                                              ),
                                      height: 20.h,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 6.w,
                                            backgroundImage: AssetImage(
                                              'assets/Avatars/avatar${state.user.avatarId}.jpg',
                                            ),
                                          ),
                                          const Spacer(),
                                          SizedBox(
                                            width: 40.w,
                                            child: Text(
                                              state.user.username,
                                              style: TextStyle(
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.secondary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 4.w,
                                              ),
                                            ),
                                          ),
                                          const Spacer(flex: 8),
                                          IconButton(
                                            icon: Icon(
                                              Icons.settings,
                                              size: 5.w,
                                            ),
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                            onPressed: () {
                                              pushScreen(
                                                context,
                                                screen: const SettingsScreen(),
                                                withNavBar: false,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    )
                                    : const SizedBox.shrink(), // Removed from tree when not collapsed
                          );
                        },
                      );
                    },
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48.0),
                  child: Container(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    child: TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.article, size: 18),
                              SizedBox(width: 8),
                              Text('Posts'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.comment, size: 18),
                              SizedBox(width: 8),
                              Text('Comments'),
                            ],
                          ),
                        ),
                        Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person, size: 18),
                              SizedBox(width: 8),
                              Text('About'),
                            ],
                          ),
                        ),
                      ],
                      labelColor: Theme.of(context).colorScheme.primary,
                      unselectedLabelColor: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 3.0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        insets: const EdgeInsets.symmetric(horizontal: 16.0),
                      ),
                      dividerColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              // Posts Tab
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  return buildUserPostsTab(state);
                },
              ),

              // Comments Tab
              BlocBuilder<UserBloc, UserState>(
                builder: (context, state) {
                  return buildUserCommentsTab(state);
                },
              ),

              // About Tab
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(5.0.w),
                  child: _buildAboutSection(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUserCommentsTab(UserState state) {
    if (state.isLoadingComments) {
      // Show shimmer while loading
      return ListView.builder(
        // Add bottom padding to account for the navigation bar
        padding: EdgeInsets.only(bottom: 16.0.h), // Added bottom padding
        itemCount: 5,
        itemBuilder: (_, index) => const CommentShimmerTile(),
      );
    }

    if (state.userComments.isEmpty) {
      return Center(
        child: Text(
          "No comments yet",
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      );
    }

    return ListView.builder(
      // Add bottom padding to account for the navigation bar
      padding: EdgeInsets.only(bottom: 16.0.h), // Added bottom padding
      itemCount: state.userComments.length,
      itemBuilder: (context, index) {
        final comment = state.userComments[index];
        final post = state.postofComments[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Subreddit + time + upvotes
              Text(
                post.title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),

              Text(
                '/${comment.text}    • ${timeago.format(comment.uploadTime)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),

              const SizedBox(height: 4),

              // Post title
              const SizedBox(height: 4),

              // Actual comment text
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    // This is the expanded profile header view
    return ValueListenableBuilder<double>(
      valueListenable: _scrollNotifier,
      builder: (context, scrollOffset, child) {
        final bool isCollapsed = _isAppBarCollapsed(scrollOffset);

        return AnimatedContainer(
          duration: Duration(seconds: 2),
          child:
              isCollapsed
                  ? SizedBox.shrink()
                  : Stack(
                    children: [
                      // Gradient Background
                      Container(
                        height: 35.0.h,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(
                                context,
                              ).colorScheme.primary.withOpacity(0.4),
                            ],
                            stops: [0.4, 1.0],
                          ),
                        ),
                      ),

                      // Main Content
                      SafeArea(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Top Section with Avatar and Info
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                              child: Column(
                                children: [
                                  // Settings Button in expanded view - only visible when expanded
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: IconButton(
                                      onPressed: () {
                                        pushScreen(
                                          context,
                                          screen: const SettingsScreen(),
                                          withNavBar: false,
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.settings,
                                        color: Colors.white,
                                        size: 26,
                                      ),
                                      style: IconButton.styleFrom(
                                        backgroundColor: Colors.white
                                            .withOpacity(0.2),
                                      ),
                                    ),
                                  ),

                                  SizedBox(height: 1.0.h),

                                  // Profile Card
                                  Container(
                                    // margin: EdgeInsets.only(bottom: 2.0.h),
                                    padding: EdgeInsets.all(5.0.w),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor,
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Theme.of(
                                            context,
                                          ).shadowColor.withOpacity(0.1),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: BlocBuilder<UserBloc, UserState>(
                                      builder: (context, state) {
                                        return Column(
                                          children: [
                                            // Avatar
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color: Colors.white,
                                                  width: 3,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                        .shadowColor
                                                        .withOpacity(0.2),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: CircleAvatar(
                                                radius: 8.0.h,
                                                backgroundImage: AssetImage(
                                                  'assets/Avatars/avatar${state.user.avatarId}.jpg',
                                                ),
                                              ),
                                            ),

                                            SizedBox(height: 2.0.h),

                                            // Username
                                            Text(
                                              state.user.username,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                                color:
                                                    Theme.of(context)
                                                        .textTheme
                                                        .headlineSmall
                                                        ?.color,
                                              ),
                                            ),

                                            SizedBox(height: 1.0.h),

                                            // Aura Points
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 3.0.w,
                                                vertical: 1.0.h,
                                              ),
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(
                                                  colors: [
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                        .withOpacity(0.8),
                                                  ],
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.auto_awesome,
                                                    color: Colors.amber,
                                                    size: 20,
                                                  ),
                                                  SizedBox(width: 1.0.w),
                                                  Text(
                                                    '${state.user.karma} Aura',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),

                                            SizedBox(height: 2.0.h),

                                            // Join Date
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.cake,
                                                  size: 18,
                                                  color: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.color
                                                      ?.withOpacity(0.6),
                                                ),
                                                SizedBox(width: 1.0.w),
                                                Text(
                                                  'Member since ${formatJoinedDate(state.user.joinedDate)}',
                                                  style: TextStyle(
                                                    color: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium
                                                        ?.color
                                                        ?.withOpacity(0.6),
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            SizedBox(height: 2.0.h),

                                            // Edit Profile Button
                                            ElevatedButton.icon(
                                              onPressed: () {
                                                print(
                                                  'hggjdfhdhfjh!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!',
                                                );
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  builder:
                                                      (context) => Container(
                                                        height:
                                                            MediaQuery.of(
                                                              context,
                                                            ).size.height *
                                                            0.95,
                                                        decoration: BoxDecoration(
                                                          color:
                                                              Theme.of(
                                                                context,
                                                              ).cardColor,
                                                          borderRadius:
                                                              const BorderRadius.vertical(
                                                                top:
                                                                    Radius.circular(
                                                                      20,
                                                                    ),
                                                              ),
                                                        ),
                                                        child: BlocProvider.value(
                                                          value:
                                                              BlocProvider.of<
                                                                UserBloc
                                                              >(context),
                                                          child:
                                                              const EditProfileScreen(),
                                                        ),
                                                      ),
                                                );
                                              },
                                              icon: const Icon(
                                                Icons.edit,
                                                size: 18,
                                              ),
                                              label: const Text('Edit Profile'),
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                foregroundColor: Colors.white,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 6.0.w,
                                                  vertical: 1.2.h,
                                                ),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
        );
      },
    );
  }

  Widget _buildAboutSection() {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.all(5.0.w),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // About Section Header
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  SizedBox(width: 2.0.w),
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),

              Divider(height: 4.0.h),

              // Bio
              Container(
                padding: EdgeInsets.all(3.0.w),
                decoration: BoxDecoration(
                  color: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.color?.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  state.user.about ?? 'No bio added yet.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.color?.withOpacity(0.8),
                  ),
                ),
              ),

              SizedBox(height: 3.0.h),

              // Member Since Info
              _buildInfoItem(
                icon: Icons.date_range,
                iconColor: Theme.of(context).colorScheme.primary,
                label: 'Member since',
                value: formatJoinedDate(state.user.joinedDate),
              ),

              SizedBox(height: 2.0.h),

              // Location Info
              _buildInfoItem(
                icon: Icons.location_on,
                iconColor: Theme.of(context).colorScheme.secondary,
                label: 'Location',
                value: state.user.country,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyTabContent({
    required IconData icon,
    required String message,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: Theme.of(
              context,
            ).textTheme.bodyMedium?.color?.withOpacity(0.4),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(
                context,
              ).textTheme.bodyMedium?.color?.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.0.w),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        SizedBox(width: 3.0.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Theme.of(
                  context,
                ).textTheme.bodyMedium?.color?.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class CommentShimmerTile extends StatelessWidget {
  const CommentShimmerTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade800
                : Colors.grey.shade300,
        highlightColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.grey.shade700
                : Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post title shimmer
            Container(
              height: 14,
              width: 220,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 6),

            // Comment info shimmer (subreddit/time/upvotes)
            Container(
              height: 10,
              width: 160,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 10),

            // Comment body shimmer
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 12,
              width: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
