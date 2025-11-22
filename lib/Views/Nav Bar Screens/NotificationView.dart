import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/Notification/notification_bloc.dart';
import 'package:verbatica/BLOC/Notification/notification_event.dart';
import 'package:verbatica/BLOC/Notification/notification_state.dart';
import 'package:verbatica/model/notification.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    // Use the existing NotificationBloc instead of creating a new one
    context.read<NotificationBloc>().add(
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
          createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
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
          title: 'u/debateMaster replied to your comment in r/PakHistory',
          description: 'Actually, the census data from 1947 shows...',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
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
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          isRead: false,
          avatarId: 1,
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
          createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
          isRead: false,
          avatarId: 2,
        ),
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
          createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
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
          title: 'u/debateMaster replied to your comment in r/PakHistory',
          description: 'Actually, the census data from 1947 shows...',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
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
          createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          isRead: false,
          avatarId: 1,
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
          createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
          isRead: false,
          avatarId: 2,
        ),
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          'Notifications',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
            color: Theme.of(context).textTheme.titleLarge?.color,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).textTheme.bodyLarge?.color,
        ),
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          if (state.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            );
          } else if (state.error != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.redAccent,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.error}',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          } else if (state.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.notifications_off_rounded,
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                    size: 64,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No notifications yet',
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
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
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10),
            child: CustomScrollView(
              shrinkWrap: true,
              // Using AlwaysScrollable ensures it drags even if content is small
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Today',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.titleLarge?.color,
                            letterSpacing: 0.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<NotificationBloc>().add(
                              const MarkAllNotificationsAsRead(),
                            );
                          },
                          child: Text(
                            'Mark all as read',
                            style: TextStyle(
                              fontSize: 14,
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (todayNotifications.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Text(
                          'No new notifications today',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final notification = todayNotifications[index];
                      return NotificationTile(
                        notification: notification,
                        onTap: () {},
                      );
                    }, childCount: todayNotifications.length),
                  ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Earlier',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color:
                                Theme.of(context).textTheme.titleLarge?.color,
                            letterSpacing: 0.5,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<NotificationBloc>().add(
                              const ClearAllNotifications(),
                            );
                          },
                          child: Text(
                            'Clear all',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.red[300],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (earlierNotifications.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Center(
                        child: Text(
                          'No earlier notifications',
                          style: TextStyle(
                            color: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.color?.withOpacity(0.6),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final notification = earlierNotifications[index];
                      return NotificationTile(
                        notification: notification,
                        onTap: () {},
                      );
                    }, childCount: earlierNotifications.length),
                  ),

                // Add bottom padding for better scrolling
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      decoration: BoxDecoration(
        color:
            notification.isRead
                ? (isDarkMode ? const Color(0xFF1A1A1A) : Colors.grey[50])
                : (isDarkMode
                    ? const Color(0xFF232733)
                    : Theme.of(context).colorScheme.primary.withOpacity(0.05)),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 0,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.read<NotificationBloc>().add(
              FetchAndSetPostForView(
                notificationId: notification.notificationId,
                postId: notification.postId!,
                context: context,
              ),
            );
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 10.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar or Icon
                _buildLeadingWidget(context),

                const SizedBox(width: 12),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title with unread indicator
                      Row(
                        children: [
                          if (!notification.isRead)
                            Container(
                              width: 8,
                              height: 8,
                              margin: const EdgeInsets.only(right: 6),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontWeight:
                                    notification.isRead
                                        ? FontWeight.w500
                                        : FontWeight.bold,
                                color:
                                    Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.color,
                                fontSize: 15,
                                height: 1.3,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Description
                      Text(
                        notification.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(
                            context,
                          ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Time with action icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatTimeDifference(notification.createdAt),
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).textTheme.bodyMedium?.color?.withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),

                          // Action icons
                          Row(
                            children: [
                              _buildActionIcon(
                                context,
                                Icons.reply_rounded,
                                'Reply',
                                () {},
                              ),
                              const SizedBox(width: 16),
                              _buildActionIcon(
                                context,
                                Icons.more_horiz_rounded,
                                'More options',
                                () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeadingWidget(BuildContext context) {
    if (notification.isUpvoteNotification) {
      return Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.arrow_upward_rounded,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ),
      );
    } else {
      return Stack(
        children: [
          CircleAvatar(
            radius: 21,
            backgroundImage: AssetImage(
              'assets/Avatars/avatar${notification.avatarId}.jpg',
            ),
          ),
          if (notification.isCommentNotification)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.comment_rounded,
                  color: Colors.white,
                  size: 10,
                ),
              ),
            )
          else if (notification.isReplyNotification)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.reply_rounded,
                  color: Colors.white,
                  size: 10,
                ),
              ),
            )
          else if (notification.isPostNotification)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.purple,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.post_add_rounded,
                  color: Colors.white,
                  size: 10,
                ),
              ),
            ),
        ],
      );
    }
  }

  Widget _buildActionIcon(
    BuildContext context,
    IconData icon,
    String tooltip,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Icon(
          icon,
          color: Theme.of(
            context,
          ).textTheme.bodyMedium?.color?.withOpacity(0.5),
          size: 18,
        ),
      ),
    );
  }

  String _formatTimeDifference(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }
}
