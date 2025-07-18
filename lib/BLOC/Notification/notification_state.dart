// States
import 'package:equatable/equatable.dart';
import 'package:verbatica/model/notification.dart';

class NotificationState extends Equatable {
  final List<AppNotification> notifications;
  final bool isLoading;
  final String? error;

  const NotificationState({
    this.notifications = const [],
    this.isLoading = true,
    this.error,
  });

  @override
  List<Object?> get props => [notifications, isLoading, error];

  NotificationState copyWith({
    List<AppNotification>? notifications,
    bool? isLoading,
    String? error,
  }) {
    return NotificationState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}
