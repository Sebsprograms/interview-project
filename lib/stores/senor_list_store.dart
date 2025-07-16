import 'package:interview_project/model/sensor.dart';
import 'package:interview_project/repository/sensor_repository.dart';
import 'package:mobx/mobx.dart';

part 'senor_list_store.g.dart';

enum TemperatureSort { ascending, descending, none }

// ignore: library_private_types_in_public_api
class SensorListStore = _SensorListStore with _$SensorListStore;

abstract class _SensorListStore with Store {
  final SensorRepository sensorRepository;

  _SensorListStore(this.sensorRepository) {
    sensorRepository.initializeSensors();
    watchSensors();
  }

  @observable
  ObservableList<Sensor?> sensors = ObservableList.of([]);

  @observable
  String searchQuery = '';

  @observable
  TemperatureSort isSortedByTemperature = TemperatureSort.none;

  @action
  watchSensors() {
    sensorRepository.sensorsStream.listen((List<Sensor> sensors) {
      List<Sensor> filteredSensors = sensors;

      // Apply search filter if query exists
      if (searchQuery.isNotEmpty) {
        filteredSensors = sensors
            .where(
              (sensor) =>
                  sensor.name.toLowerCase().contains(searchQuery.toLowerCase()),
            )
            .toList();
      }

      if (isSortedByTemperature == TemperatureSort.ascending) {
        filteredSensors.sort((a, b) => a.value.compareTo(b.value));
      } else if (isSortedByTemperature == TemperatureSort.descending) {
        filteredSensors.sort((a, b) => b.value.compareTo(a.value));
      }

      updateSensorsObservable(filteredSensors);
    });
  }

  @action
  List<Sensor?> searchSensors(String query) {
    searchQuery = query;
    final filteredSensors = sensors
        .where(
          (Sensor? sensor) =>
              sensor?.name.toLowerCase().contains(query.toLowerCase()) ?? false,
        )
        .toList();
    return filteredSensors;
  }

  @action
  List<Sensor?> sortSensorsByTemperature() {
    List<Sensor?> sortedSensors = sensors.toList();
    switch (isSortedByTemperature) {
      case TemperatureSort.none:
        isSortedByTemperature = TemperatureSort.ascending;
        sortedSensors.sort((a, b) => (a?.value ?? 0).compareTo(b?.value ?? 0));
        break;
      case TemperatureSort.ascending:
        isSortedByTemperature = TemperatureSort.descending;
        sortedSensors.sort((a, b) => (b?.value ?? 0).compareTo(a?.value ?? 0));
        break;
      case TemperatureSort.descending:
        isSortedByTemperature = TemperatureSort.none;
        sortedSensors = sensors.toList();
        break;
    }
    sensors = ObservableList.of(sortedSensors);
    return sortedSensors;
  }

  @action
  void updateSensorsObservable(List<Sensor> sensors) {
    this.sensors = ObservableList.of(sensors);
  }

  @action
  void updateSensorName(String name, Sensor sensor) {
    final newSensor = sensor.copyWith(name: name);
    sensorRepository.updateSensor(newSensor);
  }

  @action
  void updateSensor(Sensor sensor) {
    sensorRepository.updateSensor(sensor);
  }
}
