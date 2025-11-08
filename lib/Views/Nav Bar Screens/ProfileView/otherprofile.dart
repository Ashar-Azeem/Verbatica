// ignore_for_file: file_names, camel_case_types
import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/otheruser/otheruser_bloc.dart';
import 'package:verbatica/BLOC/otheruser/otheruser_state.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/UI_Components/PostComponents/EmptyPosts.dart';
import 'package:verbatica/UI_Components/PostComponents/PostUI.dart';
import 'package:verbatica/UI_Components/PostComponents/ShimmerLoader.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/Utilities/ErrorSnackBar.dart';
import 'package:verbatica/Utilities/dateformat.dart';
import 'package:verbatica/Utilities/loadingAnimationOfCustomSize.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/Home%20View%20Screens/Chats%20And%20Messaging%20Views/MessageView.dart';
import 'package:verbatica/model/Chat.dart';
import 'package:verbatica/model/Post.dart';
import 'package:shimmer/shimmer.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:verbatica/model/user.dart';

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
  final double expandedHeight = 62.0.h;
  late final OtheruserBloc otherUserBloc;
  late final ValueNotifier<double> _scrollNotifier;
  late final User user;
  @override
  void initState() {
    super.initState();
    user = context.read<UserBloc>().state.user!;
    otherUserBloc = context.read<OtheruserBloc>();
    context.read<OtheruserBloc>().add(
      fetchUserinfo(otherUserId: widget.post.userId, myUserId: user.id),
    );
    context.read<OtheruserBloc>().add(
      FetchUserPosts(userId: widget.post.userId, ownerUserId: user.id),
    );
    context.read<OtheruserBloc>().add(
      updateCommentWithPost(widget.post.userId, visitingUserId: user.id),
    );
    _tabController = TabController(length: 3, vsync: this);
    _scrollNotifier = ValueNotifier(0.0);
    _scrollController.addListener(_updateScrollNotifier);
  }

  void _updateScrollNotifier() {
    _scrollNotifier.value = _scrollController.offset;
  }

  @override
  void dispose() {
    otherUserBloc.add(clearBloc());
    _scrollController.removeListener(_updateScrollNotifier);
    _scrollNotifier.dispose();
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  bool _isAppBarCollapsed(double shrinkOffset) {
    // Simpler condition to determine when to show the collapsed state
    return shrinkOffset > 40.h; // Fixed threshold that works reliably
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<OtheruserBloc, OtheruserState>(
      listenWhen:
          (previous, current) =>
              previous.attemptsInOneGo != current.attemptsInOneGo,
      listener: (context, state) {
        if (state.attemptsInOneGo > 2) {
          CustomSnackbar.showError(
            context,
            "Easy there! You can’t do this action repeatedly in a short time.",
          );
        }
      },

      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: DefaultTabController(
          length: 3,
          child: ExtendedNestedScrollView(
            pinnedHeaderSliverHeightBuilder: () => 18.h,
            onlyOneScrollInBody: true,
            controller: _scrollController,
            headerSliverBuilder: (
              BuildContext context,
              bool innerBoxIsScrolled,
            ) {
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
                            final isCollapsed = _isAppBarCollapsed(
                              scrollOffset,
                            );
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
                                                ? Color.fromARGB(
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
                                Icon(Icons.article, size: 16),
                                SizedBox(width: 8),
                                Text('Posts'),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.comment, size: 16),
                                SizedBox(width: 8),
                                Text('Comments'),
                              ],
                            ),
                          ),
                          Tab(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person, size: 16),
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
                            width: 2.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          insets: EdgeInsets.symmetric(horizontal: 100.w / 4),
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
                    return BuildUserPostsTab(
                      state: state,
                      ownerUserId: user.id,
                    );
                  },
                ),

                // Comments Tab
                BlocBuilder<OtheruserBloc, OtheruserState>(
                  builder: (context, state) {
                    return BuildUserCommentTab(state: state);
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
                        return state.isProfileLoading
                            ? LoadingAnimationOfCustomSize(
                              child: Container(
                                height: 20.h,
                                width: 20.w,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                            )
                            : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // About Section Header
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person_outline,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    SizedBox(width: 2.0.w),
                                    Text(
                                      'About',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Theme.of(
                                              context,
                                            ).colorScheme.primary,
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
                                    state.user!.about,
                                    style: TextStyle(
                                      fontSize: 15,
                                      height: 1.5,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.color
                                          ?.withOpacity(0.8),
                                    ),
                                  ),
                                ),

                                SizedBox(height: 3.0.h),

                                // Member Since Info
                                _buildInfoItem(
                                  icon: Icons.date_range,
                                  iconColor: Colors.blue[700]!,
                                  label: 'Member since',
                                  isLocation: false,
                                  user: state.user!,
                                ),

                                SizedBox(height: 2.0.h),

                                // Location Info
                                _buildInfoItem(
                                  icon: Icons.location_on,
                                  iconColor: Colors.red[400]!,
                                  label: 'Location',
                                  isLocation: true,
                                  user: state.user!,
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
                                            state.isProfileLoading
                                                ? LoadingAnimationOfCustomSize(
                                                  child: Container(
                                                    height: 4.3.h,
                                                    width: 20.w,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            20,
                                                          ),
                                                    ),
                                                  ),
                                                )
                                                : Container(
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
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const Icon(
                                                        Icons.auto_awesome,
                                                        color: Colors.amber,
                                                        size: 20,
                                                      ),
                                                      SizedBox(width: 1.0.w),
                                                      Text(
                                                        state.user!.aura >= 1000
                                                            ? (state.user!.aura /
                                                                            1000) %
                                                                        1 ==
                                                                    0
                                                                ? '${(state.user!.aura / 1000).toInt().toString()}k Aura'
                                                                : '${(state.user!.aura / 1000).toStringAsFixed(1)}k Aura'
                                                            : '${state.user!.aura} Aura',
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
                                            state.isProfileLoading
                                                ? LoadingAnimationOfCustomSize(
                                                  child: Container(
                                                    height: 1.6.h,
                                                    width: 60.w,
                                                    decoration: BoxDecoration(
                                                      color: Colors.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            10,
                                                          ),
                                                    ),
                                                  ),
                                                )
                                                :
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
                                                      'Member since ${formatJoinedDate(state.user!.joinDate)}',
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
                                                state.isProfileLoading
                                                    ? Expanded(
                                                      child: LoadingAnimationOfCustomSize(
                                                        child: ElevatedButton.icon(
                                                          onPressed: () {},
                                                          icon: const Icon(
                                                            Icons.person_add,
                                                            size: 18,
                                                          ),
                                                          label: const Text(
                                                            'Follow',
                                                          ),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .primary,
                                                            foregroundColor:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .onPrimary,
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  vertical:
                                                                      1.2.h,
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
                                                    )
                                                    : Expanded(
                                                      child: ElevatedButton.icon(
                                                        onPressed: () {
                                                          //Following and unfollowing a user
                                                          int myUserId =
                                                              context
                                                                  .read<
                                                                    UserBloc
                                                                  >()
                                                                  .state
                                                                  .user!
                                                                  .id;
                                                          context
                                                              .read<
                                                                OtheruserBloc
                                                              >()
                                                              .add(
                                                                UpdateRelationship(
                                                                  myUserId:
                                                                      myUserId,
                                                                  otherUserId:
                                                                      widget
                                                                          .post
                                                                          .userId,
                                                                ),
                                                              );
                                                        },
                                                        icon: Icon(
                                                          state.isFollowedByMe!
                                                              ? Icons
                                                                  .person_remove
                                                              : Icons
                                                                  .person_add,
                                                          size: 18,
                                                        ),
                                                        label: Text(
                                                          state.isFollowedByMe!
                                                              ? 'Following'
                                                              : 'Follow',
                                                        ),
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              Theme.of(context)
                                                                  .colorScheme
                                                                  .primary,
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
                                                state.isProfileLoading
                                                    ? Expanded(
                                                      child: LoadingAnimationOfCustomSize(
                                                        child: ElevatedButton.icon(
                                                          onPressed: () {},
                                                          icon: const Icon(
                                                            Icons.person_add,
                                                            size: 18,
                                                          ),
                                                          label: const Text(
                                                            'Follow',
                                                          ),
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .primary,
                                                            foregroundColor:
                                                                Theme.of(
                                                                      context,
                                                                    )
                                                                    .colorScheme
                                                                    .onPrimary,
                                                            padding:
                                                                EdgeInsets.symmetric(
                                                                  vertical:
                                                                      1.2.h,
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
                                                    )
                                                    : Expanded(
                                                      child: ElevatedButton(
                                                        onPressed: () async {
                                                          Chat? chat;
                                                          try {
                                                            chat = await ApiService()
                                                                .checkAndFetchChat(
                                                                  user.id,
                                                                  widget
                                                                      .post
                                                                      .userId,
                                                                );
                                                            if (chat != null) {
                                                              pushScreen(
                                                                context,
                                                                screen:
                                                                    MessageView(
                                                                      chat:
                                                                          chat,
                                                                    ),
                                                              );
                                                              return;
                                                            } else {
                                                              //creating dummy chat to emulate the actual behaviour
                                                              chat = Chat(
                                                                chatId: "",
                                                                participantIds: [
                                                                  user.id,
                                                                  widget
                                                                      .post
                                                                      .userId,
                                                                ],
                                                                lastUpdated:
                                                                    DateTime.now(),
                                                                lastMessageSeenBy: {
                                                                  user.id: true,
                                                                  widget
                                                                          .post
                                                                          .userId:
                                                                      false,
                                                                },
                                                                userProfiles: {
                                                                  user.id:
                                                                      user.avatarId,
                                                                  widget
                                                                          .post
                                                                          .userId:
                                                                      widget
                                                                          .post
                                                                          .avatar,
                                                                },
                                                                userNames: {
                                                                  user.id:
                                                                      user.userName,
                                                                  widget
                                                                          .post
                                                                          .userId:
                                                                      widget
                                                                          .post
                                                                          .name,
                                                                },
                                                                publicKeys: {
                                                                  user.id:
                                                                      user.publicKey,
                                                                  widget
                                                                          .post
                                                                          .userId:
                                                                      widget
                                                                          .post
                                                                          .publicKey,
                                                                },
                                                                lastMessage: "",
                                                              );
                                                              pushScreen(
                                                                context,
                                                                screen:
                                                                    MessageView(
                                                                      chat:
                                                                          chat,
                                                                    ),
                                                              );
                                                            }
                                                          } catch (e) {
                                                            CustomSnackbar.showError(
                                                              context,
                                                              e.toString(),
                                                            );
                                                          }
                                                        },
                                                        style: ElevatedButton.styleFrom(
                                                          backgroundColor:
                                                              isDarkMode
                                                                  ? Colors
                                                                      .grey[600]
                                                                  : Colors
                                                                      .grey[400],
                                                          foregroundColor:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyLarge
                                                                  ?.color,
                                                          padding:
                                                              EdgeInsets.symmetric(
                                                                horizontal:
                                                                    4.0.w,
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

  Widget _buildInfoItem({
    required IconData icon,
    required Color iconColor,
    required String label,
    required bool isLocation,
    required User user,
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
              isLocation ? user.country : formatJoinedDate(user.joinDate),
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

// posts view
class BuildUserPostsTab extends StatefulWidget {
  final OtheruserState state;
  final int ownerUserId;
  const BuildUserPostsTab({
    super.key,
    required this.state,
    required this.ownerUserId,
  });

  @override
  State<BuildUserPostsTab> createState() => _BuildUserPostsTab();
}

class _BuildUserPostsTab extends State<BuildUserPostsTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    // Loading state
    if (widget.state.isLoadingPosts) {
      return ListView.builder(
        padding: EdgeInsets.only(top: 2.h, bottom: 16.0.h),
        itemCount: 5,
        itemBuilder: (_, __) => const PostShimmerTile(),
      );
    }

    // Empty state
    if (widget.state.userPosts.isEmpty) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: BuildEmptyTabContent(
                icon: Icons.article_outlined,
                message: 'No posts yet',
              ),
            ),
          ),
        ],
      );
    }

    // Content
    return ListView.builder(
      key: const PageStorageKey('posts'),
      padding: EdgeInsets.only(top: 2.h, left: 1.w, right: 1.w, bottom: 16.0.h),
      itemCount:
          widget.state.userPosts.length + (widget.state.isMorePost ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == widget.state.userPosts.length) {
          context.read<OtheruserBloc>().add(
            FetchMorePosts(ownerUserId: widget.ownerUserId),
          );
          return Padding(
            padding: EdgeInsetsGeometry.symmetric(vertical: 3.h),
            child: LoadingAnimationWidget.dotsTriangle(
              color: primaryColor,
              size: 10.w,
            ),
          );
        }
        final post = widget.state.userPosts[index];

        return PostWidget(
          post: post,
          index: index,
          onFullView: false,
          category: 'other',
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// comments view
class BuildUserCommentTab extends StatefulWidget {
  final OtheruserState state;
  const BuildUserCommentTab({super.key, required this.state});

  @override
  State<BuildUserCommentTab> createState() => _BuildUserCommentsTab();
}

class _BuildUserCommentsTab extends State<BuildUserCommentTab>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);

    // Loading state
    if (widget.state.isLoadingComments) {
      return ListView.builder(
        padding: EdgeInsets.only(bottom: 16.0.h),
        itemCount: 5,
        itemBuilder: (_, __) => const CommentShimmerTile(),
      );
    }

    // Empty state
    if (widget.state.userComments.isEmpty) {
      return ListView(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Center(
              child: Text(
                "No comments yet",
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Content
    return ListView.builder(
      key: const PageStorageKey('comment'),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      itemCount: widget.state.userComments.length,
      itemBuilder: (context, index) {
        final comment = widget.state.userComments[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                comment.titleOfThePost,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              Text(
                '${comment.text}    \n• ${timeago.format(comment.uploadTime)}',
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

  @override
  bool get wantKeepAlive => true;
}
