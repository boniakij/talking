import 'package:equatable/equatable.dart';

class PronunciationScore extends Equatable {
  final double overallScore;
  final Map<String, double> phonemeScores;
  final List<String> feedback;
  final String recordingPath;
  final DateTime timestamp;

  const PronunciationScore({
    required this.overallScore,
    required this.phonemeScores,
    required this.feedback,
    required this.recordingPath,
    required this.timestamp,
  });

  factory PronunciationScore.fromJson(Map<String, dynamic> json) {
    return PronunciationScore(
      overallScore: (json['overall_score'] as num).toDouble(),
      phonemeScores: Map<String, double>.from(
        json['phoneme_scores'].map((key, value) => MapEntry(key, (value as num).toDouble()))
      ),
      feedback: List<String>.from(json['feedback']),
      recordingPath: json['recording_path'] ?? '',
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'overall_score': overallScore,
      'phoneme_scores': phonemeScores,
      'feedback': feedback,
      'recording_path': recordingPath,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  String get scoreGrade {
    if (overallScore >= 90) return 'Excellent';
    if (overallScore >= 80) return 'Good';
    if (overallScore >= 70) return 'Fair';
    if (overallScore >= 60) return 'Needs Work';
    return 'Keep Practicing';
  }

  String get scoreColor {
    if (overallScore >= 90) => '#4CAF50';
    if (overallScore >= 80) => '#8BC34A';
    if (overallScore >= 70) => '#FFC107';
    if (overallScore >= 60) => '#FF9800';
    return '#F44336';
  }

  @override
  List<Object?> get props => [overallScore, phonemeScores, feedback, recordingPath, timestamp];
}
