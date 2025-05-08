import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:verbatica/BLOC/Notification/notification_bloc.dart';
import 'package:verbatica/BLOC/Notification/notification_event.dart';
import 'package:verbatica/BLOC/Notification/notification_state.dart';
import 'package:verbatica/model/notification.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              NotificationBloc()..add(
                LoadNotifications([
                  AppNotification(
                    notificationId: 'notif_1',
                    postId: 'post_101',
                    commentId: '',
                    senderUsername: 'historybuff',
                    receiverUsername: 'currentUser',
                    isPostNotification: true,
                    isCommentNotification: false,
                    isUpvoteNotification: false,
                    isReplyNotification: false,
                    title: 'u/historybuff mentioned you in a post',
                    description:
                        'Check out this historical analysis of the partition era...',
                    createdAt: DateTime.now().subtract(
                      const Duration(minutes: 15),
                    ),
                    isRead: false,
                    avatarId: 3,
                  ),
                  AppNotification(
                    notificationId: 'notif_2',
                    postId: 'post_89',
                    commentId: 'comment_45',
                    senderUsername: 'debateMaster',
                    receiverUsername: 'currentUser',
                    isPostNotification: false,
                    isCommentNotification: false,
                    isUpvoteNotification: false,
                    isReplyNotification: true,
                    title:
                        'u/debateMaster replied to your comment in r/PakHistory',
                    description: 'Actually, the census data from 1947 shows...',
                    createdAt: DateTime.now().subtract(
                      const Duration(hours: 2),
                    ),
                    isRead: true,
                    avatarId: 7,
                  ),
                  AppNotification(
                    notificationId: 'notif_3',
                    postId: 'post_56',
                    commentId: '',
                    senderUsername: '',
                    receiverUsername: 'currentUser',
                    isPostNotification: false,
                    isCommentNotification: false,
                    isUpvoteNotification: true,
                    isReplyNotification: false,
                    title: '15 upvotes!',
                    description:
                        'Your post "Economic Growth 2023 Analysis" is gaining traction',
                    createdAt: DateTime.now().subtract(
                      const Duration(hours: 5),
                    ),
                    isRead: false,
                    avatarId: 1, // Default for system notifications
                  ),
                  AppNotification(
                    notificationId: 'notif_4',
                    postId: 'post_112',
                    commentId: 'comment_78',
                    senderUsername: 'factChecker42',
                    receiverUsername: 'currentUser',
                    isPostNotification: false,
                    isCommentNotification: true,
                    isUpvoteNotification: false,
                    isReplyNotification: false,
                    title: 'u/factChecker42 commented on your post',
                    description:
                        'I found some discrepancies in your sources. Table 3 actually shows...',
                    createdAt: DateTime.now().subtract(const Duration(days: 1)),
                    isRead: true,
                    avatarId: 5,
                  ),
                  AppNotification(
                    notificationId: 'notif_5',
                    postId: 'post_203',
                    commentId: 'comment_92',
                    senderUsername: 'newUser99',
                    receiverUsername: 'currentUser',
                    isPostNotification: false,
                    isCommentNotification: false,
                    isUpvoteNotification: false,
                    isReplyNotification: true,
                    title: 'u/newUser99 replied to your comment in r/Economics',
                    description:
                        'As a student, I found your explanation really helpful! Could you expand on...',
                    createdAt: DateTime.now().subtract(
                      const Duration(days: 1, hours: 3),
                    ),
                    isRead: false,
                    avatarId: 2,
                  ),
                  AppNotification(
                    notificationId: 'notif_6',
                    postId: 'post_67',
                    commentId: '',
                    senderUsername: '',
                    receiverUsername: 'currentUser',
                    isPostNotification: false,
                    isCommentNotification: false,
                    isUpvoteNotification: true,
                    isReplyNotification: false,
                    title: '25 upvotes!',
                    description:
                        'Your comment on "Education Reforms" is getting attention',
                    createdAt: DateTime.now().subtract(const Duration(days: 2)),
                    isRead: true,
                    avatarId: 1,
                  ),
                  AppNotification(
                    notificationId: 'notif_7',
                    postId: 'post_155',
                    commentId: '',
                    senderUsername: 'travelLover',
                    receiverUsername: 'currentUser',
                    isPostNotification: true,
                    isCommentNotification: false,
                    isUpvoteNotification: false,
                    isReplyNotification: false,
                    title: 'u/travelLover shared a post you might like',
                    description:
                        'Hidden gems in Northern Pakistan - photo journey',
                    createdAt: DateTime.now().subtract(
                      const Duration(days: 2, hours: 8),
                    ),
                    isRead: false,
                    avatarId: 9,
                  ),
                  AppNotification(
                    notificationId: 'notif_8',
                    postId: 'post_189',
                    commentId: 'comment_112',
                    senderUsername: 'academicScholar',
                    receiverUsername: 'currentUser',
                    isPostNotification: false,
                    isCommentNotification: false,
                    isUpvoteNotification: false,
                    isReplyNotification: true,
                    title:
                        'u/academicScholar replied to your comment in r/History',
                    description:
                        'Your interpretation of the 1965 events aligns with Professor Khan\'s recent paper...',
                    createdAt: DateTime.now().subtract(const Duration(days: 3)),
                    isRead: true,
                    avatarId: 11,
                  ),
                  AppNotification(
                    notificationId: 'notif_9',
                    postId: 'post_77',
                    commentId: '',
                    senderUsername: 'sportsFan',
                    receiverUsername: 'currentUser',
                    isPostNotification: false,
                    isCommentNotification: true,
                    isUpvoteNotification: false,
                    isReplyNotification: false,
                    title: 'u/sportsFan commented on your post in r/PakCricket',
                    description:
                        'The bowling attack looks strong but we need to consider...',
                    createdAt: DateTime.now().subtract(const Duration(days: 4)),
                    isRead: false,
                    avatarId: 6,
                  ),
                  AppNotification(
                    notificationId: 'notif_10',
                    postId: 'post_201',
                    commentId: '',
                    senderUsername: '',
                    receiverUsername: 'currentUser',
                    isPostNotification: false,
                    isCommentNotification: false,
                    isUpvoteNotification: true,
                    isReplyNotification: false,
                    title: '50 upvotes milestone!',
                    description: 'Your analysis post has reached 50 upvotes',
                    createdAt: DateTime.now().subtract(const Duration(days: 5)),
                    isRead: true,
                    avatarId: 1,
                  ),
                  AppNotification(
                    notificationId: 'notif_11',
                    postId: 'post_92',
                    commentId: 'comment_203',
                    senderUsername: 'techGuru',
                    receiverUsername: 'currentUser',
                    isPostNotification: false,
                    isCommentNotification: false,
                    isUpvoteNotification: false,
                    isReplyNotification: true,
                    title:
                        'u/techGuru replied to your question in r/TechPakistan',
                    description:
                        'The new smartphone you asked about will launch next month with these specs...',
                    createdAt: DateTime.now().subtract(const Duration(days: 6)),
                    isRead: false,
                    avatarId: 4,
                  ),
                  AppNotification(
                    notificationId: 'notif_12',
                    postId: 'post_134',
                    commentId: '',
                    senderUsername: 'foodExplorer',
                    receiverUsername: 'currentUser',
                    isPostNotification: true,
                    isCommentNotification: false,
                    isUpvoteNotification: false,
                    isReplyNotification: false,
                    title: 'u/foodExplorer tagged you in a food post',
                    description:
                        'Thought you might appreciate this Lahore street food guide!',
                    createdAt: DateTime.now().subtract(const Duration(days: 7)),
                    isRead: true,
                    avatarId: 8,
                  ),
                  AppNotification(
                    notificationId: 'notif_13',
                    postId: 'post_176',
                    commentId: 'comment_145',
                    senderUsername: 'policyWonk',
                    receiverUsername: 'currentUser',
                    isPostNotification: false,
                    isCommentNotification: false,
                    isUpvoteNotification: false,
                    isReplyNotification: true,
                    title: 'u/policyWonk replied to your comment in r/Pakistan',
                    description:
                        'While I agree with your general point, the 2022 data actually shows...',
                    createdAt: DateTime.now().subtract(const Duration(days: 8)),
                    isRead: false,
                    avatarId: 10,
                  ),
                  AppNotification(
                    notificationId: 'notif_14',
                    postId: 'post_203',
                    commentId: '',
                    senderUsername: '',
                    receiverUsername: 'currentUser',
                    isPostNotification: false,
                    isCommentNotification: false,
                    isUpvoteNotification: true,
                    isReplyNotification: false,
                    title: '10 upvotes!',
                    description:
                        'Your comment on the new tax policy has 10 upvotes',
                    createdAt: DateTime.now().subtract(const Duration(days: 9)),
                    isRead: true,
                    avatarId: 1,
                  ),
                  AppNotification(
                    notificationId: 'notif_15',
                    postId: 'post_88',
                    commentId: 'comment_167',
                    senderUsername: 'bookLover',
                    receiverUsername: 'currentUser',
                    isPostNotification: false,
                    isCommentNotification: false,
                    isUpvoteNotification: false,
                    isReplyNotification: true,
                    title: 'u/bookLover replied to your book recommendation',
                    description:
                        'Thanks for suggesting that! I found it at Liberty Books...',
                    createdAt: DateTime.now().subtract(
                      const Duration(days: 10),
                    ),
                    isRead: false,
                    avatarId: 11,
                  ),
                  AppNotification(
                    notificationId: 'notif_16',
                    postId: 'post_145',
                    commentId: '',
                    senderUsername: 'movieCritic',
                    receiverUsername: 'currentUser',
                    isPostNotification: false,
                    isCommentNotification: true,
                    isUpvoteNotification: false,
                    isReplyNotification: false,
                    title: 'u/movieCritic commented on your film post',
                    description:
                        'The directors cut actually has an additional 30 minutes that changes...',
                    createdAt: DateTime.now().subtract(
                      const Duration(days: 11),
                    ),
                    isRead: true,
                    avatarId: 7,
                  ),
                  AppNotification(
                    notificationId: 'notif_17',
                    postId: 'post_210',
                    commentId: '',
                    senderUsername: 'travelBug',
                    receiverUsername: 'currentUser',
                    isPostNotification: true,
                    isCommentNotification: false,
                    isUpvoteNotification: false,
                    isReplyNotification: false,
                    title: 'u/travelBug shared a travel post with you',
                    description:
                        'Hunza in winter - a magical experience you might enjoy!',
                    createdAt: DateTime.now().subtract(
                      const Duration(days: 12),
                    ),
                    isRead: false,
                    avatarId: 5,
                  ),
                  AppNotification(
                    notificationId: 'notif_18',
                    postId: 'post_167',
                    commentId: 'comment_189',
                    senderUsername: 'scienceNerd',
                    receiverUsername: 'currentUser',
                    isPostNotification: false,
                    isCommentNotification: false,
                    isUpvoteNotification: false,
                    isReplyNotification: true,
                    title: 'u/scienceNerd replied to your science question',
                    description:
                        'The phenomenon you observed is actually called...',
                    createdAt: DateTime.now().subtract(
                      const Duration(days: 13),
                    ),
                    isRead: true,
                    avatarId: 3,
                  ),
                  AppNotification(
                    notificationId: 'notif_19',
                    postId: 'post_198',
                    commentId: '',
                    senderUsername: '',
                    receiverUsername: 'currentUser',
                    isPostNotification: false,
                    isCommentNotification: false,
                    isUpvoteNotification: true,
                    isReplyNotification: false,
                    title: '30 upvotes!',
                    description:
                        'Your post about local startups reached 30 upvotes',
                    createdAt: DateTime.now().subtract(
                      const Duration(days: 14),
                    ),
                    isRead: false,
                    avatarId: 1,
                  ),
                  AppNotification(
                    notificationId: 'notif_20',
                    postId: 'post_156',
                    commentId: 'comment_201',
                    senderUsername: 'artLover',
                    receiverUsername: 'currentUser',
                    isPostNotification: false,
                    isCommentNotification: false,
                    isUpvoteNotification: false,
                    isReplyNotification: true,
                    title: 'u/artLover replied to your art post',
                    description:
                        'The exhibition you mentioned is now extended until March!',
                    createdAt: DateTime.now().subtract(
                      const Duration(days: 15),
                    ),
                    isRead: true,
                    avatarId: 9,
                  ),
                ]),
              ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Notifications')),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.error != null) {
              return Center(child: Text('Error: ${state.error}'));
            }

            if (state.notifications.isEmpty) {
              return const Center(child: Text('No notifications yet'));
            }

            // Group notifications by date
            final now = DateTime.now();
            final todayStart = DateTime(now.year, now.month, now.day);
            final todayNotifications =
                state.notifications
                    .where((n) => n.createdAt.isAfter(todayStart))
                    .toList();

            final earlierNotifications =
                state.notifications
                    .where((n) => !n.createdAt.isAfter(todayStart))
                    .toList();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  if (todayNotifications.isNotEmpty) ...[
                    const Text(
                      'Today',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    ...todayNotifications
                        .map(
                          (notification) => NotificationTile(
                            notification: notification,
                            onTap: () {},
                          ),
                        )
                        .toList(),
                  ],
                  if (earlierNotifications.isNotEmpty) ...[
                    const Text(
                      'Earlier',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),

                    ...earlierNotifications
                        .map(
                          (notification) => NotificationTile(
                            notification: notification,
                            onTap: () {},
                          ),
                        )
                        .toList(),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Special handling for upvote notifications
    if (notification.isUpvoteNotification) {
      // return ListTile(
      // leading: const
      //   title: Text(
      //     notification.title,
      //     style: TextStyle(
      //       fontWeight:
      //           notification.isRead ? FontWeight.normal : FontWeight.bold,
      //     ),
      //   ),
      //   subtitle: Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Text(
      //         notification.description,
      //         maxLines: 2,
      //         overflow: TextOverflow.ellipsis,
      //       ),
      //       const SizedBox(height: 4),
      //       Text(
      //         _formatTimeDifference(notification.createdAt),
      //         style: const TextStyle(color: Colors.grey),
      //       ),
      //     ],
      //   ),
      //   onTap: onTap,
      // );
    }

    // Regular notification
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          notification.isUpvoteNotification
              ? Icon(
                Icons.arrow_upward,
                color: Color.fromARGB(255, 0, 115, 255),
                size: 6.0.h,
              )
              : CircleAvatar(
                radius: 25,
                backgroundImage: AssetImage(
                  'assets/Avatars/avatar${notification.avatarId}.jpg',
                ),
              ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 1.5.h),
                Text(
                  notification.title,
                  style: TextStyle(
                    fontWeight:
                        notification.isRead
                            ? FontWeight.normal
                            : FontWeight.bold,
                    color: Colors.white,
                    fontSize: 15,
                  ),
                ),

                Text(
                  notification.description,
                  maxLines: 2,

                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 11, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatTimeDifference(notification.createdAt),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatTimeDifference(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  // // Placeholder screen for notification details
  // class NotificationDetailScreen extends StatelessWidget {
  //   final Notification notification;

  //   const NotificationDetailScreen({super.key, required this.notification});

  //   @override
  //   Widget build(BuildContext context) {
  //     return Scaffold(
  //       appBar: AppBar(
  //         title: const Text('Notification Details'),
  //       ),
  //       body: Padding(
  //         padding: const EdgeInsets.all(16.0),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.start,
  //           children: [
  //             if (notification.isUpvoteNotification)
  //               const Icon(Icons.arrow_upward, color: Colors.orange, size: 48)
  //             else
  //               CircleAvatar(
  //                 radius: 24,
  //                 backgroundImage: AssetImage(
  //                   'assets/avatar/avatar${notification.avatarId}.png',
  //                 ),
  //               ),
  //             const SizedBox(height: 16),
  //             Text(
  //               notification.title,
  //               style: const TextStyle(
  //                 fontSize: 20,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //             const SizedBox(height: 8),
  //             Text(
  //               notification.description,
  //               style: const TextStyle(fontSize: 16),
  //             ),
  //             const SizedBox(height: 16),
  //             Text(
  //               'Received: ${_formatFullDate(notification.createdAt)}',
  //               style: const TextStyle(color: Colors.grey),
  //             ),
  //           ],
  //         ),
  //       ),
  //     );
  //   }

  //   String _formatFullDate(DateTime date) {
  //     return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  //   }
  //
}
