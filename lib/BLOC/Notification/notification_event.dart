import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:verbatica/model/notification.dart';

// Events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {
  final List<AppNotification> appnotification;
  const LoadNotifications(this.appnotification);
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
// --- Conceptual notification_event.dart ---

class FetchAndSetPostForView extends NotificationEvent {
  final String postId;
  final String notificationId; // To mark the specific notification as read
final BuildContext context;
  const FetchAndSetPostForView({
    required this.postId,
    required this.context,
    required this.notificationId,
  });
}
// --- In verbatica/BLOC/Notification/notification_event.dart ---

class ResetPostView extends NotificationEvent {
  const ResetPostView();

  @override
  List<Object> get props => [];
}