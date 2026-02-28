import 'package:equatable/equatable.dart';

class LeaderboardEntry extends Equatable {
  final int id;
  final String username;
  final String avatar;
  final int score;
  final String tongueTwisterText;
  final DateTime completedAt;
  final int rank;

  const LeaderboardEntry({
    required this.id,
    required this.username,
    required this.avatar,
    required this.score,
    required this.tongueTwisterText,
    required this.completedAt,
    required this.rank,
  });

  factory LeaderboardEntry.fromJson(Map<String, dynamic> json) {
    return LeaderboardEntry(
      id: json['id'],
      username: json['username'],
      avatar: json['avatar'] ?? '',
      score: json['score'],
      tongueTwisterText: json['tongue_twister_text'],
      completedAt: DateTime.parse(json['completed_at']),
      rank: json['rank'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar': avatar,
      'score': score,
      'tongue_twister_text': tongueTwisterText,
      'completed_at': completedAt.toIso8601String(),
      'rank': rank,
    };
  }

  String get rankBadge {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '$rank';
    }
  }

  @override
  List<Object?> get props => [id, username, avatar, score, tongueTwisterText, completedAt, rank];
}
