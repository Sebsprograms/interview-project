import 'package:interview_project/model/sensor.dart';
import 'package:interview_project/repository/sensor_repository.dart';
import 'package:mobx/mobx.dart';

part 'senor_list_store.g.dart';

enum TemperatureSort { ascending, descending, none }

const TemperatureSort _defaultTemperatureSort = TemperatureSort.none;

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

  /// Current temperature sorting state (none, ascending, descending)
  @observable
  TemperatureSort temperatureSortState = _defaultTemperatureSort;

  /// Returns a human-readable description of the current sort state
  String get sortStateDescription {
    switch (temperatureSortState) {
      case TemperatureSort.none:
        return 'No sorting';
      case TemperatureSort.ascending:
        return 'Temperature: Low to High';
      case TemperatureSort.descending:
        return 'Temperature: High to Low';
    }
  }

  @action
  watchSensors() {
    sensorRepository.sensorsStream.listen((List<Sensor> sensors) {
      try {
        List<Sensor> filteredSensors = sensors;

        // Apply search filter if query exists
        if (searchQuery.isNotEmpty) {
          filteredSensors = _applySearchFilter(sensors, searchQuery);
        }
        _applyTemperatureSort(filteredSensors);

        updateSensorsObservable(filteredSensors);
      } catch (e) {
        // Handle any errors during sensor processing
        print('Error processing sensors: $e');
      }
    });
  }

  /// Applies search filter to the given sensor list
  List<Sensor> _applySearchFilter(List<Sensor> sensors, String query) {
    return sensors
        .where(
          (sensor) => sensor.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  /// Applies temperature sorting to the given sensor list based on current state
  void _applyTemperatureSort(List<Sensor?> sensors) {
    switch (temperatureSortState) {
      case TemperatureSort.ascending:
        sensors.sort((a, b) => (a?.value ?? 0).compareTo(b?.value ?? 0));
        break;
      case TemperatureSort.descending:
        sensors.sort((a, b) => (b?.value ?? 0).compareTo(a?.value ?? 0));
        break;
      case TemperatureSort.none:
        // No sorting needed
        break;
    }
  }

  @action
  List<Sensor?> searchSensors(String query) {
    searchQuery = query.trim();
    if (searchQuery.isEmpty) {
      return sensors.toList();
    }
    return sensors
        .where(
          (Sensor? sensor) =>
              sensor?.name.toLowerCase().contains(searchQuery.toLowerCase()) ??
              false,
        )
        .toList();
  }

  /// Cycles through temperature sort states: none → ascending → descending → none
  @action
  List<Sensor?> sortSensorsByTemperature() {
    // Cycle to next sort state
    switch (temperatureSortState) {
      case TemperatureSort.none:
        temperatureSortState = TemperatureSort.ascending;
        break;
      case TemperatureSort.ascending:
        temperatureSortState = TemperatureSort.descending;
        break;
      case TemperatureSort.descending:
        temperatureSortState = TemperatureSort.none;
        break;
    }

    // Apply sorting to current sensors
    final sortedSensors = sensors.toList();
    _applyTemperatureSort(sortedSensors);
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

  /// Resets temperature sort state to none
  @action
  void resetTemperatureSort() {
    temperatureSortState = _defaultTemperatureSort;
  }
}
