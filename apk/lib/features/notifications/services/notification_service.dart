import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();

  final StreamController<RemoteMessage> _messageController = 
      StreamController<RemoteMessage>.broadcast();
  Stream<RemoteMessage> get onMessage => _messageController.stream;

  Future<void> initialize() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await _createNotificationChannels();
  }

  Future<void> _createNotificationChannels() async {
    if (Platform.isAndroid) {
      const callChannel = AndroidNotificationChannel(
        'call_channel',
        'Calls',
        description: 'Incoming call notifications',
        importance: Importance.max,
        sound: RawResourceAndroidNotificationSound('call_ringtone'),
        playSound: true,
      );

      const messageChannel = AndroidNotificationChannel(
        'message_channel',
        'Messages',
        description: 'New message notifications',
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound('message_sound'),
        playSound: true,
      );

      const matchChannel = AndroidNotificationChannel(
        'match_channel',
        'Matches',
        description: 'New match notifications',
        importance: Importance.high,
        sound: RawResourceAndroidNotificationSound('match_sound'),
        playSound: true,
      );

      const generalChannel = AndroidNotificationChannel(
        'general_channel',
        'General',
        description: 'General notifications',
        importance: Importance.defaultImportance,
      );

      // Note: Notification channels are created automatically when notifications are shown
      // with the specified channel ID in AndroidNotificationDetails
    }
  }

  Future<String?> getToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    _messageController.add(message);
    _showLocalNotification(message);
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    _messageController.add(message);
  }

  Future<void> _showLocalNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;
    final data = message.data;

    String channelId = data['channel_id'] ?? 'general_channel';
    String? sound = data['sound'];

    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(channelId),
      channelDescription: _getChannelDescription(channelId),
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
      sound: sound != null 
          ? RawResourceAndroidNotificationSound(sound) 
          : null,
      icon: android?.smallIcon,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      message.hashCode,
      notification?.title ?? 'BaniTalk',
      notification?.body ?? '',
      details,
      payload: data['route'],
    );
  }

  String _getChannelName(String channelId) {
    return switch (channelId) {
      'call_channel' => 'Calls',
      'message_channel' => 'Messages',
      'match_channel' => 'Matches',
      _ => 'General',
    };
  }

  String _getChannelDescription(String channelId) {
    return switch (channelId) {
      'call_channel' => 'Incoming call notifications',
      'message_channel' => 'New message notifications',
      'match_channel' => 'New match notifications',
      _ => 'General notifications',
    };
  }

  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      // Navigate to specific route
    }
  }

  Future<void> showLocalNotification({
    required String title,
    required String body,
    String? payload,
    String channelId = 'general_channel',
  }) async {
    final androidDetails = AndroidNotificationDetails(
      channelId,
      _getChannelName(channelId),
      channelDescription: _getChannelDescription(channelId),
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();

    final details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      DateTime.now().millisecond,
      title,
      body,
      details,
      payload: payload,
    );
  }

  void dispose() {
    _messageController.close();
  }
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Handle background messages
}
