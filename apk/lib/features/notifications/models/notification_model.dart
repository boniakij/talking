import 'package:equatable/equatable.dart';

class AppNotification extends Equatable {
  final String id;
  final String title;
  final String body;
  final String type;
  final Map<String, dynamic>? data;
  final bool isRead;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    this.data,
    this.isRead = false,
    required this.createdAt,
  });

  factory AppNotification.fromJson(Map<String, dynamic> json) {
    return AppNotification(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? 'general',
      data: json['data'],
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'type': type,
      'data': data,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }

  AppNotification copyWith({
    String? id,
    String? title,
    String? body,
    String? type,
    Map<String, dynamic>? data,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return AppNotification(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      data: data ?? this.data,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get icon {
    return switch (type) {
      'message' => '💬',
      'call' => '📞',
      'match' => '💕',
      'gift' => '🎁',
      'follow' => '👤',
      'system' => '🔔',
      _ => '🔔',
    };
  }

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${createdAt.day}/${createdAt.month}/${createdAt.year}';
  }

  @override
  List<Object?> get props => [id, title, body, type, data, isRead, createdAt];
}

class NotificationSettings {
  final bool messagesEnabled;
  final bool callsEnabled;
  final bool matchesEnabled;
  final bool giftsEnabled;
  final bool followsEnabled;
  final bool systemEnabled;
  final bool soundEnabled;
  final bool vibrationEnabled;

  const NotificationSettings({
    this.messagesEnabled = true,
    this.callsEnabled = true,
    this.matchesEnabled = true,
    this.giftsEnabled = true,
    this.followsEnabled = true,
    this.systemEnabled = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
  });

  factory NotificationSettings.fromJson(Map<String, dynamic> json) {
    return NotificationSettings(
      messagesEnabled: json['messages_enabled'] ?? true,
      callsEnabled: json['calls_enabled'] ?? true,
      matchesEnabled: json['matches_enabled'] ?? true,
      giftsEnabled: json['gifts_enabled'] ?? true,
      followsEnabled: json['follows_enabled'] ?? true,
      systemEnabled: json['system_enabled'] ?? true,
      soundEnabled: json['sound_enabled'] ?? true,
      vibrationEnabled: json['vibration_enabled'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messages_enabled': messagesEnabled,
      'calls_enabled': callsEnabled,
      'matches_enabled': matchesEnabled,
      'gifts_enabled': giftsEnabled,
      'follows_enabled': followsEnabled,
      'system_enabled': systemEnabled,
      'sound_enabled': soundEnabled,
      'vibration_enabled': vibrationEnabled,
    };
  }
}
