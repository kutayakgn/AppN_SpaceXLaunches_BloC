part of 'launches_bloc.dart';

abstract class LaunchesEvent {
  const LaunchesEvent();
}

// Load Launches Event class
class LoadLaunchesEvent extends LaunchesEvent {
  @override
  List<Object> get props => [];
}

// Pull to refresh Event Class
class PullToRefreshEvent extends LaunchesEvent {}
