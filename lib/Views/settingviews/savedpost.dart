import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Added missing import
import 'package:verbatica/BLOC/User%20bloc/user_bloc.dart';
import 'package:verbatica/BLOC/User%20bloc/user_state.dart';
import 'package:verbatica/UI_Components/PostComponents/PostUI.dart';
import 'package:verbatica/Utilities/Color.dart';
import 'package:verbatica/model/Post.dart';
import 'package:sizer/sizer.dart';

class SavedPostsScreen extends StatelessWidget {
  const SavedPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Make sure both HomeBloc and UserBloc are accessible
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Saved Posts',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          if (userState.savedPosts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmark_border, size: 15.w, color: Colors.grey),
                  SizedBox(height: 2.h),
                  Text(
                    'No saved posts yet',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Posts you save will appear here',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: userState.savedPosts.length,
            itemBuilder: (context, index) {
              final post = userState.savedPosts[index];
              return SavedPostWidget(
                post: post,
                index: index,
                onUnsave: () => _showUnsaveConfirmation(context, post),
              );
            },
          );
        },
      ),
    );
  }

  void _showUnsaveConfirmation(BuildContext context, Post post) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: Color.fromARGB(255, 22, 28, 33),
          title: Text(
            'Remove from saved',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'Are you sure you want to remove this post from your saved list?',
            style: TextStyle(color: Colors.white70),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            TextButton(
              onPressed: () {
                // // Uncomment and use the correct event
                // context.read<HomeBloc>().add(UnsavePost(post: post));
                // // Also update the UserBloc to reflect the change
                // context.read<UserBloc>().add(RemoveSavedPost(post: post));
                Navigator.of(dialogContext).pop();
              },
              child: Text('Remove', style: TextStyle(color: primaryColor)),
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
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.all(1.w),
            child: IconButton(
              icon: Icon(Icons.bookmark, color: primaryColor, size: 7.w),
              onPressed: onUnsave,
              tooltip: 'Remove from saved',
            ),
          ),
        ),
      ],
    );
  }
}
