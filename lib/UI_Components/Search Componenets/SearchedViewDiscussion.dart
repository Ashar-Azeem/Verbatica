// ignore_for_file: file_names, deprecated_member_use

import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Comments%20Bloc/comments_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_state.dart';
import 'package:verbatica/UI_Components/Comment%20Componenets/CommentBlock.dart';
import 'package:verbatica/UI_Components/Search%20Componenets/SearchedPostUI.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/model/Post.dart';

class SearchedViewDiscussion extends StatefulWidget {
  final Post post;
  final int index;
  const SearchedViewDiscussion({
    super.key,
    required this.post,
    required this.index,
  });

  @override
  State<SearchedViewDiscussion> createState() => _SearchedViewDiscussionState();
}

class _SearchedViewDiscussionState extends State<SearchedViewDiscussion>
    with WidgetsBindingObserver {
  late TextEditingController comment;
  final FocusNode _focusNode = FocusNode();
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    comment = TextEditingController();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focusNode.dispose();
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
      create: (context) => CommentsBloc(postId: widget.post.id),
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft,

                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 1.5.w,
                            bottom: 2.w,
                            top: 2.w,
                          ),
                          child: Container(
                            width: 10.w,
                            height: 10.w,
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).colorScheme.surface.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              icon: Center(
                                child: Icon(
                                  Icons.arrow_back,
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  size: 5.w,
                                ),
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                        ),
                      ),
                      SearchedPost(
                        post: widget.post,
                        index: widget.index,
                        onFullView: true,
                      ),

                      BlocBuilder<CommentsBloc, CommentsState>(
                        buildWhen:
                            (previous, current) =>
                                previous.comments != current.comments,
                        builder: (context, state) {
                          return state.initialLoader
                              ? Padding(
                                padding: EdgeInsets.only(top: 10.h),
                                child: Center(
                                  child: LoadingAnimationWidget.dotsTriangle(
                                    color: primaryColor,
                                    size: 10.w,
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
                                      padding: EdgeInsets.only(bottom: 0.6.h),
                                      child: Column(
                                        children: [
                                          Divider(thickness: 0.5),
                                          Center(
                                            child: SizedBox(
                                              width: 100.w,
                                              child: CommentsBlock(
                                                level: 1,
                                                comment: state.comments[index],
                                              ),
                                            ),
                                          ),
                                          Divider(thickness: 0.5),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                        },
                      ),
                    ],
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
                                                Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.color
                                                    ?.withOpacity(0.6) ??
                                                Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withOpacity(0.6),
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
                                            Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.color
                                                ?.withOpacity(0.6) ??
                                            Theme.of(context)
                                                .colorScheme
                                                .onSurface
                                                .withOpacity(0.6),
                                        fontWeight: FontWeight.w300,
                                      ),
                                      linkColor: primaryColor,
                                    ),
                                  ],
                                ),
                              )
                              : SizedBox.shrink(),
                          SizedBox(height: 0.2.h),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                              ),
                              borderRadius: BorderRadius.circular(10.w),
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
                                            previous.user.avatarId !=
                                            current.user.avatarId,
                                    builder: (context, state) {
                                      return CircleAvatar(
                                        radius: 6.w,
                                        backgroundImage: AssetImage(
                                          'assets/Avatars/avatar${state.user.avatarId}.jpg',
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
                                          commentController: comment,
                                          comment: comment.text.trim(),
                                          user:
                                              context
                                                  .read<UserBloc>()
                                                  .state
                                                  .user,
                                          postId: widget.post.id,
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
