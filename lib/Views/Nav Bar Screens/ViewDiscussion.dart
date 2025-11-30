// ignore_for_file: file_names, deprecated_member_use

import 'dart:async';

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Comments%20Bloc/comments_bloc.dart';
import 'package:verbatica/BLOC/Home/home_bloc.dart';
import 'package:verbatica/BLOC/Notification/notification_bloc.dart';
import 'package:verbatica/BLOC/Notification/notification_state.dart';
import 'package:verbatica/BLOC/Search%20Bloc/search_bloc.dart';
import 'package:verbatica/BLOC/Trending%20View%20BLOC/trending_view_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_state.dart';
import 'package:verbatica/BLOC/otheruser/otheruser_bloc.dart';
import 'package:verbatica/BLOC/otheruser/otheruser_state.dart';
import 'package:verbatica/BLOC/postsubmit/postsubmit_bloc.dart';
import 'package:verbatica/BLOC/postsubmit/postsubmit_state.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/UI_Components/Comment%20Componenets/CommentBlock.dart';
import 'package:verbatica/UI_Components/PostComponents/EmptyPosts.dart';
import 'package:verbatica/UI_Components/PostComponents/PostUI.dart';
import 'package:verbatica/model/Post.dart';

class ViewDiscussion extends StatefulWidget {
  final Post post;
  final int index;
  final String category;
  final int? newIndex;
  const ViewDiscussion({
    super.key,
    required this.post,
    required this.index,
    required this.category,
    this.newIndex,
  });

  @override
  State<ViewDiscussion> createState() => _ViewDiscussionState();
}

class _ViewDiscussionState extends State<ViewDiscussion>
    with WidgetsBindingObserver {
  late TextEditingController comment;

  final FocusNode _focusNode = FocusNode();
  bool _keyboardVisible = false;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    comment = TextEditingController();
    timer = Timer(Duration(seconds: 5), () {
      if (mounted) {
        ApiService().registerClick(
          int.parse(widget.post.id),
          context.read<UserBloc>().state.user!.id,
        );
      }
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
    timer?.cancel();
    comment.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final isKeyboardNowVisible = bottomInset > 0.0;

    if (isKeyboardNowVisible != _keyboardVisible) {
      _keyboardVisible = isKeyboardNowVisible;

      if (_keyboardVisible) {
        // Only request focus if not already focused
        if (!_focusNode.hasFocus) {
          _focusNode.requestFocus();
        }
      } else {
        // Unfocus only if currently focused
        if (_focusNode.hasFocus) {
          _focusNode.unfocus();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create:
          (context) => CommentsBloc(
            postId: widget.post.id,
            userID: context.read<UserBloc>().state.user!.id,
          ),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 6.h,
          title: Text(
            'Discussion',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          elevation: 0,
          centerTitle: true,
          backgroundColor: Theme.of(context).cardColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.only(top: 1.5.h),
                    child: BlocBuilder<CommentsBloc, CommentsState>(
                      builder: (context, state) {
                        return Column(
                          children: [
                            if (widget.category == 'user')
                              BlocBuilder<UserBloc, UserState>(
                                buildWhen:
                                    (previous, current) =>
                                        previous.userPosts[widget.index] !=
                                        current.userPosts[widget.index],
                                builder: (context, state) {
                                  context.read<CommentsBloc>().add(
                                    UpdateCommentCount(
                                      commentCount:
                                          state
                                              .userPosts[widget.index]
                                              .comments,
                                    ),
                                  );
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 1.w,
                                    ),
                                    child: PostWidget(
                                      post: state.userPosts[widget.index],
                                      index: widget.index,
                                      onFullView: true,
                                      category: widget.category,
                                    ),
                                  );
                                },
                              ),
                            if (widget.category == 'other')
                              BlocBuilder<OtheruserBloc, OtheruserState>(
                                buildWhen:
                                    (previous, current) =>
                                        previous.userPosts[widget.index] !=
                                        current.userPosts[widget.index],

                                builder: (context, state) {
                                  context.read<CommentsBloc>().add(
                                    UpdateCommentCount(
                                      commentCount:
                                          state
                                              .userPosts[widget.index]
                                              .comments,
                                    ),
                                  );
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 1.w,
                                    ),
                                    child: PostWidget(
                                      post: state.userPosts[widget.index],
                                      category: widget.category,
                                      index: widget.index,
                                      onFullView: true,
                                    ),
                                  );
                                },
                              ),
                            if (widget.category == 'saved')
                              BlocBuilder<UserBloc, UserState>(
                                buildWhen:
                                    (previous, current) =>
                                        previous.savedPosts[widget.index] !=
                                        current.savedPosts[widget.index],

                                builder: (context, state) {
                                  context.read<CommentsBloc>().add(
                                    UpdateCommentCount(
                                      commentCount:
                                          state
                                              .savedPosts[widget.index]
                                              .comments,
                                    ),
                                  );
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 1.w,
                                    ),
                                    child: PostWidget(
                                      post: state.savedPosts[widget.index],
                                      index: widget.index,
                                      onFullView: true,
                                      category: widget.category,
                                    ),
                                  );
                                },
                              ),
                            if (widget.category == 'Trending' ||
                                widget.category == 'Top 10 news')
                              BlocBuilder<TrendingViewBloc, TrendingViewState>(
                                builder: (context, state) {
                                  Post dynamicpost;
                                  if (widget.category == 'Trending') {
                                    dynamicpost = state.trending[widget.index];
                                  } else {
                                    dynamicpost =
                                        state
                                            .news[widget.newIndex!]
                                            .discussions[widget.index];
                                  }

                                  context.read<CommentsBloc>().add(
                                    UpdateCommentCount(
                                      commentCount: dynamicpost.comments,
                                    ),
                                  );

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 1.w,
                                    ),
                                    child: PostWidget(
                                      post: dynamicpost,
                                      index: widget.index,
                                      newsIndex: widget.newIndex,
                                      category: widget.category,
                                      onFullView: true,
                                    ),
                                  );
                                },
                              ),

                            if (widget.category == 'ForYou' ||
                                widget.category == 'Following')
                              BlocBuilder<HomeBloc, HomeState>(
                                builder: (context, state) {
                                  Post dynamicpost;
                                  if (widget.category == 'ForYou') {
                                    dynamicpost = state.forYou[widget.index];
                                  } else {
                                    dynamicpost = state.following[widget.index];
                                  }

                                  context.read<CommentsBloc>().add(
                                    UpdateCommentCount(
                                      commentCount: dynamicpost.comments,
                                    ),
                                  );

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 1.w,
                                    ),
                                    child: PostWidget(
                                      post: dynamicpost,
                                      index: widget.index,
                                      category: widget.category,
                                      onFullView: true,
                                    ),
                                  );
                                },
                              ),

                            if (widget.category == 'searched')
                              BlocBuilder<SearchBloc, SearchState>(
                                builder: (context, state) {
                                  Post dynamicpost = state.posts[widget.index];

                                  context.read<CommentsBloc>().add(
                                    UpdateCommentCount(
                                      commentCount: dynamicpost.comments,
                                    ),
                                  );
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 1.w,
                                    ),
                                    child: PostWidget(
                                      post: dynamicpost,
                                      index: widget.index,
                                      category: widget.category,
                                      onFullView: true,
                                    ),
                                  );
                                },
                              ),
                            if (widget.category == 'similarPosts')
                              BlocBuilder<PostBloc, PostState>(
                                builder: (context, state) {
                                  Post dynamicpost =
                                      state.similarPosts[widget.index];

                                  context.read<CommentsBloc>().add(
                                    UpdateCommentCount(
                                      commentCount: dynamicpost.comments,
                                    ),
                                  );

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 1.w,
                                    ),
                                    child: PostWidget(
                                      post: dynamicpost,
                                      index: widget.index,
                                      category: widget.category,
                                      onFullView: true,
                                    ),
                                  );
                                },
                              ),
                            if (widget.category == 'notification')
                              BlocBuilder<NotificationBloc, NotificationState>(
                                builder: (context, state) {
                                  Post dynamicpost =
                                      state.onViewPost ?? widget.post;

                                  // context.read<CommentsBloc>().add(
                                  //   UpdateCommentCount(
                                  //     commentCount: dynamicpost.comments,
                                  //   ),
                                  // );

                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 1.w,
                                    ),
                                    child: PostWidget(
                                      post: dynamicpost,
                                      index: widget.index,
                                      category: widget.category,
                                      onFullView: true,
                                    ),
                                  );
                                },
                              ),
                            SizedBox(height: 1.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 1.5,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                  ),
                                  child: Text(
                                    '${state.totalCommentCount} Comments',
                                    style: TextStyle(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 1.5,
                                    color: Theme.of(context).dividerColor,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1.h),
                            BlocBuilder<CommentsBloc, CommentsState>(
                              buildWhen:
                                  (previous, current) =>
                                      previous.comments != current.comments,
                              builder: (context, state) {
                                return state.initialLoader
                                    ? Padding(
                                      padding: EdgeInsets.only(top: 10.h),
                                      child: Center(
                                        child:
                                            LoadingAnimationWidget.dotsTriangle(
                                              color:
                                                  Theme.of(
                                                    context,
                                                  ).colorScheme.primary,
                                              size: 10.w,
                                            ),
                                      ),
                                    )
                                    : state.comments.isEmpty
                                    ? SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                          0.6,
                                      child: Center(
                                        child: BuildEmptyTabContent(
                                          icon: Icons.article_outlined,
                                          message: 'No comments yet',
                                        ),
                                      ),
                                    )
                                    : Padding(
                                      padding: EdgeInsets.only(bottom: 8.h),
                                      child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: state.comments.length,
                                        itemBuilder: (context, index) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              bottom: 0.6.h,
                                              left: 1.w,
                                              right: 1.w,
                                            ),
                                            child: Card(
                                              child: Center(
                                                child: SizedBox(
                                                  width: 100.w,
                                                  child: CommentsBlock(
                                                    level: 1,
                                                    comment:
                                                        state.comments[index],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),

              Positioned(
                bottom: 0.5.h,
                left: 1.w,
                right: 1.w,
                child: Center(
                  child: BlocBuilder<CommentsBloc, CommentsState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          state.replyToComment != null
                              ? Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Theme.of(context).dividerColor,
                                  ),

                                  color:
                                      isDarkMode
                                          ? const Color(0xFF27343D)
                                          : const Color.fromARGB(
                                            255,
                                            247,
                                            246,
                                            246,
                                          ),
                                ),
                                alignment: Alignment.center,
                                width: 90.w,
                                padding: EdgeInsets.all(2.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Reply to ${state.replyToComment!.author}",
                                          style: TextStyle(
                                            color:
                                                Theme.of(
                                                  context,
                                                ).textTheme.bodyLarge?.color ??
                                                Theme.of(
                                                  context,
                                                ).colorScheme.onSurface,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 4.w,
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            context.read<CommentsBloc>().add(
                                              RemoveSelectComment(),
                                            );
                                          },
                                          child: Icon(
                                            Icons.highlight_remove_rounded,
                                            color:
                                                Theme.of(
                                                  context,
                                                ).colorScheme.secondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ExpandableText(
                                      state.replyToComment!.text,
                                      expandOnTextTap: true,
                                      collapseOnTextTap: true,
                                      expandText: 'show more',
                                      collapseText: 'show less',
                                      linkEllipsis: false,
                                      maxLines: 4,
                                      style: TextStyle(
                                        fontSize: 3.8.w,
                                        color:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyMedium?.color ??
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                        fontWeight: FontWeight.w300,
                                      ),
                                      linkColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ],
                                ),
                              )
                              : SizedBox.shrink(),
                          SizedBox(height: 0.2.h),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.w),
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),

                              color:
                                  isDarkMode
                                      ? const Color(0xFF27343D)
                                      : const Color.fromARGB(
                                        255,
                                        247,
                                        246,
                                        246,
                                      ),
                            ),
                            alignment: Alignment.center,
                            width: 96.w,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(1.w),
                                  child: BlocBuilder<UserBloc, UserState>(
                                    buildWhen:
                                        (previous, current) =>
                                            previous.user!.avatarId !=
                                            current.user!.avatarId,
                                    builder: (context, state) {
                                      return CircleAvatar(
                                        radius: 6.w,
                                        backgroundImage: AssetImage(
                                          'assets/Avatars/avatar${state.user!.avatarId}.jpg',
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 3.w, right: 0),
                                  child: SizedBox(
                                    width: 65.w,
                                    child: TextField(
                                      focusNode: _focusNode,
                                      maxLines: 5,
                                      expands: false,
                                      minLines: 1,
                                      cursorColor:
                                          Theme.of(context).colorScheme.primary,
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodyLarge?.color ??
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      controller: comment,
                                      autocorrect: false,
                                      enableSuggestions: true,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Comment...',
                                        hintStyle: TextStyle(
                                          color:
                                              Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium
                                                  ?.color
                                                  ?.withOpacity(0.6) ??
                                              Theme.of(context)
                                                  .colorScheme
                                                  .onSurface
                                                  .withOpacity(0.6),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (comment.text.trim().isNotEmpty) {
                                      context.read<CommentsBloc>().add(
                                        UploadComment(
                                          context: context,
                                          commentController: comment,
                                          titleOfThePost: widget.post.title,
                                          clusters: widget.post.clusters,
                                          comment: comment.text.trim(),
                                          user:
                                              context
                                                  .read<UserBloc>()
                                                  .state
                                                  .user!,
                                          postId: widget.post.id,
                                          index: widget.index,
                                          category: widget.category,
                                          postDescription:
                                              widget.post.description,
                                          isAutomatedClusters:
                                              widget.post.isAutomatedClusters,
                                          newsIndex: widget.newIndex,
                                        ),
                                      );
                                    }
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      left: state.commentLoading ? 5.w : 2.w,
                                    ),
                                    child:
                                        state.commentLoading
                                            ? Center(
                                              child:
                                                  LoadingAnimationWidget.staggeredDotsWave(
                                                    color:
                                                        Theme.of(
                                                          context,
                                                        ).colorScheme.primary,
                                                    size: 5.w,
                                                  ),
                                            )
                                            : Center(
                                              child: Icon(
                                                Icons.send,
                                                color:
                                                    Theme.of(
                                                      context,
                                                    ).colorScheme.primary,
                                                size: 5.w,
                                              ),
                                            ),
                                  ),
                                ),
                              ],
                            ),
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
}
