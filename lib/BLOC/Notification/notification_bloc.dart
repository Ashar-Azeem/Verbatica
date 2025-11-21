import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:verbatica/BLOC/Notification/notification_event.dart';
import 'package:verbatica/BLOC/Notification/notification_state.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/ViewDiscussion.dart';
import 'package:verbatica/model/Post.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<ResetPostView>(_onResetPostView);
    on<ClearAllNotifications>(_onClearAllNotifications);
    on<FetchAndSetPostForView>(_onReadAndLoadPost);
    on<MarkAllNotificationsAsRead>(_onMarkAllAsRead);
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
      // Use the notifications passed in the event
      emit(
        state.copyWith(notifications: event.appnotification, isLoading: false),
      );
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
    // 1. Map the current list to a new list, changing the isRead status for every notification.
    final updatedNotifications =
        state.notifications.map((notification) {
          // Use the model's copyWith method to create a new instance with isRead = true
          return notification.copyWith(isRead: true);
        }).toList();

    // 2. Emit a new state with the modified list.
    emit(
      state.copyWith(
        notifications: updatedNotifications,
        isLoading: false,
        error: null,
      ),
    );
  }
  // --- In notification_bloc.dart (or equivalent file) ---

  // --- In notification_bloc.dart ---
  // --- In verbatica/BLOC/Notification/notification_bloc.dart (Class Body) ---

  void _onResetPostView(ResetPostView event, Emitter<NotificationState> emit) {
    // Emit a new state that explicitly clears the onViewPost field
    emit(
      state.copyWith(
        onViewPost: null, // <--- Clears the post object
        isLoading: false,
        error: null,
      ),
    );
  }
  // --- CORRECTED _onReadAndLoadPost in NotificationBloc.dart ---

  void _onReadAndLoadPost(
    FetchAndSetPostForView event,
    Emitter<NotificationState> emit,
  ) async {
    // 1. Emit LOADING state (FIXED to TRUE)
    // emit(state.copyWith(isLoading: true, onViewPost: null));

    final clickedNotification = state.notifications.firstWhere(
      (n) => n.notificationId == event.notificationId,
    );

    Post? fetchedPost;

    if (clickedNotification.postId != null) {
      // Simulates waiting for network
      await Future.delayed(const Duration(milliseconds: 700));

      // Create the mock post
      final Post randomPost = Post(
        // ... (Your mock post data) ...
        isSaved: false,
        id: clickedNotification.postId!,
        publicKey: 'pk-remote-2025',
        name: 'TechAnalyst25',
        userId: 501,
        avatar: 4,
        title:
            'Is the Global Shift to Remote Work Sustainable for Large Enterprises?',
        description: 'The pandemic accelerated the remote work revolution...',
        postImageLink: 'https://example.com/images/remote_work_desk.jpg',
        postVideoLink: null,
        isDebate: true,
        upvotes: 782,
        downvotes: 115,
        isUpVote: false,
        isDownVote: false,
        comments: 6,
        uploadTime: DateTime.utc(2025, 10, 20, 10, 30),
        clusters: const [
          'Productivity',
          'Company Culture',
          'Security Risks',
          'Future of Work',
        ],
      );

      // CRITICAL FIX: Assign the created post to the fetchedPost variable
      fetchedPost = randomPost; // <--- ASSIGNMENT ADDED
    }

    // 3. Update the list: Mark the clicked notification as read
    final updatedNotifications =
        state.notifications.map((notification) {
          if (notification.notificationId == event.notificationId) {
            return notification.copyWith(isRead: true);
          }
          return notification;
        }).toList();

    // 4. Emit the final state: STOP loading, provide data (This triggers navigation)
    emit(state.copyWith(notifications: updatedNotifications));
    pushScreen(
      event.context, // Use the context passed in the event
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
