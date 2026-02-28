import 'package:flutter_bloc/flutter_bloc.dart';
import 'matching_event.dart';
import 'matching_state.dart';
import '../services/matching_service.dart';
import '../models/potential_match.dart';

class MatchingBloc extends Bloc<MatchingEvent, MatchingState> {
  final MatchingService _matchingService;
  List<PotentialMatch> _currentMatches = [];
  int _currentIndex = 0;
  int? _lastSwipedUserId;
  bool _lastSwipeWasRight = false;

  MatchingBloc(this._matchingService) : super(MatchingInitial()) {
    on<LoadPotentialMatches>(_onLoadPotentialMatches);
    on<SwipeRight>(_onSwipeRight);
    on<SwipeLeft>(_onSwipeLeft);
    on<SuperLike>(_onSuperLike);
    on<UndoLastSwipe>(_onUndoLastSwipe);
    on<RefreshMatches>(_onRefreshMatches);
    on<FilterMatches>(_onFilterMatches);
  }

  Future<void> _onLoadPotentialMatches(
    LoadPotentialMatches event,
    Emitter<MatchingState> emit,
  ) async {
    emit(MatchingLoading());
    try {
      final matches = await _matchingService.getPotentialMatches();
      _currentMatches = matches;
      _currentIndex = 0;
      emit(PotentialMatchesLoaded(matches));
    } catch (e) {
      emit(MatchingError('Failed to load matches: ${e.toString()}'));
    }
  }

  Future<void> _onSwipeRight(
    SwipeRight event,
    Emitter<MatchingState> emit,
  ) async {
    try {
      final result = await _matchingService.likeUser(event.userId);
      _lastSwipedUserId = event.userId;
      _lastSwipeWasRight = true;

      if (result.isMatch) {
        final match = _currentMatches.firstWhere((m) => m.id == event.userId);
        emit(MatchSuccess(match));
      }

      _currentIndex++;
      if (_currentIndex >= _currentMatches.length) {
        emit(MatchesExhausted());
      } else {
        emit(PotentialMatchesLoaded(_currentMatches, currentIndex: _currentIndex));
      }
    } catch (e) {
      emit(MatchingError('Failed to like user: ${e.toString()}'));
    }
  }

  Future<void> _onSwipeLeft(
    SwipeLeft event,
    Emitter<MatchingState> emit,
  ) async {
    try {
      await _matchingService.passUser(event.userId);
      _lastSwipedUserId = event.userId;
      _lastSwipeWasRight = false;

      _currentIndex++;
      if (_currentIndex >= _currentMatches.length) {
        emit(MatchesExhausted());
      } else {
        emit(PotentialMatchesLoaded(_currentMatches, currentIndex: _currentIndex));
      }
    } catch (e) {
      emit(MatchingError('Failed to pass user: ${e.toString()}'));
    }
  }

  Future<void> _onSuperLike(
    SuperLike event,
    Emitter<MatchingState> emit,
  ) async {
    try {
      final result = await _matchingService.superLikeUser(event.userId);
      _lastSwipedUserId = event.userId;
      _lastSwipeWasRight = true;

      if (result.isMatch) {
        final match = _currentMatches.firstWhere((m) => m.id == event.userId);
        emit(MatchSuccess(match));
      }

      _currentIndex++;
      if (_currentIndex >= _currentMatches.length) {
        emit(MatchesExhausted());
      } else {
        emit(PotentialMatchesLoaded(_currentMatches, currentIndex: _currentIndex));
      }
    } catch (e) {
      emit(MatchingError('Failed to super like: ${e.toString()}'));
    }
  }

  Future<void> _onUndoLastSwipe(
    UndoLastSwipe event,
    Emitter<MatchingState> emit,
  ) async {
    if (_lastSwipedUserId != null) {
      try {
        await _matchingService.undoSwipe(_lastSwipedUserId!);
        if (_currentIndex > 0) {
          _currentIndex--;
        }
        emit(PotentialMatchesLoaded(_currentMatches, currentIndex: _currentIndex));
      } catch (e) {
        emit(MatchingError('Failed to undo swipe: ${e.toString()}'));
      }
    }
  }

  Future<void> _onRefreshMatches(
    RefreshMatches event,
    Emitter<MatchingState> emit,
  ) async {
    add(LoadPotentialMatches());
  }

  Future<void> _onFilterMatches(
    FilterMatches event,
    Emitter<MatchingState> emit,
  ) async {
    emit(MatchingLoading());
    try {
      final matches = await _matchingService.getPotentialMatches(
        language: event.language,
        minAge: event.minAge,
        maxAge: event.maxAge,
        interests: event.interests,
      );
      _currentMatches = matches;
      _currentIndex = 0;
      emit(PotentialMatchesLoaded(matches));
    } catch (e) {
      emit(MatchingError('Failed to filter matches: ${e.toString()}'));
    }
  }
}
