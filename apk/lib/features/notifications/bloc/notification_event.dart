import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationEvent {}

class MarkAsRead extends NotificationEvent {
  final String notificationId;

  const MarkAsRead(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class MarkAllAsRead extends NotificationEvent {}

class DeleteNotification extends NotificationEvent {
  final String notificationId;

  const DeleteNotification(this.notificationId);

  @override
  List<Object?> get props => [notificationId];
}

class ReceiveNotification extends NotificationEvent {
  final Map<String, dynamic> payload;

  const ReceiveNotification(this.payload);

  @override
  List<Object?> get props => [payload];
}

class LoadNotificationSettings extends NotificationEvent {}

class UpdateNotificationSettings extends NotificationEvent {
  final String settingKey;
  final bool value;

  const UpdateNotificationSettings(this.settingKey, this.value);

  @override
  List<Object?> get props => [settingKey, value];
}

class RegisterDeviceToken extends NotificationEvent {
  final String token;

  const RegisterDeviceToken(this.token);

  @override
  List<Object?> get props => [token];
}
