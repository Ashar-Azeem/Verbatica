import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verbatica/BLOC/Notification/notification_event.dart';
import 'package:verbatica/BLOC/Notification/notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(const NotificationState()) {
    on<LoadNotifications>(_onLoadNotifications);
    // on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
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

  // Future<void> _onMarkNotificationAsRead(
  //   MarkNotificationAsRead event,
  //   Emitter<NotificationState> emit,
  // ) async {
  //   final updatedNotifications = state.notifications.map((n) {
  //     if (n.notificationId == event.notificationId) {
  //       return n.copyWith(isRead: true);
  //     }
  //     return n;
  //   }).toList();

  //   emit(state.copyWith(notifications: updatedNotifications));
  // }
}
