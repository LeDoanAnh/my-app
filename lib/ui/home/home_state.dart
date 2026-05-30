import 'package:equatable/equatable.dart';
import 'package:my_app/domain/entities/submission_entity.dart';
import 'package:my_app/domain/entities/submission_stats_entity.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final SubmissionStatsEntity stats;
  final List<SubmissionEntity> recentSubmissions;

  const HomeLoaded({required this.stats, required this.recentSubmissions});

  @override
  List<Object?> get props => [stats, recentSubmissions];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
