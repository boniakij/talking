import 'package:equatable/equatable.dart';

abstract class MatchingEvent extends Equatable {
  const MatchingEvent();

  @override
  List<Object?> get props => [];
}

class LoadPotentialMatches extends MatchingEvent {}

class SwipeRight extends MatchingEvent {
  final int userId;

  const SwipeRight(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SwipeLeft extends MatchingEvent {
  final int userId;

  const SwipeLeft(this.userId);

  @override
  List<Object?> get props => [userId];
}

class SuperLike extends MatchingEvent {
  final int userId;

  const SuperLike(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UndoLastSwipe extends MatchingEvent {}

class RefreshMatches extends MatchingEvent {}

class FilterMatches extends MatchingEvent {
  final String? language;
  final int? minAge;
  final int? maxAge;
  final List<String>? interests;

  const FilterMatches({
    this.language,
    this.minAge,
    this.maxAge,
    this.interests,
  });

  @override
  List<Object?> get props => [language, minAge, maxAge, interests];
}
