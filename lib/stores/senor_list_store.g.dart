// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'senor_list_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SensorListStore on _SensorListStore, Store {
  late final _$sensorsAtom = Atom(
    name: '_SensorListStore.sensors',
    context: context,
  );

  @override
  ObservableList<Sensor?> get sensors {
    _$sensorsAtom.reportRead();
    return super.sensors;
  }

  @override
  set sensors(ObservableList<Sensor?> value) {
    _$sensorsAtom.reportWrite(value, super.sensors, () {
      super.sensors = value;
    });
  }

  late final _$searchQueryAtom = Atom(
    name: '_SensorListStore.searchQuery',
    context: context,
  );

  @override
  String get searchQuery {
    _$searchQueryAtom.reportRead();
    return super.searchQuery;
  }

  @override
  set searchQuery(String value) {
    _$searchQueryAtom.reportWrite(value, super.searchQuery, () {
      super.searchQuery = value;
    });
  }

  late final _$temperatureSortStateAtom = Atom(
    name: '_SensorListStore.temperatureSortState',
    context: context,
  );

  @override
  TemperatureSort get temperatureSortState {
    _$temperatureSortStateAtom.reportRead();
    return super.temperatureSortState;
  }

  @override
  set temperatureSortState(TemperatureSort value) {
    _$temperatureSortStateAtom.reportWrite(
      value,
      super.temperatureSortState,
      () {
        super.temperatureSortState = value;
      },
    );
  }

  late final _$_SensorListStoreActionController = ActionController(
    name: '_SensorListStore',
    context: context,
  );

  @override
  dynamic watchSensors() {
    final _$actionInfo = _$_SensorListStoreActionController.startAction(
      name: '_SensorListStore.watchSensors',
    );
    try {
      return super.watchSensors();
    } finally {
      _$_SensorListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<Sensor?> searchSensors(String query) {
    final _$actionInfo = _$_SensorListStoreActionController.startAction(
      name: '_SensorListStore.searchSensors',
    );
    try {
      return super.searchSensors(query);
    } finally {
      _$_SensorListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  List<Sensor?> sortSensorsByTemperature() {
    final _$actionInfo = _$_SensorListStoreActionController.startAction(
      name: '_SensorListStore.sortSensorsByTemperature',
    );
    try {
      return super.sortSensorsByTemperature();
    } finally {
      _$_SensorListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateSensorsObservable(List<Sensor> sensors) {
    final _$actionInfo = _$_SensorListStoreActionController.startAction(
      name: '_SensorListStore.updateSensorsObservable',
    );
    try {
      return super.updateSensorsObservable(sensors);
    } finally {
      _$_SensorListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateSensorName(String name, Sensor sensor) {
    final _$actionInfo = _$_SensorListStoreActionController.startAction(
      name: '_SensorListStore.updateSensorName',
    );
    try {
      return super.updateSensorName(name, sensor);
    } finally {
      _$_SensorListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateSensor(Sensor sensor) {
    final _$actionInfo = _$_SensorListStoreActionController.startAction(
      name: '_SensorListStore.updateSensor',
    );
    try {
      return super.updateSensor(sensor);
    } finally {
      _$_SensorListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetTemperatureSort() {
    final _$actionInfo = _$_SensorListStoreActionController.startAction(
      name: '_SensorListStore.resetTemperatureSort',
    );
    try {
      return super.resetTemperatureSort();
    } finally {
      _$_SensorListStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
sensors: ${sensors},
searchQuery: ${searchQuery},
temperatureSortState: ${temperatureSortState}
    ''';
  }
}
