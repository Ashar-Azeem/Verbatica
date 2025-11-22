import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// Events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {
  final int userId;
  const LoadNotifications({required this.userId});
}

class ClearAllNotifications extends NotificationEvent {
  const ClearAllNotifications();

  @override
  List<Object> get props => [];
}

class MarkAllNotificationsAsRead extends NotificationEvent {
  const MarkAllNotificationsAsRead();

  @override
  List<Object> get props => [];
}
// --- In notification_event.dart (or equivalent file) ---

class ToggleNotificationReadStatus extends NotificationEvent {
  final String notificationId;

  const ToggleNotificationReadStatus(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class FetchAndSetPostForView extends NotificationEvent {
  final String postId;
  final String notificationId;
  final BuildContext context;
  const FetchAndSetPostForView({
    required this.postId,
    required this.context,
    required this.notificationId,
  });
}

class ResetPostView extends NotificationEvent {
  const ResetPostView();

  @override
  List<Object> get props => [];
}
