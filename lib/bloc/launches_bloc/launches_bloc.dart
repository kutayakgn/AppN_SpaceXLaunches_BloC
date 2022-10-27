import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:space_x_last_launch/datas/model/launches_model.dart';
import 'package:space_x_last_launch/datas/repos/launches_repository.dart';

part 'launches_event.dart';
part 'launches_state.dart';

// Bloc for Launches
class LaunchesBloc extends Bloc<LaunchesEvent, LaunchesState> {
  // RepositoryBloc
  final LaunchesRepository _launchRepository;

  LaunchesBloc(this._launchRepository) : super(LaunchesLoadingState()) {
    // Lines that will work on LoadLaunches Event
    on<LoadLaunchesEvent>((event, emit) async {
      emit(LaunchesLoadingState());
      try {
        //Get launches from http
        final launches = await _launchRepository.getLaunches();
        //Load the state
        emit(LaunchesLoadedState(launches));
      } catch (e) {
        emit(LaunchesErrorState(e.toString()));
      }
    });
    // Lines that will work on PullToRefresh Event
    on<PullToRefreshEvent>((event, emit) async {
      emit(LaunchesLoadingState());
      try {
        //Get launches from http
        final launches = await _launchRepository.getLaunches();
        //Load the state
        emit(LaunchesLoadedState(launches));
      } catch (e) {
        emit(LaunchesErrorState(e.toString()));
      }
    });
  }
}
