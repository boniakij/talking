import 'package:equatable/equatable.dart';

class TongueTwister extends Equatable {
  final int id;
  final String text;
  final String language;
  final String difficulty;
  final String translation;
  final List<String> phonemes;
  final bool isUnlocked;
  final int? bestScore;
  final DateTime? completedAt;

  const TongueTwister({
    required this.id,
    required this.text,
    required this.language,
    required this.difficulty,
    required this.translation,
    required this.phonemes,
    this.isUnlocked = false,
    this.bestScore,
    this.completedAt,
  });

  factory TongueTwister.fromJson(Map<String, dynamic> json) {
    return TongueTwister(
      id: json['id'],
      text: json['text'],
      language: json['language'],
      difficulty: json['difficulty'],
      translation: json['translation'] ?? '',
      phonemes: List<String>.from(json['phonemes'] ?? []),
      isUnlocked: json['is_unlocked'] ?? false,
      bestScore: json['best_score'],
      completedAt: json['completed_at'] != null 
          ? DateTime.parse(json['completed_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'language': language,
      'difficulty': difficulty,
      'translation': translation,
      'phonemes': phonemes,
      'is_unlocked': isUnlocked,
      'best_score': bestScore,
      'completed_at': completedAt?.toIso8601String(),
    };
  }

  TongueTwister copyWith({
    int? id,
    String? text,
    String? language,
    String? difficulty,
    String? translation,
    List<String>? phonemes,
    bool? isUnlocked,
    int? bestScore,
    DateTime? completedAt,
  }) {
    return TongueTwister(
      id: id ?? this.id,
      text: text ?? this.text,
      language: language ?? this.language,
      difficulty: difficulty ?? this.difficulty,
      translation: translation ?? this.translation,
      phonemes: phonemes ?? this.phonemes,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      bestScore: bestScore ?? this.bestScore,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  bool get isCompleted => completedAt != null;
  
  String get difficultyEmoji {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return '🟢';
      case 'medium':
        return '🟡';
      case 'hard':
        return '🟠';
      case 'master':
        return '🔴';
      default:
        return '⚪';
    }
  }

  @override
  List<Object?> get props => [
        id, 
        text, 
        language, 
        difficulty, 
        translation, 
        phonemes, 
        isUnlocked, 
        bestScore, 
        completedAt
      ];
}
