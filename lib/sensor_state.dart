import 'package:equatable/equatable.dart';
import 'model/sensor.dart' ;

class SensorState extends Equatable{

  final List<Sensor> sensors;
  final String searchQuery;

  const SensorState ({this.sensors = const [], this.searchQuery=''});

  SensorState copyWith({List<Sensor>? sensors, String? searchQuery}){
    return SensorState(
      sensors: sensors ?? this.sensors,
      searchQuery: searchQuery ?? this.searchQuery
    );
  }

  @override
  List<Object?> get props => [sensors];
}