import 'package:equatable/equatable.dart';

abstract class SlEvent extends Equatable {
  const SlEvent();

  @override
  List<Object?> get props => [];
}

class LoadTongueTwisters extends SlEvent {}

class StartRecording extends SlEvent {}

class StopRecording extends SlEvent {}

class AnalyzePronunciation extends SlEvent {
  final String audioPath;
  final String targetText;

  const AnalyzePronunciation(this.audioPath, this.targetText);

  @override
  List<Object?> get props => [audioPath, targetText];
}

class LoadLeaderboard extends SlEvent {}

class UnlockTongueTwister extends SlEvent {
  final int twisterId;

  const UnlockTongueTwister(this.twisterId);

  @override
  List<Object?> get props => [twisterId];
}

class SaveScore extends SlEvent {
  final int twisterId;
  final int score;

  const SaveScore(this.twisterId, this.score);

  @override
  List<Object?> get props => [twisterId, score];
}
