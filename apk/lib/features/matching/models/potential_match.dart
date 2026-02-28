import 'package:equatable/equatable.dart';

class PotentialMatch extends Equatable {
  final int id;
  final String username;
  final String? avatar;
  final String? bio;
  final List<String> interests;
  final String? nativeLanguage;
  final String? learningLanguage;
  final int? age;
  final String? location;
  final double compatibilityScore;
  final List<String> sharedInterests;

  const PotentialMatch({
    required this.id,
    required this.username,
    this.avatar,
    this.bio,
    required this.interests,
    this.nativeLanguage,
    this.learningLanguage,
    this.age,
    this.location,
    this.compatibilityScore = 0.0,
    this.sharedInterests = const [],
  });

  factory PotentialMatch.fromJson(Map<String, dynamic> json) {
    return PotentialMatch(
      id: json['id'],
      username: json['username'],
      avatar: json['avatar'],
      bio: json['bio'],
      interests: List<String>.from(json['interests'] ?? []),
      nativeLanguage: json['native_language'],
      learningLanguage: json['learning_language'],
      age: json['age'],
      location: json['location'],
      compatibilityScore: (json['compatibility_score'] as num?)?.toDouble() ?? 0.0,
      sharedInterests: List<String>.from(json['shared_interests'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'avatar': avatar,
      'bio': bio,
      'interests': interests,
      'native_language': nativeLanguage,
      'learning_language': learningLanguage,
      'age': age,
      'location': location,
      'compatibility_score': compatibilityScore,
      'shared_interests': sharedInterests,
    };
  }

  String get compatibilityPercentage => '${(compatibilityScore * 100).toInt()}%';

  bool get hasHighCompatibility => compatibilityScore >= 0.7;

  @override
  List<Object?> get props => [
        id,
        username,
        avatar,
        bio,
        interests,
        nativeLanguage,
        learningLanguage,
        age,
        location,
        compatibilityScore,
        sharedInterests,
      ];
}
