// ignore_for_file: file_names, unused_element
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_state.dart';
import 'package:verbatica/UI_Components/PostComponents/PostUI.dart';
import 'package:verbatica/UI_Components/PostComponents/userpostUI.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/model/Post.dart';

class SavedPostsScreen extends StatelessWidget {
  const SavedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.textTheme.bodyLarge?.color),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Icon(Icons.bookmark, color: theme.colorScheme.primary, size: 6.w),
            SizedBox(width: 2.w),
            Text(
              'Saved Posts',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        centerTitle: false,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state.isLoadingPosts) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      theme.colorScheme.primary,
                    ),
                    strokeWidth: 3,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Loading saved posts...',
                    style: TextStyle(
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(
                        0.7,
                      ),
                      fontSize: 3.5.w,
                    ),
                  ),
                ],
              ),
            );
          }

          if (state.savedPosts.isEmpty) {
            return Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                padding: EdgeInsets.all(6.w),
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.dividerColor.withOpacity(0.3),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.colorScheme.primary.withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.bookmark_outline,
                        size: 12.w,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'No Saved Posts Yet',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Start saving posts that interest you!\nThey will appear here for easy access.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withOpacity(
                          0.7,
                        ),
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.5.w,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary.withOpacity(0.8),
                            theme.colorScheme.primary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        'Explore Posts',
                        style: TextStyle(
                          color: theme.colorScheme.onPrimary,
                          fontSize: 3.5.w,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Container(
            margin: EdgeInsets.symmetric(horizontal: 2.w),
            child: Column(
              children: [
                // Header with count
                Container(
                  margin: EdgeInsets.only(
                    top: 2.h,
                    bottom: 1.h,
                    left: 2.w,
                    right: 2.w,
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.dividerColor.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: theme.shadowColor.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.bookmark,
                          color: theme.colorScheme.primary,
                          size: 5.w,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${state.savedPosts.length} Saved Posts',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Your bookmarked content',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.textTheme.bodySmall?.color
                                    ?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.5.w,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: theme.colorScheme.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          '${state.savedPosts.length}',
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontSize: 3.2.w,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Posts List
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.only(top: 2.h, bottom: 2.h),
                      itemCount: state.savedPosts.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.only(bottom: 1.h),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: theme.dividerColor.withOpacity(0.3),
                              width: 0.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: theme.shadowColor.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: UserPostWidget(
                            post: state.savedPosts[index],
                            index: index,
                            category: 'saved',
                            onFullView: false,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showUnsaveConfirmation(BuildContext context, Post post) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: theme.dialogBackgroundColor,
          title: Text('Remove from saved', style: theme.textTheme.titleMedium),
          content: Text(
            'Are you sure you want to remove this post from your saved list?',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                // // Uncomment and use the correct event
                // context.read<HomeBloc>().add(UnsavePost(post: post));
                // // Also update the UserBloc to reflect the change
                // context.read<UserBloc>().add(RemoveSavedPost(post: post));
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                'Remove',
                style: TextStyle(color: theme.colorScheme.primary),
              ),
            ),
          ],
        );
      },
    );
  }
}

class SavedPostWidget extends StatelessWidget {
  final Post post;
  final int index;
  final VoidCallback onUnsave;

  const SavedPostWidget({
    required this.post,
    required this.index,
    required this.onUnsave,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      children: [
        // Wrap with a SizedBox or Container to constrain width
        PostWidget(
          post: post,
          index: index,
          category: 'SavedPosts', // Custom category for saved posts
          onFullView: false,
        ),
        // Save button overlay
        Positioned(
          top: 8.h,
          right: 2.w,
          child: Container(
            decoration: BoxDecoration(
              color: theme.shadowColor.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(1.w),
            child: IconButton(
              icon: Icon(
                Icons.bookmark,
                color: theme.colorScheme.primary,
                size: 7.w,
              ),
              onPressed: onUnsave,
              tooltip: 'Remove from saved',
            ),
          ),
        ),
      ],
    );
  }
}
