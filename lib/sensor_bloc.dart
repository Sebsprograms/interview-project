import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sensor_event.dart';
import 'sensor_state.dart';
import 'repository/sensor_repository.dart';
import 'model/sensor.dart';
import 'dart:math';

class SensorBloc extends Bloc<SensorEvent, SensorState> {
  
  final SensorRepository repository;
  late final StreamSubscription _sensorSub;

  SensorBloc(this.repository) : super(const SensorState()) {
    on<StartSensorUpdates>((event, emit) {
      repository.initializeSensors();
      _sensorSub = repository.sensorsStream.listen(
        (sensorList) => add(SensorsUpdated(sensorList)),
      );
    });

    on<SensorsUpdated>((event, emit) {
      emit(state.copyWith(
        sensors: event.sensors, 
        searchQuery: state.searchQuery
        ));
    });

    on<UpdateSensorEvent>((event, emit) {
      repository.updateSensor(event.sensor);
      final updatedSensors = List<Sensor>.from(state.sensors);
      final index = updatedSensors.indexWhere((s) => s.id == event.sensor.id);
      if (index != -1) {
        updatedSensors[index] = event.sensor;
        emit(state.copyWith(
          sensors: updatedSensors,
          searchQuery: state.searchQuery,
        ));
      }
    });

    on<UpdateSensorValue>((event, emit) {
      repository.updateSensor(event.sensor.copyWith(value: 72));
    });


    on<SearchSensorEvent>((event,emit){
      emit(state.copyWith(searchQuery: event.query));
    });

    on<EditSensorDetails>((event, emit) {
      final sensor = state.sensors.firstWhere((s) => s.id == event.sensorId);
      final updated = sensor.copyWith(
      name: event.sensorName,
      description: event.sensorDescription
      );
    repository.updateSensor(updated);
  });

  @override
  Future<void> close() {
    _sensorSub.cancel();
    return super.close();
  }
}
}