import 'package:flutter/material.dart';
import 'package:interview_project/edit_sensor.dart';
import 'package:interview_project/repository/sensor_repository.dart';
import 'package:interview_project/stores/senor_list_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:interview_project/stores/senor_list_store.dart'
    show TemperatureSort;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Icon _getSortIcon(TemperatureSort sortState) {
    switch (sortState) {
      case TemperatureSort.ascending:
        return const Icon(Icons.arrow_upward);
      case TemperatureSort.descending:
        return const Icon(Icons.arrow_downward);
      case TemperatureSort.none:
        return const Icon(Icons.unfold_more);
    }
  }

  @override
  Widget build(BuildContext context) {
    final sensorRepository = SensorRepository();
    final sensorListStore = SensorListStore(sensorRepository);

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Sensor List')),
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: InputDecoration(
                hintText: 'Search Sensors',
                suffix: IconButton(
                  onPressed: () {
                    sensorListStore.searchSensors(sensorListStore.searchQuery);
                  },
                  icon: const Icon(Icons.search),
                ),
              ),
              onChanged: (value) {
                sensorListStore.searchSensors(value);
              },
              onEditingComplete: () {
                sensorListStore.searchSensors(sensorListStore.searchQuery);
              },
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Sort by temperature'),
                  Observer(
                    builder: (context) => IconButton(
                      onPressed: () {
                        sensorListStore.sortSensorsByTemperature();
                      },
                      icon: _getSortIcon(sensorListStore.isSortedByTemperature),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Observer(
                builder: (context) {
                  if (sensorListStore.sensors.isEmpty) {
                    return const Center(child: Text('No sensors found'));
                  }
                  return ListView.builder(
                    itemCount: sensorListStore.sensors.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(sensorListStore.sensors[index]?.name ?? ''),
                        subtitle: Text(
                          sensorListStore.sensors[index]?.description ?? '',
                        ),
                        trailing: Text(
                          sensorListStore.sensors[index]?.value.toStringAsFixed(
                                3,
                              ) ??
                              '',
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditSensor(
                                sensor: sensorListStore.sensors[index]!,
                                store: sensorListStore,

                                /// would be better to have store accessed via DI or provider
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
