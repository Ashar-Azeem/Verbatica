// ignore_for_file: file_names, camel_case_types
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/otheruser/otheruser_bloc.dart';
import 'package:verbatica/BLOC/otheruser/otheruser_state.dart';
import 'package:verbatica/UI_Components/PostComponents/otheruserpostui.dart';
import 'package:verbatica/Utilities/dateformat.dart';
import 'package:verbatica/model/Post.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:verbatica/model/user.dart';

class otherProfileView extends StatefulWidget {
  const otherProfileView({required this.post, this.user, super.key});
  final Post post;
  final User? user;
  @override
  State<otherProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<otherProfileView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final double expandedHeight = 62.0.h; // AppBar height + TabBar height
  late final ValueNotifier<double> _scrollNotifier;

  @override
  void initState() {
    super.initState();
    context.read<OtheruserBloc>().add(fetchUserinfo(Userid: widget.post.id));
    context.read<OtheruserBloc>().add(FetchUserPosts());
    context.read<OtheruserBloc>().add(updateCommentWithPost());
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

  // Implementation for user posts tab similar to ProfileView
  Widget buildUserPostsTab(OtheruserState state) {
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
      padding: EdgeInsets.only(bottom: 16.0.h), // Added bottom padding
      itemCount: state.userPosts.length,
      itemBuilder: (context, index) {
        final post = state.userPosts[index];
        return PostTile(post: post, index: index);
      },
    );
  }

  // Implementation for user comments tab similar to ProfileView
  Widget buildUserCommentsTab(OtheruserState state) {
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
      return _buildEmptyTabContent(
        icon: Icons.chat_bubble_outline,
        message: 'No comments yet',
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
            ],
          ),
        );
      },
    );
  }

  bool _isAppBarCollapsed(double shrinkOffset) {
    // Simpler condition to determine when to show the collapsed state
    return shrinkOffset > 40.h; // Fixed threshold that works reliably
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  title: BlocBuilder<OtheruserBloc, OtheruserState>(
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
                                      padding: EdgeInsets.only(
                                        left: 2.w,
                                        bottom: 2.w,
                                      ),
                                      color:
                                          isDarkMode
                                              ? Color.fromARGB(255, 10, 13, 15)
                                              : Colors.white,
                                      height: 20.h,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 6.w,
                                            backgroundImage: AssetImage(
                                              'assets/Avatars/avatar${widget.post.avatar}.jpg',
                                            ),
                                          ),
                                          // Username in collapsed state
                                          Spacer(),
                                          SizedBox(
                                            width: 40.w,
                                            child: Text(
                                              widget.post.name,
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
                                          Spacer(flex: 8),
                                          // Settings button in collapsed state
                                          IconButton(
                                            icon: Icon(
                                              Icons.message,
                                              size: 5.w,
                                            ),
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    )
                                    : SizedBox.shrink(),
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
              BlocBuilder<OtheruserBloc, OtheruserState>(
                builder: (context, state) {
                  return buildUserPostsTab(state);
                },
              ),

              // Comments Tab
              BlocBuilder<OtheruserBloc, OtheruserState>(
                builder: (context, state) {
                  return buildUserCommentsTab(state);
                },
              ),

              // About Tab
              SingleChildScrollView(
                padding: EdgeInsets.all(5.0.w),
                child: Container(
                  padding: EdgeInsets.all(5.0.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).shadowColor.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: BlocBuilder<OtheruserBloc, OtheruserState>(
                    builder: (context, state) {
                      return Column(
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
                              ).colorScheme.surface.withOpacity(0.5),
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
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

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
                                    alignment: Alignment.topLeft,
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                        Icons.arrow_back_ios_new_outlined,
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
                                          ).shadowColor.withOpacity(0.2),
                                          blurRadius: 10,
                                          offset: const Offset(0, 5),
                                        ),
                                      ],
                                    ),
                                    child: BlocBuilder<
                                      OtheruserBloc,
                                      OtheruserState
                                    >(
                                      builder: (context, state) {
                                        return Column(
                                          children: [
                                            // Avatar
                                            Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                  color:
                                                      Theme.of(
                                                        context,
                                                      ).colorScheme.surface,
                                                  width: 3,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Theme.of(context)
                                                        .shadowColor
                                                        .withOpacity(0.3),
                                                    blurRadius: 8,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: CircleAvatar(
                                                radius: 8.0.h,
                                                backgroundImage: AssetImage(
                                                  'assets/Avatars/avatar${widget.post.avatar}.jpg',
                                                ),
                                              ),
                                            ),

                                            SizedBox(height: 2.0.h),

                                            // Username
                                            Text(
                                              widget.post.name,
                                              style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                                color:
                                                    Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge
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
                                                        .withOpacity(0.7),
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

                                            SizedBox(height: 3.0.h),

                                            // Action Buttons
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Follow Button
                                                Expanded(
                                                  child: ElevatedButton.icon(
                                                    onPressed: () {},
                                                    icon: const Icon(
                                                      Icons.person_add,
                                                      size: 18,
                                                    ),
                                                    label: const Text('Follow'),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          Theme.of(
                                                            context,
                                                          ).colorScheme.primary,
                                                      foregroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .onPrimary,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            vertical: 1.2.h,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              30,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 3.0.w),
                                                // Message Button
                                                Expanded(
                                                  child: ElevatedButton(
                                                    onPressed: () {},
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                          isDarkMode
                                                              ? Colors.grey[600]
                                                              : Colors
                                                                  .grey[400],
                                                      foregroundColor:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .bodyLarge
                                                              ?.color,
                                                      padding:
                                                          EdgeInsets.symmetric(
                                                            horizontal: 4.0.w,
                                                            vertical: 1.2.h,
                                                          ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              30,
                                                            ),
                                                      ),
                                                    ),
                                                    child: const Icon(
                                                      Icons.message,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ],
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

// Adding these component classes from the ProfileView implementation
class CommentShimmerTile extends StatelessWidget {
  const CommentShimmerTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Shimmer.fromColors(
        baseColor: Theme.of(context).colorScheme.surface.withOpacity(0.3),
        highlightColor: Theme.of(context).colorScheme.surface.withOpacity(0.1),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Post title shimmer
            Container(
              height: 14,
              width: 220,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 6),

            // Comment info shimmer (subreddit/time/upvotes)
            Container(
              height: 10,
              width: 160,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 10),

            // Comment body shimmer
            Container(
              height: 12,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              height: 12,
              width: MediaQuery.of(context).size.width * 0.75,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostTile extends StatelessWidget {
  final Post post;
  final int index;
  const PostTile({super.key, required this.index, required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).dividerColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: OtherUserPostWidget(post: post, index: index, onFullView: false),
    );
  }
}

class PostShimmerTile extends StatelessWidget {
  const PostShimmerTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade800,
        highlightColor: Colors.grey.shade700,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title shimmer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 18,
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const CircleAvatar(radius: 12, backgroundColor: Colors.grey),
                ],
              ),
              const SizedBox(height: 12),

              // Content shimmer
              Container(
                height: 14,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 14,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: 14,
                width: MediaQuery.of(context).size.width * 0.5,
                decoration: BoxDecoration(
                  color: Colors.grey.shade800,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 16),

              // Stats shimmer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 12,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 12,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    height: 10,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
