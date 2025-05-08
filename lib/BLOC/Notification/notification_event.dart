import 'package:equatable/equatable.dart';
import 'package:verbatica/model/notification.dart';

// Events
abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object> get props => [];
}

class LoadNotifications extends NotificationEvent {
  final List<AppNotification> appnotification;
  LoadNotifications(this.appnotification);
}
