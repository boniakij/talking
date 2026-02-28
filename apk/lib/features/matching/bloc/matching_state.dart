import 'package:equatable/equatable.dart';
import 'potential_match.dart';

abstract class MatchingState extends Equatable {
  const MatchingState();

  @override
  List<Object?> get props => [];
}

class MatchingInitial extends MatchingState {}

class MatchingLoading extends MatchingState {}

class PotentialMatchesLoaded extends MatchingState {
  final List<PotentialMatch> matches;
  final int currentIndex;

  const PotentialMatchesLoaded(this.matches, {this.currentIndex = 0});

  PotentialMatch? get currentMatch => 
      currentIndex < matches.length ? matches[currentIndex] : null;

  bool get hasMoreMatches => currentIndex < matches.length;

  @override
  List<Object?> get props => [matches, currentIndex];
}

class MatchSuccess extends MatchingState {
  final PotentialMatch match;

  const MatchSuccess(this.match);

  @override
  List<Object?> get props => [match];
}

class MatchRejected extends MatchingState {
  final int userId;

  const MatchRejected(this.userId);

  @override
  List<Object?> get props => [userId];
}

class MatchesExhausted extends MatchingState {}

class MatchingError extends MatchingState {
  final String message;

  const MatchingError(this.message);

  @override
  List<Object?> get props => [message];
}
