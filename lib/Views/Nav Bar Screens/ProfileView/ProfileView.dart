// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_event.dart';
import 'package:verbatica/BLOC/User%20bloc/user_state.dart';
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

  bool _isAppBarCollapsed(double shrinkOffset) {
    // Simpler condition to determine when to show the collapsed state
    return shrinkOffset > 120; // Fixed threshold that works reliably
  }

  @override
  Widget build(BuildContext context) {
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
                stretch: true,
                automaticallyImplyLeading: false,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  stretchModes: const [StretchMode.zoomBackground],
                  background: _buildProfileHeader(context),
                  titlePadding: EdgeInsets.zero,
                  // Using ValueListenableBuilder to respond to scroll changes
                  title: BlocBuilder<UserBloc, UserState>(
                    builder: (context, state) {
                      return ValueListenableBuilder<double>(
                        valueListenable: _scrollNotifier,
                        builder: (context, scrollOffset, child) {
                          final isCollapsed = _isAppBarCollapsed(scrollOffset);

                          if (isCollapsed) {
                            return Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              height: kToolbarHeight,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Username in collapsed state
                                  Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Text(
                                      state.user.username,
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleLarge?.color ??
                                            Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                  // Settings button in collapsed state
                                  IconButton(
                                    icon: const Icon(Icons.settings),
                                    color:
                                        Theme.of(
                                          context,
                                        ).textTheme.titleLarge?.color ??
                                        Colors.white,
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
                            );
                          } else {
                            return const SizedBox.shrink(); // Empty container when expanded
                          }
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
                      labelColor: Theme.of(context).primaryColor,
                      unselectedLabelColor: Colors.grey,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: 3.0,
                          color: Theme.of(context).primaryColor,
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
              Builder(
                builder: (BuildContext context) {
                  return _buildEmptyTabContent(
                    icon: Icons.article_outlined,
                    message: 'No posts yet',
                  );
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
        padding: EdgeInsets.zero, // Important for proper scrolling
        itemCount: 5,
        itemBuilder: (_, index) => const CommentShimmerTile(),
      );
    }

    if (state.userComments.isEmpty) {
      return const Center(child: Text("No comments yet"));
    }

    return ListView.builder(
      padding: EdgeInsets.zero, // Important for proper scrolling
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
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Colors.white,
                ),
              ),

              Text(
                '/${comment.text}    • ${timeago.format(comment.uploadTime)}',
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
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
    return Stack(
      children: [
        // Gradient Background
        Container(
          height: 35.0.h,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF1A237E), // Deeper indigo
                Color(0xFF0D47A1), // Royal blue
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
                      alignment: Alignment.centerRight,
                      child: ValueListenableBuilder<double>(
                        valueListenable: _scrollNotifier,
                        builder: (context, scrollOffset, child) {
                          final bool isCollapsed = _isAppBarCollapsed(
                            scrollOffset,
                          );

                          // Only show this button when we're in expanded state
                          if (isCollapsed) {
                            return const SizedBox.shrink();
                          }

                          return IconButton(
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
                              backgroundColor: Colors.white.withOpacity(0.2),
                            ),
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 1.0.h),

                    // Profile Card
                    Container(
                      margin: EdgeInsets.only(bottom: 2.0.h),
                      padding: EdgeInsets.all(5.0.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardColor.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
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
                                      color: Colors.black.withOpacity(0.2),
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
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  color: Colors.white,
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
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF3949AB),
                                      Color(0xFF1E88E5),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
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
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 2.0.h),

                              // Join Date
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.cake,
                                    size: 18,
                                    color: Colors.grey[600],
                                  ),
                                  SizedBox(width: 1.0.w),
                                  Text(
                                    'Member since ${formatJoinedDate(state.user.joinedDate)}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 2.0.h),

                              // Edit Profile Button
                              ElevatedButton.icon(
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    isScrollControlled: true,
                                    backgroundColor: Colors.transparent,
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
                                                ).scaffoldBackgroundColor,
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(20),
                                                ),
                                          ),
                                          child: BlocProvider.value(
                                            value: BlocProvider.of<UserBloc>(
                                              context,
                                            ),
                                            child: const EditProfileScreen(),
                                          ),
                                        ),
                                  );
                                },
                                icon: const Icon(Icons.edit, size: 18),
                                label: const Text('Edit Profile'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue[700],
                                  foregroundColor: Colors.white,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.0.w,
                                    vertical: 1.2.h,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
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
                color: Colors.black.withOpacity(0.05),
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
                    color: Theme.of(context).primaryColor,
                  ),
                  SizedBox(width: 2.0.w),
                  Text(
                    'About',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),

              Divider(height: 4.0.h),

              // Bio
              Container(
                padding: EdgeInsets.all(3.0.w),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  state.user.about ?? 'No bio added yet.',
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.5,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ),

              SizedBox(height: 3.0.h),

              // Member Since Info
              _buildInfoItem(
                icon: Icons.date_range,
                iconColor: Colors.blue[700]!,
                label: 'Member since',
                value: formatJoinedDate(state.user.joinedDate),
              ),

              SizedBox(height: 2.0.h),

              // Location Info
              _buildInfoItem(
                icon: Icons.location_on,
                iconColor: Colors.red[400]!,
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
          Icon(icon, size: 48, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
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
            const Text(
              'label',
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600],
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
        baseColor: Colors.grey.shade800,
        highlightColor: Colors.grey.shade700,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post title shimmer
            Container(
              height: 14,
              width: 220,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 6),

            // Comment info shimmer (subreddit/time/upvotes)
            Container(
              height: 10,
              width: 160,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 10),

            // Comment body shimmer
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 12,
              width: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
