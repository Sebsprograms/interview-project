import 'package:equatable/equatable.dart';
import 'model/sensor.dart';

abstract class SensorEvent extends Equatable {
  const SensorEvent();
  @override
  List<Object?> get props => [];
}

class StartSensorUpdates extends SensorEvent {}

class SensorsUpdated extends SensorEvent {
  final List<Sensor> sensors;
  const SensorsUpdated(this.sensors);
  @override
  List<Object?> get props => [sensors];
}

class UpdateSensorEvent extends SensorEvent {
  final Sensor sensor;
  const UpdateSensorEvent(this.sensor);
  
  @override
  List<Object?> get props => [sensor];
}

class UpdateSensorValue extends SensorEvent {
  final Sensor sensor;
  const UpdateSensorValue(this.sensor);
  
  @override
  List<Object?> get props => [sensor];
}

class SearchSensorEvent extends SensorEvent {
  final String query;
  const SearchSensorEvent(this.query);
  
  @override
  List<Object?> get props => [query];
}

class EditSensorDetails extends SensorEvent {
  final int sensorId;
  final String sensorName;
  final String sensorDescription;


  const EditSensorDetails(
    this.sensorId, 
    this.sensorName, 
    this.sensorDescription
  );  
}