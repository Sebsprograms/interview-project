import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:interview_project/model/sensor.dart';
import 'package:interview_project/repository/sensor_repository.dart';


/* Architerual/Design choices:
- I picked cubit over bloc primarily for speed of development. 
- I went with the enum route for State Status instead of individual 
  states also for speed of development, personally i tend to prefer individual states typically.
- Dropped the use of Equatables, using status enum made it not really 
  necessary, although typically Equatable and "state is LoadedState"/etc is how I check states
*/

enum StateStatus { initial, loading, loaded, error }

class SensorsState {
  final StateStatus status;
  final List<Sensor> sensors;
  final List<Sensor> filteredSensors;
  final String searchQuery;
  final String? errorMessage;

  const SensorsState({
    required this.status,
    required this.sensors,
    required this.filteredSensors,
    this.searchQuery = '',
    this.errorMessage,
  });

  SensorsState copyWith({
    StateStatus? status,
    List<Sensor>? sensors,
    List<Sensor>? filteredSensors,
    String? searchQuery,
    String? errorMessage,
  }) {
    return SensorsState(
      status: status ?? this.status,
      sensors: sensors ?? this.sensors,
      filteredSensors: filteredSensors ?? this.filteredSensors,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

}

class SensorsCubit extends Cubit<SensorsState> {
  final SensorRepository _sensorRepository;
  StreamSubscription<List<Sensor>>? _sensorSubscription;

  SensorsCubit(this._sensorRepository)
    : super(
        const SensorsState(
          status: StateStatus.initial,
          sensors: [],
          filteredSensors: [],
        ),
      );

  void initialize() {
    emit(state.copyWith(status: StateStatus.loading));
    
    try {
      _sensorRepository.initializeSensors();
      _sensorSubscription = _sensorRepository.sensorsStream.listen(
        (sensors) => _updateSensorsWithSearch(sensors, state.searchQuery),
        onError: (error) => emit(state.copyWith(
          status: StateStatus.error,
          errorMessage: error.toString(),
        )),
      );
    } catch (error) {
      emit(state.copyWith(
        status: StateStatus.error,
        errorMessage: error.toString(),
      ));
    }
  }

  void searchSensors(String query) {
    if (state.status == StateStatus.loaded) {
      _updateSensorsWithSearch(state.sensors, query);
    }
  }

  void _updateSensorsWithSearch(List<Sensor> sensors, String query) {
    final filteredSensors = query.isEmpty
        ? sensors
        : sensors.where((sensor) => sensor.matchesSearchQuery(query)).toList();

    emit(state.copyWith(
      status: StateStatus.loaded,
      sensors: sensors,
      filteredSensors: filteredSensors,
      searchQuery: query,
    ));
  }

  void updateSensorDetails(Sensor newSensor) {
    try {
      _sensorRepository.updateSensor(newSensor);
    } catch (error) {
      emit(state.copyWith(
        status: StateStatus.error,
        errorMessage: error.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    _sensorSubscription?.cancel();
    return super.close();
  }
}
