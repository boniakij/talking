import 'package:equatable/equatable.dart';
import '../models/notification_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<AppNotification> notifications;
  final int unreadCount;

  const NotificationsLoaded(this.notifications, {this.unreadCount = 0});

  @override
  List<Object?> get props => [notifications, unreadCount];
}

class NotificationSettingsLoaded extends NotificationState {
  final NotificationSettings settings;

  const NotificationSettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class NotificationReceived extends NotificationState {
  final AppNotification notification;

  const NotificationReceived(this.notification);

  @override
  List<Object?> get props => [notification];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}
