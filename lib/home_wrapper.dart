import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'sensor_bloc.dart';
import 'repository/sensor_repository.dart'; 
import 'sensor_event.dart';
import 'home.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SensorBloc(SensorRepository())
        ..add(StartSensorUpdates()),
      child: const HomeScreen(),
    );
  }
}
