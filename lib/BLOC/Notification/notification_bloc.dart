// ignore_for_file: use_build_context_synchronously

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:verbatica/BLOC/Notification/notification_event.dart';
import 'package:verbatica/BLOC/Notification/notification_state.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/ViewDiscussion.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/notification.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<ResetPostView>(_onResetPostView);
    on<ClearAllNotifications>(_onClearAllNotifications);
    on<FetchAndSetPostForView>(_onReadAndLoadPost);
    on<ToggleNotificationPostSaveStatus>(_onTogglePostSaveStatus);
    on<MarkAllNotificationsAsRead>(_onMarkAllAsRead);
    on<UpVoteNotificationPost>(_onUpVoteNotificationPost);
    on<DownVoteNotificationPost>(_onDownVoteNotificationPost);
    on<RefreshEvent>((event, emit) {
      emit(state.copyWith(notifications: [], isLoading: true));
      add(LoadNotifications(userId: event.userId));
    });
  }

  void _onUpVoteNotificationPost(
    UpVoteNotificationPost event,
    Emitter<NotificationState> emit,
  ) {
    final Post? currentPost = state.onViewPost;

    if (currentPost == null) {
      return;
    }

    ApiService().updatingVotes(
      int.parse(currentPost.id),
      event.userId,
      true,
      event.context,
    );

    Post newPost;
    if (!currentPost.isUpVote) {
      if (currentPost.isDownVote) {
        newPost = currentPost.copyWith(
          isDownVote: false,
          isUpVote: true,
          upvotes: currentPost.upvotes + 1,
          downvotes: currentPost.downvotes - 1,
        );
      } else {
        newPost = currentPost.copyWith(
          isUpVote: true,
          upvotes: currentPost.upvotes + 1,
        );
      }
    } else {
      newPost = currentPost.copyWith(
        isUpVote: false,
        upvotes: currentPost.upvotes - 1,
      );
    }
    emit(state.copyWith(onViewPost: newPost));
  }

  void _onDownVoteNotificationPost(
    DownVoteNotificationPost event,
    Emitter<NotificationState> emit,
  ) {
    Post? currentPost = state.onViewPost;

    if (currentPost == null) return;

    ApiService().updatingVotes(
      int.parse(currentPost.id),
      event.userId,
      false,
      event.context,
    );

    Post newPost;

    if (!currentPost.isDownVote) {
      if (currentPost.isUpVote) {
        newPost = currentPost.copyWith(
          isDownVote: true,
          isUpVote: false,
          upvotes: currentPost.upvotes - 1,
          downvotes: currentPost.downvotes + 1,
        );
      } else {
        newPost = currentPost.copyWith(
          isDownVote: true,
          downvotes: currentPost.downvotes + 1,
        );
      }
    } else {
      newPost = currentPost.copyWith(
        isDownVote: false,
        downvotes: currentPost.downvotes - 1,
      );
    }

    emit(state.copyWith(onViewPost: newPost));
  }

  DateTime _getTodayStart() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  void _onClearAllNotifications(
    ClearAllNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    final todayStart = _getTodayStart();

    final notificationsToKeep =
        state.notifications
            .where((n) => n.createdAt.isAfter(todayStart))
            .toList();

    List<int> notificationIds = [];
    for (AppNotification n in state.notifications) {
      if (n.createdAt.isBefore(todayStart)) {
        notificationIds.add(int.parse(n.notificationId));
      }
    }

    ApiService().deleteNotification(notificationIds);

    emit(
      state.copyWith(
        notifications: notificationsToKeep,
        isLoading: false,
        error: null,
      ),
    );
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      List<AppNotification> notifications = await ApiService().getNotifications(
        event.userId,
      );
      emit(state.copyWith(notifications: notifications, isLoading: false));
    } catch (e) {
      emit(
        state.copyWith(
          error: 'Failed to load notifications: ${e.toString()}',
          isLoading: false,
        ),
      );
    }
  }

  void _onMarkAllAsRead(
    MarkAllNotificationsAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    final updatedNotifications =
        state.notifications.map((notification) {
          return notification.copyWith(isRead: true);
        }).toList();

    List<int> notificationIds = [];
    for (AppNotification n in updatedNotifications) {
      notificationIds.add(int.parse(n.notificationId));
    }

    ApiService().markAsRead(notificationIds);

    emit(
      state.copyWith(
        notifications: updatedNotifications,
        isLoading: false,
        error: null,
      ),
    );
  }

  void _onTogglePostSaveStatus(
    ToggleNotificationPostSaveStatus event,
    Emitter<NotificationState> emit,
  ) {
    Post? currentPost = state.onViewPost;

    if (currentPost == null) return;

    ApiService().savePost(event.userId, int.parse(state.onViewPost!.id));

    currentPost = currentPost.copyWith(isSaved: !currentPost.isSaved);

    emit(state.copyWith(onViewPost: currentPost));
  }

  void _onResetPostView(ResetPostView event, Emitter<NotificationState> emit) {
    emit(state.copyWith(onViewPost: null, isLoading: false, error: null));
  }

  void _onReadAndLoadPost(
    FetchAndSetPostForView event,
    Emitter<NotificationState> emit,
  ) async {
    final clickedNotification = state.notifications.firstWhere(
      (n) => n.notificationId == event.notificationId,
    );
    ApiService().markAsRead([int.parse(clickedNotification.notificationId)]);

    Post? fetchedPost;

    if (clickedNotification.postId != null) {
      fetchedPost = await ApiService().fetchPostWithId(
        clickedNotification.postId!,
        event.userId,
      );
    }

    final updatedNotifications =
        state.notifications.map((notification) {
          if (notification.notificationId == event.notificationId) {
            return notification.copyWith(isRead: true);
          }
          return notification;
        }).toList();

    emit(
      state.copyWith(
        notifications: updatedNotifications,
        onViewPost: fetchedPost,
      ),
    );
    pushScreen(
      event.context,
      pageTransitionAnimation: PageTransitionAnimation.scale,
      screen: ViewDiscussion(
        post: fetchedPost!,
        index: -1,
        newIndex: null,
        category: 'notification',
      ),
      withNavBar: false,
    );
  }
}
