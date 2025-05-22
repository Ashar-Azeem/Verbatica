// ignore_for_file: file_names, camel_case_types
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Home/home_bloc.dart';
import 'package:verbatica/BLOC/otheruser/otheruser_bloc.dart';
import 'package:verbatica/BLOC/otheruser/otheruser_state.dart';
import 'package:verbatica/Utilities/dateformat.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Home%20View%20Screens/ViewDiscussion.dart';
import 'package:verbatica/model/Post.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_text/expandable_text.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;

class otherProfileView extends StatefulWidget {
  const otherProfileView({required this.post, super.key});
  final Post post;
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
            ],
          ),
        );
      },
    );
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
                  title: BlocBuilder<OtheruserBloc, OtheruserState>(
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
                                  // Back button in collapsed state
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios,
                                      size: 20,
                                    ),
                                  ),
                                  // Username in collapsed state
                                  Expanded(
                                    child: Text(
                                      widget.post.name,
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleLarge?.color ??
                                            Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  // Empty space to balance the back button
                                  const SizedBox(width: 48),
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
                        color: Colors.black.withOpacity(0.05),
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
                              state.user?.about ?? 'No bio added yet.',
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
                            value: formatJoinedDate(
                              state.user?.joinedDate ?? DateTime.now(),
                            ),
                          ),

                          SizedBox(height: 2.0.h),

                          // Location Info
                          _buildInfoItem(
                            icon: Icons.location_on,
                            iconColor: Colors.red[400]!,
                            label: 'Location',
                            value: state.user?.country ?? 'Unknown',
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
              // Top Section with Back Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                child: ValueListenableBuilder<double>(
                  valueListenable: _scrollNotifier,
                  builder: (context, scrollOffset, child) {
                    final bool isCollapsed = _isAppBarCollapsed(scrollOffset);

                    // Only show this button when we're in expanded state
                    if (isCollapsed) {
                      return const SizedBox.shrink();
                    }

                    return IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        color: Colors.white,
                        size: 20,
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.0.w),
                child: Container(
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
                  child: BlocBuilder<OtheruserBloc, OtheruserState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          // Avatar
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 3),
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
                                'assets/Avatars/avatar${widget.post.avatar}.jpg',
                              ),
                            ),
                          ),

                          SizedBox(height: 2.0.h),

                          // Username
                          Text(
                            widget.post.name,
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
                                colors: [Color(0xFF3949AB), Color(0xFF1E88E5)],
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
                                  '${state.user?.karma ?? 0} Aura',
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
                                'Member since ${formatJoinedDate(state.user?.joinedDate ?? DateTime.now())}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 3.0.h),

                          // Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Follow Button
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.person_add, size: 18),
                                  label: const Text('Follow'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue[700],
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 1.2.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
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
                                    backgroundColor: Colors.grey[800],
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.0.w,
                                      vertical: 1.2.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: const Icon(Icons.message, size: 20),
                                ),
                              ),
                            ],
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
      ],
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
            Text(
              label,
              style: const TextStyle(fontSize: 12, color: Colors.white),
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

// Adding these component classes from the ProfileView implementation
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

class PostTile extends StatelessWidget {
  final Post post;
  final int index;
  const PostTile({Key? key, required this.index, required this.post})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        pushScreen(
          context,
          pageTransitionAnimation: PageTransitionAnimation.scale,
          screen: MultiBlocProvider(
            providers: [
              BlocProvider<HomeBloc>(create: (_) => context.read<HomeBloc>()),
            ],
            child: ViewDiscussion(post: post, index: 0, category: 'profile'),
          ),
          withNavBar: false,
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor.withOpacity(0.7),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title
                  Expanded(
                    child: Text(
                      post.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Post content with expandable text
            if (post.description.isNotEmpty)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: ExpandableText(
                  post.description,
                  expandOnTextTap: true,
                  collapseOnTextTap: true,
                  expandText: 'show more',
                  collapseText: 'show less',
                  linkEllipsis: false,
                  maxLines: 3,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[300],
                    height: 1.4,
                  ),
                  linkColor: Colors.blue,
                ),
              ),

            // Post image if available (using CachedNetworkImage)
            if (post.postImageLink != null)
              CachedNetworkImage(
                imageUrl: post.postImageLink!,
                placeholder:
                    (context, url) => Shimmer.fromColors(
                      baseColor: const Color.fromARGB(255, 58, 76, 90),
                      highlightColor: const Color.fromARGB(255, 81, 106, 125),
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
                fit: BoxFit.cover,
              ),

            // Stats and metadata
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Interaction stats (upvotes, downvotes, comments)
                  Row(
                    children: [
                      // Upvotes
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_circle_up_outlined,
                            size: 5.w,
                            color: post.isUpVote ? Colors.blue : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${post.upvotes}',
                            style: TextStyle(
                              color: post.isUpVote ? Colors.blue : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 4.w),
                      // Downvotes
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_circle_down_outlined,
                            size: 5.w,
                            color: post.isDownVote ? Colors.blue : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${post.downvotes}',
                            style: TextStyle(
                              color:
                                  post.isDownVote ? Colors.blue : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 4.w),
                      // Comments
                      Row(
                        children: [
                          Icon(
                            Icons.mode_comment_outlined,
                            size: 5.w,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${post.comments}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Debate/Analytics indicator if applicable
                  if (post.isDebate)
                    Icon(
                      Icons.analytics_outlined,
                      size: 5.w,
                      color: Colors.blue,
                    ),

                  // Timestamp
                  Text(
                    timeago.format(post.uploadTime),
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostShimmerTile extends StatelessWidget {
  const PostShimmerTile({Key? key}) : super(key: key);

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
