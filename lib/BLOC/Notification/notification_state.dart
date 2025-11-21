// States
import 'package:equatable/equatable.dart';
import 'package:verbatica/model/Post.dart';
import 'package:verbatica/model/notification.dart';

class NotificationState extends Equatable {
  final List<AppNotification> notifications;
  final bool isLoading;
  final String? error;
final Post? onViewPost;
  const NotificationState({
    this.notifications = const [],
    this.isLoading = true,
    this.error,
    this.onViewPost
  });

  @override
  List<Object?> get props => [notifications, isLoading, error,onViewPost];

  NotificationState copyWith({
    List<AppNotification>? notifications,
    bool? isLoading,
    String? error,
     Post? onViewPost
  }) {
    return NotificationState(
      onViewPost: onViewPost??this.onViewPost,
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
