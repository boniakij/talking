import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/notification_service.dart';
import 'notification_event.dart';
import 'notification_state.dart';
import '../models/notification_model.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationService _notificationService;

  NotificationBloc(this._notificationService) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkAsRead>(_onMarkAsRead);
    on<MarkAllAsRead>(_onMarkAllAsRead);
    on<DeleteNotification>(_onDeleteNotification);
    on<ReceiveNotification>(_onReceiveNotification);
    on<LoadNotificationSettings>(_onLoadNotificationSettings);
    on<UpdateNotificationSettings>(_onUpdateNotificationSettings);
    on<RegisterDeviceToken>(_onRegisterDeviceToken);

    // Listen to notification stream
    _notificationService.onMessage.listen((message) {
      add(ReceiveNotification(message.data));
    });
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      // Mock notifications for now - would be fetched from API
      final notifications = _getMockNotifications();
      final unreadCount = notifications.where((n) => !n.isRead).length;
      emit(NotificationsLoaded(notifications, unreadCount: unreadCount));
    } catch (e) {
      emit(NotificationError('Failed to load notifications: ${e.toString()}'));
    }
  }

  Future<void> _onMarkAsRead(
    MarkAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      if (state is NotificationsLoaded) {
        final currentState = state as NotificationsLoaded;
        final updatedNotifications = currentState.notifications.map((n) {
          return n.id == event.notificationId ? n.copyWith(isRead: true) : n;
        }).toList();
        final unreadCount = updatedNotifications.where((n) => !n.isRead).length;
        emit(NotificationsLoaded(updatedNotifications, unreadCount: unreadCount));
      }
    } catch (e) {
      emit(NotificationError('Failed to mark as read: ${e.toString()}'));
    }
  }

  Future<void> _onMarkAllAsRead(
    MarkAllAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      if (state is NotificationsLoaded) {
        final currentState = state as NotificationsLoaded;
        final updatedNotifications = currentState.notifications.map((n) {
          return n.copyWith(isRead: true);
        }).toList();
        emit(NotificationsLoaded(updatedNotifications, unreadCount: 0));
      }
    } catch (e) {
      emit(NotificationError('Failed to mark all as read: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      if (state is NotificationsLoaded) {
        final currentState = state as NotificationsLoaded;
        final updatedNotifications = currentState.notifications
            .where((n) => n.id != event.notificationId)
            .toList();
        final unreadCount = updatedNotifications.where((n) => !n.isRead).length;
        emit(NotificationsLoaded(updatedNotifications, unreadCount: unreadCount));
      }
    } catch (e) {
      emit(NotificationError('Failed to delete notification: ${e.toString()}'));
    }
  }

  Future<void> _onReceiveNotification(
    ReceiveNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final notification = AppNotification.fromJson(event.payload);
      emit(NotificationReceived(notification));
      
      // Reload notifications list
      add(LoadNotifications());
    } catch (e) {
      emit(NotificationError('Failed to process notification: ${e.toString()}'));
    }
  }

  Future<void> _onLoadNotificationSettings(
    LoadNotificationSettings event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      // Mock settings - would be fetched from local storage or API
      const settings = NotificationSettings();
      emit(const NotificationSettingsLoaded(settings));
    } catch (e) {
      emit(NotificationError('Failed to load settings: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateNotificationSettings(
    UpdateNotificationSettings event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      if (state is NotificationSettingsLoaded) {
        final currentSettings = (state as NotificationSettingsLoaded).settings;
        final updatedSettings = _updateSetting(currentSettings, event.settingKey, event.value);
        emit(NotificationSettingsLoaded(updatedSettings));
      }
    } catch (e) {
      emit(NotificationError('Failed to update settings: ${e.toString()}'));
    }
  }

  Future<void> _onRegisterDeviceToken(
    RegisterDeviceToken event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      // Register token with backend
      print('Registering device token: ${event.token}');
    } catch (e) {
      emit(NotificationError('Failed to register token: ${e.toString()}'));
    }
  }

  NotificationSettings _updateSetting(NotificationSettings settings, String key, bool value) {
    return switch (key) {
      'messages' => settings.copyWith(messagesEnabled: value),
      'calls' => settings.copyWith(callsEnabled: value),
      'matches' => settings.copyWith(matchesEnabled: value),
      'gifts' => settings.copyWith(giftsEnabled: value),
      'follows' => settings.copyWith(followsEnabled: value),
      'system' => settings.copyWith(systemEnabled: value),
      'sound' => settings.copyWith(soundEnabled: value),
      'vibration' => settings.copyWith(vibrationEnabled: value),
      _ => settings,
    };
  }

  List<AppNotification> _getMockNotifications() {
    return [
      AppNotification(
        id: '1',
        title: 'New Message',
        body: 'Sarah sent you a message',
        type: 'message',
        data: {'user_id': '123', 'conversation_id': '456'},
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      AppNotification(
        id: '2',
        title: "It's a Match!",
        body: 'You and Alex have liked each other',
        type: 'match',
        data: {'user_id': '789'},
        isRead: false,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      AppNotification(
        id: '3',
        title: 'Incoming Call',
        body: 'Mike is calling you',
        type: 'call',
        data: {'user_id': '101', 'call_id': '202'},
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      AppNotification(
        id: '4',
        title: 'Gift Received',
        body: 'Emma sent you a 🌸 Sakura',
        type: 'gift',
        data: {'user_id': '303', 'gift_id': 'sakura'},
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      AppNotification(
        id: '5',
        title: 'New Follower',
        body: 'John started following you',
        type: 'follow',
        data: {'user_id': '404'},
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }
}

extension on NotificationSettings {
  NotificationSettings copyWith({
    bool? messagesEnabled,
    bool? callsEnabled,
    bool? matchesEnabled,
    bool? giftsEnabled,
    bool? followsEnabled,
    bool? systemEnabled,
    bool? soundEnabled,
    bool? vibrationEnabled,
  }) {
    return NotificationSettings(
      messagesEnabled: messagesEnabled ?? this.messagesEnabled,
      callsEnabled: callsEnabled ?? this.callsEnabled,
      matchesEnabled: matchesEnabled ?? this.matchesEnabled,
      giftsEnabled: giftsEnabled ?? this.giftsEnabled,
      followsEnabled: followsEnabled ?? this.followsEnabled,
      systemEnabled: systemEnabled ?? this.systemEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
    );
  }
}
