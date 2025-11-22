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

class UpVoteNotificationPost extends NotificationEvent {
  final int postId;
  final int userId;
  final BuildContext context;

  const UpVoteNotificationPost({
    required this.postId,
    required this.userId,
    required this.context,
  });

  @override
  List<Object> get props => [postId, userId, context];
}

class DownVoteNotificationPost extends NotificationEvent {
  final int postId;
  final int userId;
  final BuildContext context;

  const DownVoteNotificationPost({
    required this.postId,
    required this.userId,
    required this.context,
  });

  @override
  List<Object> get props => [postId, userId, context];
}

// --- In verbatica/BLOC/Notification/notification_event.dart (Conceptual) ---



class ToggleNotificationPostSaveStatus extends NotificationEvent {
  final String postId;
  final int userId;
  final bool isSaving; // true for save, false for unsave
  final BuildContext context;

  const ToggleNotificationPostSaveStatus({
    required this.postId,
    required this.userId,
    required this.isSaving,
    required this.context,
  });

  @override
  List<Object> get props => [postId, userId, isSaving, context];
}