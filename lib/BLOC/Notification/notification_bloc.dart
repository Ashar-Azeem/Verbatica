import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
import 'package:verbatica/BLOC/Notification/notification_event.dart';
import 'package:verbatica/BLOC/Notification/notification_state.dart';
import 'package:verbatica/Services/API_Service.dart';
import 'package:verbatica/Views/Nav%20Bar%20Screens/ViewDiscussion.dart';
import 'package:verbatica/model/Post.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<LoadNotifications>(_onLoadNotifications);
<<<<<<< HEAD
 on<ResetPostView>(_onResetPostView);
     on<ClearAllNotifications>(_onClearAllNotifications); 
     on<FetchAndSetPostForView>(_onReadAndLoadPost);
     on<ToggleNotificationPostSaveStatus>(_onTogglePostSaveStatus);
     on<MarkAllNotificationsAsRead>(_onMarkAllAsRead);
     on<UpVoteNotificationPost>(_onUpVoteNotificationPost);
    on<DownVoteNotificationPost>(_onDownVoteNotificationPost);
  }
  // --- In NotificationBloc.dart (New Method) ---

void _onUpVoteNotificationPost(
  UpVoteNotificationPost event,
  Emitter<NotificationState> emit,
) {print('111111111111111111111111111111111111111111');
  final Post? currentPost = state.onViewPost;

  // FIX: Immediately check and return if the essential object is missing.
  if (currentPost == null) {
      print('ERROR: currentPost is null, exiting handler.');
      return; 
  }

  // 1. Call API Service (Assuming ApiService().updatingVotes exists)
  // ApiService().updatingVotes(
  //   int.parse(currentPost.id),
  //   event.userId,
  //   true, // isUpvote: true
  //   event.context,
  // );

  // 2. Apply vote logic (similar to your HomeBloc sample)
  Post newPost;
  print('111111111111111111111111111666666111111111111111');
  if (!currentPost.isUpVote) {
    if (currentPost.isDownVote) {
      // Downvoted -> Upvote: +2 to upvotes, -1 to downvotes
      newPost = currentPost.copyWith(
        isDownVote: false,
        isUpVote: true,
        upvotes: currentPost.upvotes + 1,
        downvotes: currentPost.downvotes - 1, // Decrement downvotes
      );
    } else {
      // No vote -> Upvote: +1 to upvotes
      newPost = currentPost.copyWith(
        isUpVote: true,
        upvotes: currentPost.upvotes + 1,
      );
    }
  } else {
    // Undo Upvote: -1 from upvotes
    newPost = currentPost.copyWith(
      isUpVote: false,
      upvotes: currentPost.upvotes - 1,
    );
  }
print("abbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbcccc");
  // 3. Emit the state with the updated post
  emit(state.copyWith(onViewPost: newPost));

}
// --- In NotificationBloc.dart (New Method) ---

void _onDownVoteNotificationPost(
  DownVoteNotificationPost event,
  Emitter<NotificationState> emit,
) {
  Post? currentPost = state.onViewPost;

  if (currentPost == null) return; // Safety check

  // 1. Call API Service
  // ApiService().updatingVotes(
  //   int.parse(currentPost.id),
  //   event.userId,
  //   false, // isUpvote: false
  //   event.context,
  // );

  // 2. Apply vote logic
  Post newPost;

  if (!currentPost.isDownVote) {
    if (currentPost.isUpVote) {
      // Upvoted -> Downvote: +1 to downvotes, -1 to upvotes
      newPost = currentPost.copyWith(
        isDownVote: true,
        isUpVote: false,
        upvotes: currentPost.upvotes - 1,
        downvotes: currentPost.downvotes + 1,
      );
    } else {
      // No vote -> Downvote: +1 to downvotes
      newPost = currentPost.copyWith(
        isDownVote: true,
        downvotes: currentPost.downvotes + 1,
      );
    }
  } else {
    // Undo Downvote: -1 from downvotes
    newPost = currentPost.copyWith(
      isDownVote: false,
      downvotes: currentPost.downvotes - 1,
    );
  }

  // 3. Emit the state with the updated post
  emit(state.copyWith(onViewPost: newPost));
}
 DateTime _getTodayStart() {
=======
    on<ResetPostView>(_onResetPostView);
    on<ClearAllNotifications>(_onClearAllNotifications);
    on<FetchAndSetPostForView>(_onReadAndLoadPost);
    on<MarkAllNotificationsAsRead>(_onMarkAllAsRead);
  }
  DateTime _getTodayStart() {
>>>>>>> 3ee0a2dfa87d94c0aa336b0c265c1d0216d22a3a
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

<<<<<<< HEAD
// --- In notification_bloc.dart ---
// --- In verbatica/BLOC/Notification/notification_bloc.dart (Class Body) ---
void _onTogglePostSaveStatus(
  ToggleNotificationPostSaveStatus event,
  Emitter<NotificationState> emit,
) {
  Post? currentPost = state.onViewPost;

  if (currentPost == null) return; // Safety check

  // 1. Call API Service (Assuming ApiService().updatePostSaveStatus exists)
  // You would uncomment and implement this:
  /*
  ApiService().updatePostSaveStatus(
    int.parse(event.postId),
    event.userId,
    event.isSaving,
    event.context,
  );
  */

  // 2. Apply save logic
  Post newPost;
  
  if (event.isSaving) {
      // Logic for saving: we assume the Post model has an 'isSaved' property 
      // or that the User model handles tracking saved posts externally. 
      // Since PostWidget uses the Post object directly, let's assume Post needs an isSaved property.
      
      // We will rely on the UserBloc updating its saved list, 
      // but for this specific Post object to reflect the status visually, 
      // we need to update the post itself if a field like `isSaved` exists in Post model.
      
      // If Post model has `isSaved`:
      // newPost = currentPost.copyWith(isSaved: true); 
      
      // Since your Post model doesn't explicitly show `isSaved`, we rely on 
      // the UserBloc to handle the saved status externally, 
      // but if the UI relies on a Post property to change the icon, that needs updating.
      
      // For now, emit the state change to trigger UI refresh (which relies on UserBloc for icon state):
      emit(state.copyWith(onViewPost: currentPost)); 

  } else {
      // Logic for unsaving
      // newPost = currentPost.copyWith(isSaved: false); // If Post model has `isSaved`
      
      emit(state.copyWith(onViewPost: currentPost));
  }
}
void _onResetPostView(
  ResetPostView event,
  Emitter<NotificationState> emit,
) {
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
=======
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
>>>>>>> 3ee0a2dfa87d94c0aa336b0c265c1d0216d22a3a

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
<<<<<<< HEAD
        id: '1233455', 
=======
        isSaved: false,
        id: clickedNotification.postId!,
>>>>>>> 3ee0a2dfa87d94c0aa336b0c265c1d0216d22a3a
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
<<<<<<< HEAD

// 3. Update the list: Mark the clicked notification as read
 final updatedNotifications = state.notifications.map((notification) {
 if (notification.notificationId == event.notificationId) {
return notification.copyWith(isRead: true); 
}
return notification; 
}).toList();

 // 4. Emit the final state: STOP loading, provide data (This triggers navigation)
 emit(
state.copyWith(
 notifications: updatedNotifications,
 onViewPost: fetchedPost,

),

)
;
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
=======
>>>>>>> 3ee0a2dfa87d94c0aa336b0c265c1d0216d22a3a
