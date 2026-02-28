import 'package:equatable/equatable.dart';
import '../models/pronunciation_score.dart';
import '../models/tongue_twister.dart';
import '../models/leaderboard_entry.dart';

abstract class SlState extends Equatable {
  const SlState();

  @override
  List<Object?> get props => [];
}

class SlInitial extends SlState {}

class SlLoading extends SlState {}

class TongueTwistersLoaded extends SlState {
  final List<TongueTwister> tongueTwisters;

  const TongueTwistersLoaded(this.tongueTwisters);

  @override
  List<Object?> get props => [tongueTwisters];
}

class PronunciationScoreLoaded extends SlState {
  final PronunciationScore score;

  const PronunciationScoreLoaded(this.score);

  @override
  List<Object?> get props => [score];
}

class LeaderboardLoaded extends SlState {
  final List<LeaderboardEntry> entries;

  const LeaderboardLoaded(this.entries);

  @override
  List<Object?> get props => [entries];
}

class RecordingInProgress extends SlState {
  final bool isRecording;

  const RecordingInProgress(this.isRecording);

  @override
  List<Object?> get props => [isRecording];
}

class SlError extends SlState {
  final String message;

  const SlError(this.message);

  @override
  List<Object?> get props => [message];
}
