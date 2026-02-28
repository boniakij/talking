import 'package:flutter_bloc/flutter_bloc.dart';
import 'sl_event.dart';
import 'sl_state.dart';
import '../services/sl_service.dart';
import '../models/tongue_twister.dart';
import '../models/pronunciation_score.dart';
import '../models/leaderboard_entry.dart';

class SlBloc extends Bloc<SlEvent, SlState> {
  final SlService _slService;

  SlBloc(this._slService) : super(SlInitial()) {
    on<LoadTongueTwisters>(_onLoadTongueTwisters);
    on<StartRecording>(_onStartRecording);
    on<StopRecording>(_onStopRecording);
    on<AnalyzePronunciation>(_onAnalyzePronunciation);
    on<LoadLeaderboard>(_onLoadLeaderboard);
    on<UnlockTongueTwister>(_onUnlockTongueTwister);
    on<SaveScore>(_onSaveScore);
  }

  Future<void> _onLoadTongueTwisters(
    LoadTongueTwisters event,
    Emitter<SlState> emit,
  ) async {
    emit(SlLoading());
    try {
      final tongueTwisters = await _slService.getTongueTwisters();
      emit(TongueTwistersLoaded(tongueTwisters));
    } catch (e) {
      emit(SlError('Failed to load tongue twisters: ${e.toString()}'));
    }
  }

  Future<void> _onStartRecording(
    StartRecording event,
    Emitter<SlState> emit,
  ) async {
    try {
      emit(RecordingInProgress(true));
      await _slService.startRecording();
    } catch (e) {
      emit(SlError('Failed to start recording: ${e.toString()}'));
    }
  }

  Future<void> _onStopRecording(
    StopRecording event,
    Emitter<SlState> emit,
  ) async {
    try {
      final audioPath = await _slService.stopRecording();
      emit(RecordingInProgress(false));
    } catch (e) {
      emit(SlError('Failed to stop recording: ${e.toString()}'));
    }
  }

  Future<void> _onAnalyzePronunciation(
    AnalyzePronunciation event,
    Emitter<SlState> emit,
  ) async {
    emit(SlLoading());
    try {
      final score = await _slService.analyzePronunciation(
        event.audioPath,
        event.targetText,
      );
      emit(PronunciationScoreLoaded(score));
    } catch (e) {
      emit(SlError('Failed to analyze pronunciation: ${e.toString()}'));
    }
  }

  Future<void> _onLoadLeaderboard(
    LoadLeaderboard event,
    Emitter<SlState> emit,
  ) async {
    emit(SlLoading());
    try {
      final leaderboard = await _slService.getLeaderboard();
      emit(LeaderboardLoaded(leaderboard));
    } catch (e) {
      emit(SlError('Failed to load leaderboard: ${e.toString()}'));
    }
  }

  Future<void> _onUnlockTongueTwister(
    UnlockTongueTwister event,
    Emitter<SlState> emit,
  ) async {
    try {
      await _slService.unlockTongueTwister(event.twisterId);
      add(LoadTongueTwisters());
    } catch (e) {
      emit(SlError('Failed to unlock tongue twister: ${e.toString()}'));
    }
  }

  Future<void> _onSaveScore(
    SaveScore event,
    Emitter<SlState> emit,
  ) async {
    try {
      await _slService.saveScore(event.twisterId, event.score);
      add(LoadTongueTwisters());
    } catch (e) {
      emit(SlError('Failed to save score: ${e.toString()}'));
    }
  }
}
