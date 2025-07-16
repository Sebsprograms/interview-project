import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:interview_project/model/sensor.dart';
import 'package:rxdart/subjects.dart';

class SensorRepository {
  final BehaviorSubject<List<Sensor>> _sensorsSubject =
      BehaviorSubject<List<Sensor>>();

  Stream<List<Sensor>> get sensorsStream => _sensorsSubject.stream;

  /// Initializes 10 random sensors and starts updating their [Sensor.value] every 5 seconds
  void initializeSensors() {
    final sensors = List.generate(10, (index) => Sensor.random());
    _sensorsSubject.add(sensors);

    Timer.periodic(const Duration(seconds: 5), (timer) {
      for (var sensor in _sensorsSubject.value) {
        updateSensor(sensor.copyWith(value: Random().nextDouble() * 100));
      }
    });
  }

  /// Updates a sensor in the repository
  void updateSensor(Sensor sensor) {
    final sensors = List<Sensor>.from(_sensorsSubject.value);
    final index = sensors.indexWhere((s) => s.id == sensor.id);
    if (index != -1) {
      sensors[index] = sensor;
      _sensorsSubject.add(sensors);
    }
  }
}
