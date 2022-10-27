part of 'launches_bloc.dart';

abstract class LaunchesState {}

// Loading State
class LaunchesLoadingState extends LaunchesState {
  @override
  List<Object?> get props => [];
}

// Loaded State
class LaunchesLoadedState extends LaunchesState {
  final List<Launches> launches;

  LaunchesLoadedState(this.launches);

  @override
  List<Object?> get props => [launches];
}

// Error State
class LaunchesErrorState extends LaunchesState {
  final String error;

  LaunchesErrorState(this.error);

  @override
  List<Object?> get props => [error];
}
